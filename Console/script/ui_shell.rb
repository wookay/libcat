# shell.rb
#                           wookay.noh at gmail.com

require 'readline'
require 'rubygems'
require 'irb/completion'
#require 'map_by_method' # gem install map_by_method
#require 'what_methods'  # gem install what_methods
require 'pp'
include Readline

HISTORY_PATH = '.console_history'
LF = "\n"

COMMANDS = %w{help open history clear quit}

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
      self.completion_list.sort.uniq.select { |history| history.match /^#{input}/ }
    end
  end
  def completion_list
    methods = @delegate.call({}, 'methods')
    methods.split(LF).map {|x| x.gsub(',','').gsub('"','').strip }.reject{|x|x=~/^\(/ or x==/\)$/} +
	 	COMMANDS +
		@HISTORY#.reject{|x|x.empty?}
  end
  def delegate &block
    @delegate = block
  end
  def history_push input
    HISTORY.push input
    @HISTORY.push input
    @history_file.write "#{input}\n"
  end
  def start
    at_exit do
      puts "exit"
    end
    while input = readline(@options[:prompt], true)
      case input.strip
      when 'clear'
        @HISTORY = []
        @history_file.close
        open(HISTORY_PATH,'w') do |f|
          f.write("")
        end
        @history_file = open(HISTORY_PATH,'a')
      when 'history'
        idx = @HISTORY.size
        ary = @HISTORY.map do |obj|
          s = "%3d  %s" % [idx, obj]
          idx -= 1
          s
        end
        puts ary
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
