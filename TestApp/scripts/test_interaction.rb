#! /opt/local/bin/ruby1.9
# encoding: utf-8

require '../../libcat/Console/script/console'

RUN_ALL = true

c = Console.new
c.input 'cd'
c.input_commands <<EOF if RUN_ALL
ls
navigationController.viewControllers.count
EOF

c.input_commands <<EOF if RUN_ALL
t 테스트		# touch
sleep 0.5
b				# back
sleep 0.5
t 1
sleep 0.5
b
sleep 0.5
EOF

c.input_commands <<EOF if RUN_ALL
t 1 0
t 1 # UIButton
t 올리기
t 2
t -1 0 # UIBarButtonItem
t -1 4 # UIBarButtonItem
sleep 0.5
b
sleep 0.5
EOF

c.input_commands <<EOF if RUN_ALL
cd 테스트
ls
sleep 0.5
t .
sleep 0.5
b
sleep 0.5
EOF
