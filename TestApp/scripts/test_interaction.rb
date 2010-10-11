#! /opt/local/bin/ruby1.9
# encoding: utf-8

require '../../libcat/Console/script/console'

#RUN_ALL = false
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
contentView.backgroundColor = yellow
sleep 0.5
t .
sleep 0.5
b
sleep 0.5
cd 테스트
contentView.backgroundColor = clear
cd
EOF

c.input_commands <<EOF if RUN_ALL
cd 테스트
text = 브왁
t .
sleep 0.5
view.backgroundColor = red
new UIButton
cd $0
buttonWithType: 1
cd $0
frame = (100 100; 150 50)
setTitle:forState: 브왁ㅋㅋㅋㅋㅋㅋ 0
cd
cd view
addSubview: $0
sleep 1
cd
ls
t 0
b
sleep 0.5
cd
cd 브왁
text = 테스트
EOF
