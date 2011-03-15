#! /opt/local/bin/ruby1.9
# encoding: utf-8

require '../../script/console'

#RUN_ALL = false
RUN_ALL = true

c = Console.new
c.input 'cd'
c.input_commands <<EOF if RUN_ALL
t 0
sleep 0.5

cd UIButton
$1 = buttonWithType: 1
cd $1
frame = (100 100; 100 100)
setTitle:forState: hello 0
# addTarget:action:forControlEvents: $0 &0 UIControlEventTouchUpInside
cd
cd view
addSubview: $1
t 0

sleep 0.5
b
EOF
