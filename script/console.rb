#! /opt/local/bin/ruby1.9
# encoding: utf-8
# console.rb
#                           wookay.noh at gmail.com

DIR = "#{File.dirname __FILE__}"
$LOAD_PATH.unshift DIR
require 'ui_shell'
require 'net/http'
require 'timeout'

SPACE = ' '
COLON = ':'

PROMPT = '> '

#== Shell ==
##open: open Safari to display target UI
###sleep N: sleep
#History: [ history ] [ clear ]
#Console: [ help (h) ] [ quit (q) ] [ about ]

HELP = <<EOF
ls                  : list current target object    help     : help (h)
  [ ls -r ]         : list recursive                quit     : quit (q)
cd TARGET           : change target object          about    : about libcat Console
  [ cd ]            : topViewController             clear    : clear the screen
  [ cd 0 ]          : at index as listed            history  : input commands history
  [ cd 1 0 ]        : at section and index          sleep N  : sleep N seconds
  [ cd -1 0 ]       : at index on toolbar
  [ cd . ]          : to self            
  [ cd .. ]         : to superview       
  [ cd Title ]      : labeled as Title   
  [ cd view ]       : to property        
  [ cd UIButton ]   : to class           
  [ cd 0x6067490 ]  : at memory address             events                   : list touch events (e)
properties TARGET   : list properties (p)             [ events record ]      : record on/off (er)
  [ text ]          : property getter                 [ events play ]        : play events (ep)
  [ text = hello ]  : property setter                 [ events cut N ]       : cut N events
pwd                 : view & controller hierarchy     [ events clear ]       : clear events
manipulate TARGET   : manipulate properties UI (m)    [ events replay NAME ] : replay events (ee)
open                : open Safari UI                  [ events save NAME ]   : save events
touch TARGET        : touch target object UI (t)      [ events load NAME ]   : load events
back                : popViewController UI (b)
rm TARGET           : removeFromSuperview UI        enum ENUMTYPE            : enum type info
flash TARGET        : flash target object UI (f)      [ enum UITextAlignmentLeft ]
hit                 : hitTest UI on/off               [ enum UITextAlignment ]
EOF

CONSOLE_VERSION = 0.2
ABOUT = <<EOF
libcat Console #{CONSOLE_VERSION}
Copyright (c) 2010, 2011 WooKyoung Noh
EOF

EVENTS_PATH = "#{ENV['HOME']}/.console_events"
require 'fileutils'
FileUtils.mkdir_p EVENTS_PATH


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
    puts "#{@shell.options[:prompt]}#{text}"
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
    't' => 'touch',
    'e' => 'events',
    'er' => 'events record',
    'ep' => 'events play',
    'ee' => 'events replay',
	'm' => 'manipulate',
	'p' => 'properties',
    'b' => 'back',
    'f' => 'flash',
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
           puts HELP
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
            puts response_body if env[:print]
          end
        when 'completion'
          puts response_body if env[:print]
          response_body
        when 'cd', 'rm', 'back', 'touch', 'flash', 'hit'
          puts response_body if response_body.size>0 and env[:print]
          update_prompt
        else
          puts response_body if env[:print]
        end
      end
    end
    connect_to_server
  end

  def connect_to_server
    begin
      prompt = Timeout::timeout 1 do
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
