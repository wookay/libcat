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

alpha = c.input 'view.alpha'
assert_equal 1, alpha.to_f

c.input 'view.alpha = 0.5'
alpha = c.input 'view.alpha'
assert_equal 0.5, alpha.to_f

c.input 'view.alpha = 1'

assert_equal 1, c.input('navigationController.viewControllers.count').to_i

c.input_commands <<EOF if RUN_ALL
ls
navigationController.viewControllers.count
EOF

c.input_commands <<EOF if RUN_ALL
t Scroll View	# touch
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
cd Scroll View
ls
contentView.backgroundColor = yellowColor
sleep 0.5
t .
sleep 0.5
b
sleep 0.5
cd Scroll View
contentView.backgroundColor = clearColor
cd
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
