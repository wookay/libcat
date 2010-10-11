#! /opt/local/bin/ruby1.9



LOGGER_SERVER_ADDRESS = 'localhost'








require 'rubygems'
require 'eventmachine' #sudo gem1.9 install eventmachine

DIR = "#{File.dirname __FILE__}"

SPACE = ' '
class LoggerClient < EM::Protocols::LineAndTextProtocol 
  def receive_data(data)
    puts data
  end
end 

LOGGER_SERVER_PORT = open("#{DIR}/../manager/ConsoleManager.m").read.lines.select { |line| line =~ /#define LOGGER_SERVER_PORT/ }.first.split(SPACE).last.to_i # 8081

puts "Log Watcher : feed log_info messages. try to connect #{LOGGER_SERVER_ADDRESS}:#{LOGGER_SERVER_PORT}  (Quit : ^C)"
EventMachine::run do
  EventMachine::connect LOGGER_SERVER_ADDRESS, LOGGER_SERVER_PORT, LoggerClient
end
