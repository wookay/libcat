#! /opt/local/bin/ruby1.9
# encoding: utf-8
# console.rb
#                           wookay.noh at gmail.com



CONSOLE_SERVER_ADDRESS = ARGV.size>0 ? ARGV.first : 'localhost'



DIR = "#{File.dirname __FILE__}"
$LOAD_PATH.unshift DIR
require 'ui_shell'
require 'net/http'
require 'timeout'


SPACE = ' '
CONSOLE_SERVER_PORT = open("#{DIR}/../libcat/Console/manager/ConsoleManager.m").read.lines.select { |line| line =~ /#define CONSOLE_SERVER_PORT/ }.first.split(SPACE).last.to_i # 8080
SERVER_URL = "http://#{CONSOLE_SERVER_ADDRESS}:#{CONSOLE_SERVER_PORT}"
CONSOLE_SERVER_URL = "#{SERVER_URL}/console"
PROMPT = '> '


HELP = <<EOF
ls			: list current target object (ㄹ)
  [ ls -r ]		: list recursive
cd TARGET		: change target object (ㄷ)
  [ cd ]		: topViewController
  [ cd 0 ]		: at index as listed
  [ cd 1 0 ]		: at section and index
  [ cd -1 0 ]		: at index on toolbar
  [ cd . ]		: to self
  [ cd .. ]		: to superview
  [ cd Title ]		: labeled as Title
  [ cd view ] 		: to property
  [ cd UIButton ]	: to class
  [ cd 0x6067490 ]	: at memory address

touch TARGET   		: touch target object (t, ㅌ)
flash TARGET		: flash target object (f)
back    		: popViewControllerAnimated: false (b, ㅂ)
rm N			: removeFromSuperview
pwd 			: superviews

hitTest			: hitTest on/off (h)
events			: events (e)
  record		: record events on/off
  play 1 2 		: play events
  cut 2			: cut events
  clear			: clear events
  replay NAME	: replay events
  save NAME		: save events
  load NAME		: load events

property		: property getter (text, frame ...)
property = value	: property settter
$			: display new objects
  [ $1 = property ]     : set new object

open			: open Safari to display target UI
sleep N			: sleep
clear			: clear history
about			: about
quit			: quit (q)
EOF

# watch TARGET		: watch target object (w)

CONSOLE_VERSION = 0.1
ABOUT = <<EOF
libcat Console #{CONSOLE_VERSION} by wookay
EOF

EVENTS_PATH = "#{ENV['HOME']}/.console_events"
require 'fileutils'
FileUtils.mkdir_p EVENTS_PATH

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
    [resolve_command(command), arg]
  end
  def resolve_command command_str
    aliases = {
    't' => 'touch',
    'h' => 'hitTest',
    'e' => 'events',
    'ㅌ' => 'touch',
    'b' => 'back',
    'f' => 'flash',
    'ㅂ' => 'back',
    'ㄷ' => 'cd',
    'ㄹ' => 'ls',
    '$' => 'new_objects',
    'w' => 'watch',
    }
    aliases[command_str] or command_str 
  end
  def console_request command, arg
    if arg
      query = "arg=#{arg}"
      req_path = "#{CONSOLE_SERVER_URL}/#{command}?#{query}"
    else
      req_path = "#{CONSOLE_SERVER_URL}/#{command}"
    end
    Net::HTTP.get_response(URI.parse(URI.escape(req_path)))
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
        response = console_request command, arg
        case command
        when 'help'
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
            puts save_events_base64(arg, response.body)
          else
            puts response.body if env[:print]
          end
        when 'completion'
          puts response.body if env[:print]
          response.body
        when 'cd', 'rm', 'back', 'touch', 'flash', 'watch', 'hitTest'
          puts response.body if response.body.size>0 and env[:print]
          update_prompt
        else
          puts response.body if env[:print]
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
    rescue Timeout::Error
      puts "Cannot connect to console server #{CONSOLE_SERVER_ADDRESS}:#{CONSOLE_SERVER_PORT}"
      puts "Please run TestApp"
      prompt = PROMPT
      exit
    end
  end

  def request_prompt
    response = console_request 'prompt', nil
    "#{response.body}#{PROMPT}"
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
  console = Console.new
  console.run
end
