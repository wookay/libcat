#! /usr/bin/ruby
# console.rb
#                           wookay.noh at gmail.com



CONSOLE_SERVER_ADDRESS = 'localhost'




DIR = "#{File.dirname __FILE__}"
$LOAD_PATH.unshift DIR
require 'ui_shell'
require 'net/http'
require 'timeout'


SPACE = ' '
CONSOLE_SERVER_PORT = open("#{DIR}/../manager/ConsoleManager.m").read.lines.select { |line| line =~ /#define CONSOLE_SERVER_PORT/ }.first.split(SPACE).last.to_i # 8080
SERVER_URL = "http://#{CONSOLE_SERVER_ADDRESS}:#{CONSOLE_SERVER_PORT}"
CONSOLE_SERVER_URL = "#{SERVER_URL}/console"
PROMPT = '> '

HELP = <<EOF
ls			: list current target object
cd			: change target object
  [ cd 0 ]		: to change target object at index as listed
  [ cd 0x6067490 ]	: to change target object at memory address
touch    		: didSelectRowAtIndexPath (t)
back    		: popViewControllerAnimated (b)
rm N			: remove from superview
property		: property getter (text, frame ...)
property = value	: property settter
open			: open safari to display target object view
about			: about
quit			: quit (q)
EOF

CONSOLE_VERSION = 0.1
ABOUT = <<EOF
libcat Console #{CONSOLE_VERSION} by wookay
EOF

class Console
  def command_arg_from_input text
    idx = text.index SPACE 
    if idx
      command = text[0..idx-1]
      arg = text[idx+1..-1]
    else
      command = text
      arg = nil
    end
    [command, arg]
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

  def initialize
  end

  def request_prompt
    response = console_request 'pwd', nil
    "#{response.body}#{PROMPT}"
  end


  def update_prompt
    @shell.options[:prompt] = request_prompt
  end

  def command_help
    @proc_block.call(@shell.options, 'help')
  end

  def run prompt
    @shell = Shell.new :prompt => prompt
    @proc_block = proc do |env, text|
      case text
      when ''
      else
        command, arg = command_arg_from_input text
        response = console_request command, arg
        case command
        when 'help'
           puts HELP
	    when 'about'
           puts ABOUT
        when 'open'
           `open #{SERVER_URL}`
        when 'touch', 't'
          if /^touch / =~ response.body
            update_prompt
          else
            puts response.body
          end
        when 'back', 'b'
          if /^back / =~ response.body
            update_prompt
          else
            puts response.body
          end
        when 'cd', 'rm'
          if /^cd / =~ response.body
            prompt = response.body['cd '.size..-1]
            @shell.options[:prompt] = "#{prompt}#{PROMPT}"
          else
            puts response.body
          end
        else
          puts response.body if env[:print]
          response.body
        end
      end
    end
    @shell.delegate &@proc_block

   command_help

    @shell.start
  end
end

if __FILE__ == $0
  console = Console.new
  begin
    prompt = Timeout::timeout 1 do
      console.request_prompt
    end
  rescue Timeout::Error
    puts "Cannot connect to console server #{CONSOLE_SERVER_ADDRESS}:#{CONSOLE_SERVER_PORT}"
	puts "Please run TestApp"
    prompt = PROMPT
	exit
  end
  console.run prompt
  
end
