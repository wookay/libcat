#! /usr/bin/ruby
# encoding: utf-8

require '../../script/console'

#RUN_ALL = false
RUN_ALL = true
DISPLAY_INPUT_OUTPUT = false

c = Console.new
rootVC = c.input 'cd /'
IS_TABBARCONTROLLER = 'UITabBarController> ' == rootVC

c.input 'cd'
c.input_commands <<EOF if RUN_ALL
ls
navigationController.viewControllers.count
EOF

c.input_commands <<EOF if RUN_ALL
t Tests			# touch
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
t up
t 2
EOF

if IS_TABBARCONTROLLER
  c.input_commands <<EOF if RUN_ALL
t -1 0 # UIBarButtonItem
t -1 4 # UIBarButtonItem
sleep 0.5
EOF
end

c.input_commands <<EOF if RUN_ALL
b
sleep 0.5
EOF

c.input_commands <<EOF if RUN_ALL
cd Tests
ls
contentView.backgroundColor = yellow
sleep 0.5
t .
sleep 0.5
b
sleep 0.5
cd Tests
contentView.backgroundColor = clear
cd
EOF

c.input_commands <<EOF if RUN_ALL
cd Tests
text = 브왁
t .
view.backgroundColor = red
sleep 0.5
b
sleep 0.5
cd
cd 브왁
text = Tests
EOF


if IS_TABBARCONTROLLER
  c.input_commands <<EOF if RUN_ALL
cd /
t 1		# selectedIndex = 1
sleep 0.5
cd /
t 0		# selectedIndex = 0
sleep 0.5
cd
EOF
end
