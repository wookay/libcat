# encoding: utf-8
# shell.rb
#                           wookay.noh at gmail.com

require 'readline'
require 'rubygems'
require 'irb/completion'
require 'pp'
require 'fileutils'

include Readline

COLSOLE_PATH = "#{ENV['HOME']}/.console/"
HISTORY_PATH = "#{COLSOLE_PATH}history"
FileUtils.mkdir_p COLSOLE_PATH
LF = "\n"

COMMANDS = %w{open help quit about clear history sleep} + %w{back cd commands echo enum events flash hit log ls manipulate new_objects openURL prompt properties pwd rm touch COLUMNS show_console hide_console fill_rect add_ui}

def force_encoding_utf8 str
  if str.respond_to? :force_encoding
    str.force_encoding("UTF-8")
  else
    str
  end
end

class Shell
  attr_accessor :options
  def initialize options
    begin
      @HISTORY = open(HISTORY_PATH).read.lines.to_a
    rescue
      @HISTORY = []
    end
    @history_file = open(HISTORY_PATH,'a')
    @options = options
    @HISTORY.each do |action|
      HISTORY.push action
    end
    Readline.completion_proc = proc do |input|
      self.completion_list.sort.uniq.select do |history| 
          history.size != input.size and force_encoding_utf8(history).index(input) == 0
      end.map do |history|
        history.strip
      end
    end
  end
  def completion_list
    methods = @delegate.call({}, 'completion')
    (methods or '').split(LF).map {|x| x.strip } + COMMANDS + @HISTORY
  end
  def delegate &block
    @delegate = block
  end
  def history_push input
    if input.strip.size > 0
      if not @HISTORY.last == input
        HISTORY.push input
        @HISTORY.push input
        @history_file.write "#{input}\n"
      end
    end
  end
  def start
    at_exit do
      puts "exit"
    end
    while input = readline(@options[:prompt], true)
      case input.strip
      when 'clear'
        puts "\e[H\e[2J"
      when /^history/
        if input.include? ' clear'
          @HISTORY = []
          @history_file.close
          open(HISTORY_PATH,'w') do |f|
            f.write("")
          end
          @history_file = open(HISTORY_PATH,'a')
        else
          idx = @HISTORY.size
          ary = @HISTORY.map do |obj|
            s = "%3d  %s" % [idx, obj]
            idx -= 1
            s
          end
          puts ary
        end
      when /^\!/
        n = input.gsub(/^\!/,'').strip.to_i
        input = @HISTORY[-n].strip
        puts input
        history_push input
        @delegate.call @options.merge(:print=>true), input
      when 'q', 'quit'
        break
      else
        history_push input
        @delegate.call @options.merge(:print=>true), input
      end
    end
  end
end
