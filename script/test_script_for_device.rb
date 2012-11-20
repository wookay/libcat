#! /usr/bin/ruby
# test_script_for_device.rb
#                           wookay.noh at gmail.com

require './console'

c = Console.new '192.168.0.9'
c.input 'ls'
c.input 'view.backgroundColor = greenColor'

c.input_commands <<EOF
view.alpha
view.frame
# view.frame = {{100,100}, {50, 50}}
view.subviews
view.subviews.map frame text
EOF
