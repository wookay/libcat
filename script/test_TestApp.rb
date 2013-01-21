#! /usr/bin/ruby
# test_TestApp.rb
#                           wookay.noh at gmail.com

require './console'
require 'test/unit'

DISPLAY_INPUT_OUTPUT = false

class TestAppTest < Test::Unit::TestCase
  def setup
    @c = Console.new
  end
  def test_1
    assert_equal '"libcat"', @c.input('title')
    assert_equal '"Scroll View"', @c.input('0.text')
    assert_equal '"Tests"', @c.input('1 0.text')
    assert_equal '[0 0 0 0]', @c.input('view.backgroundColor')
  end
  def test_counter
    @c.input('t Counter')
    @c.input('sleep 0.5')
    assert_equal '"Counter"', @c.input('title')
    @c.input('t up')
    assert_equal '"1"', @c.input('0.text')
    @c.input('t up')
    assert_equal '"2"', @c.input('0.text')
    assert_equal '[0.50154 0.762959 0.918478 1]', @c.input('view.backgroundColor')
    @c.input('b')
  end
end
