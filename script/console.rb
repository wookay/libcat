#! /usr/bin/ruby
# encoding: utf-8
# console.rb
#                           wookay.noh at gmail.com

DIR = "#{File.dirname __FILE__}"
$LOAD_PATH.unshift DIR
require 'ui_shell'
require 'net/http'
require 'timeout'
require 'fileutils'

EVENTS_PATH = "#{ENV['HOME']}/.console/events"
FileUtils.mkdir_p EVENTS_PATH

SPACE = ' '
COLON = ':'
PROMPT = '> '
CONSOLE_VERSION = 0.3
ABOUT = <<EOF
libcat Console #{CONSOLE_VERSION}
Copyright (c) 2010, 2011 WooKyoung Noh
EOF

DEFAULT_ENV_COLUMNS = 100
$COLUMNS = 100 #`tput cols`.to_i

def print_help
  help_pages = []
  help_pages.push <<EOF
ls TARGET           : list target object (l)      
  > ls              : list current object         
  > ls -r           : list recursive              
cd TARGET           : change target object        
  > cd              : to topViewController        
  > cd .            : to self            
  > cd ..           : to superview       
  > cd /            : to rootViewController
  > cd ~            : to keyWindow
  > cd ~~           : to UIApplication
  > cd 0            : at index as listed          
  > cd 1 0          : at section and row
  > cd -1 0         : at index on toolbar
  > cd Title        : labeled as Title   
  > cd view         : to property        
  > cd UIButton     : to class           
  > cd 0x6067490    : at memory address           
pwd                 : view & controller hierarchy 
properties TARGET   : list properties (p)         
  > text            : property getter             
  > text = hello    : property setter             
manipulate TARGET   : manipulate properties UI
open                : open Safari UI
touch TARGET        : touch target UI (t)  
back                : popViewController UI (b)
rm TARGET           : removeFromSuperview UI      
flick TARGET        : flick target UI (f)  
png TARGET          : capture target as image UI
fill_rect RECT      : fill rect UI
add_ui UILabel      : add UI
hit                 : hitTest UI on/off
EOF
  help_pages.push <<EOF
help     : help (h)
quit     : quit (q)
about    : about libcat Console
clear    : clear the screen
history  : input commands history
sleep N  : sleep N seconds

events                   : list touch events (e)
  > events record        : record on/off (er)
  > events play          : play events (ep)
  > events cut N         : cut N events (ex)
  > events clear         : clear events (ec)
  > events replay NAME   : replay events (ee)
  > events save NAME     : save events (es)
  > events load NAME     : load events (el)

enum ENUMTYPE            : enum type info
  > enum UITextAlignmentLeft
  > enum UITextAlignment

map ARGS
  > view.subviews.map text frame.size

class introspection
  > classInfo TARGET (c)
  > methods TARGET (m)
  > classMethods TARGET (M)
  > ivars TARGET (i)
  > protocols TARGET
  > UIApplication
  > UITableViewDelegate
EOF
  if $COLUMNS >= DEFAULT_ENV_COLUMNS
    first_page_lines = help_pages.first.split(LF)
    max_width = first_page_lines.max_by {|x| x.length }.length
    result_lines = first_page_lines.map {|x| x.ljust(max_width + 2) }
    for page in help_pages[1..-1]
      lines = page.split LF
      0.upto lines.count do |line_no|
        line = lines[line_no]
        result_lines[line_no].concat line if line
      end
    end
    puts result_lines.join(LF)
  else
    puts help_pages.join(LF)
  end
end

def resolve_server_url
  console_server_address = ARGV.size>0 ? ARGV.first : 'localhost'
  console_server_port = open("#{DIR}/../libcat/Console/manager/ConsoleManager.m").read.lines.select { |line| line =~ /#define CONSOLE_SERVER_PORT/ }.first.split(SPACE).last.to_i # 8080
  server_url = (console_server_address.include? COLON) ? "http://#{console_server_address}" : "http://#{console_server_address}:#{console_server_port}"
end

SERVER_URL = resolve_server_url
CONSOLE_SERVER_URL = "#{SERVER_URL}/console"

class Console
  def comment_out line
    line.gsub(/#(.*)$/, '')
  end
  def input_commands lines
    lines.split(LF).each do |line| 
      text = comment_out(line)
      input comment_out(line) if text.strip.size > 0
    end
  end
  def input text
    display_info "#{@shell.options[:prompt]}#{text}"
    @proc_block.call @shell.options, text
  end
  def command_arg_from_input text
    text_stripped = text.strip
    idx = text_stripped.index SPACE 
    if idx
      command = text_stripped[0..idx-1]
      arg = text_stripped[idx+1..-1]
    else
      command = text_stripped
      arg = nil
    end
    resolve_command(command, arg)
  end
  def resolve_command command_str, arg
    aliases = {
    'l' => 'ls',
    't' => 'touch',
    'e' => 'events',
    'er' => 'events record',
    'ep' => 'events play',
    'ee' => 'events replay',
    'ex' => 'events cut',
    'ec' => 'events clear',
    'es' => 'events save',
    'el' => 'events load',
	'm' => 'methods',
	'M' => 'classMethods',
	'p' => 'properties',
    'b' => 'back',
    'f' => 'flick',
    'c' => 'classInfo',
    'i' => 'ivars',
    '$' => 'new_objects',
    }
    full_command = aliases[command_str]
    if full_command
      if full_command.include? SPACE
        command, action = full_command.split SPACE
        [command, [action,arg].join(SPACE)]
      else
        [full_command, arg]
      end
    else
      [command_str, arg]
    end
  end
  def console_request command, arg
    if arg
      query = "arg=#{arg}"
      req_path = "#{CONSOLE_SERVER_URL}/#{command}?#{query}"
    else
      req_path = "#{CONSOLE_SERVER_URL}/#{command}"
    end
    begin
      response = Net::HTTP.get_response(URI.parse(URI.escape(req_path)))
      response.body
    rescue URI::InvalidURIError
    end
  end

  def load_events_base64 arg
    filename = arg['load '.size..-1].to_s.split(SPACE).last
    if nil != filename
      data = open("#{EVENTS_PATH}/#{filename}").read rescue nil
      data
    else
      nil
    end
  end

  def save_events_base64 arg, data
    filename = arg['save '.size..-1].to_s.split(SPACE).last
    if nil != filename
      open("#{EVENTS_PATH}/#{filename}",'w') { |f| f.write data }
      "saved #{filename}"
    else
      "events save NAME"
    end
  end

  def initialize
    @shell = Shell.new :prompt => PROMPT, :print => true
    @proc_block = proc do |env, text|
      case text
      when ''
      else
        command, arg = command_arg_from_input text
        case command
        when 'events'
          case arg
          when /^load/
            arg = "load#{load_events_base64(arg)}"
          when /^replay/
            arg = "replay#{load_events_base64(arg)}"
          end
        end
        response_body = console_request command, arg
        case command
        when 'h','help'
           print_help
	    when 'about'
           puts ABOUT
        when 'open'
           `open #{SERVER_URL}`
        when 'sleep'
          sleep arg.to_f
        when 'events'
          case arg
          when /^save/
            puts save_events_base64(arg, response_body)
          else
            display_info response_body if env[:print]
          end
        when 'completion'
          display_info response_body if env[:print]
        else
          display_info response_body if response_body.size>0 and env[:print]
          update_prompt
        end
        response_body
      end
    end
    connect_to_server
  end

  def connect_to_server
    begin
      prompt = Timeout::timeout 1 do
        request_COLUMNS
        request_prompt
      end
      @shell.options[:prompt] = prompt
    rescue # Timeout::Error
      puts "Cannot connect to console server #{SERVER_URL}"
      puts "Please run TestApp"
      prompt = PROMPT
      exit
    end
  end

  def request_COLUMNS
    response_body = console_request 'COLUMNS', " = #{$COLUMNS}"
  end

  def request_prompt
    response_body = console_request 'prompt', nil
    "#{response_body}#{PROMPT}"
  end


  def update_prompt
    @shell.options[:prompt] = request_prompt
  end

  def command_help
    @proc_block.call(@shell.options, 'help')
  end

  def run 
    @shell.delegate &@proc_block
   command_help
    @shell.start
  end
end

def display_info data
  if defined? DISPLAY_INPUT_OUTPUT
    if DISPLAY_INPUT_OUTPUT
      puts data
    end
  else
    puts data
  end
  data
end

def assert_equal expected, got
  puts expected == got ?
    "passed: #{expected}" :
    "Assertion failed\nExpected: #{expected}\nGot: #{got}"
end

if __FILE__ == $0
  if ARGV.size > 0 and %w{-h --help}.include? ARGV.first
    puts <<EOF
console.rb [IP] [IP:PORT]
EOF
  else
    console = Console.new
    console.run
  end
end
