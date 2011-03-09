#! /usr/bin/ruby

require 'rubygems'
require 'eventmachine' # sudo gem install eventmachine

DIR = "#{File.dirname __FILE__}"
SPACE = ' '
COLON = ':'

class LoggerClient < EM::Protocols::LineAndTextProtocol 
  def receive_data(data)
    puts data
  end
end 

def resolve_logger_server_address_port
  lines = open("#{DIR}/../libcat/Console/manager/ConsoleManager.m").read.lines
  console_server_port = lines.select { |line| line =~ /#define CONSOLE_SERVER_PORT/ }.first.split(SPACE).last.to_i # 8080
  logger_server_port_offset = lines.select { |line| line =~ /#define LOGGER_SERVER_PORT_OFFSET/ }.first.split(SPACE).last.to_i # 10
  port = console_server_port + logger_server_port_offset
  if ARGV.size > 0
    arg = ARGV.first 
    if arg.include? COLON
      logger_server_address , port_str = arg.split COLON
      port = port_str.to_i
    else
      logger_server_address = arg
    end
  else
    logger_server_address = 'localhost'
  end
  [logger_server_address, port]
end

LOGGER_SERVER_ADDRESS, LOGGER_SERVER_PORT = resolve_logger_server_address_port
puts "Log Watcher : feed log_info messages. waiting a connect #{LOGGER_SERVER_ADDRESS}:#{LOGGER_SERVER_PORT}  (Quit : ^C)"
EventMachine::run do
  EventMachine::connect LOGGER_SERVER_ADDRESS, LOGGER_SERVER_PORT, LoggerClient
end
