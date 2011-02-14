//
//  TestButton.m
//  TestApp
//
//  Created by wookyoung noh on 12/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Logger.h"
#import "UnitTest.h"
#import "UIButtonBlock.h"

@interface TestButton : NSObject {
	int outside_cnt;
}
@end


@implementation TestButton

-(void) setup {
	outside_cnt = 0;
}

-(IBAction) touchedOusideAction:(id)sender {
	outside_cnt += 1;
}

-(IBAction) touchedOusideSecond:(id)sender {
	outside_cnt += 1;
}

-(void) test_multi_action {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

	[button addBlock:^(id sender) {
		outside_cnt += 1;
	} forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(touchedOusideAction:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(touchedOusideSecond:) forControlEvents:UIControlEventTouchUpInside];
	[button sendActionsForControlEvents:UIControlEventTouchUpInside];	
	
	[button removeBlockForControlEvents:UIControlEventTouchUpInside];
	[button removeTarget:self action:@selector(touchedOusideAction:) forControlEvents:UIControlEventTouchUpInside];
	[button removeTarget:self action:@selector(touchedOusideSecond:) forControlEvents:UIControlEventTouchUpInside];
	
	assert_equal(3, outside_cnt);
}

-(void) test_button {
	__block int cnt = 0;
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button addBlock:^(id sender) {
		assert_equal(button, sender);
		cnt += 1;
	} forControlEvents:UIControlEventTouchUpInside];
	
	assert_equal(0, cnt);
	
	[button sendActionsForControlEvents:UIControlEventTouchUpInside];
	assert_equal(1, cnt);
	
	[button sendActionsForControlEvents:UIControlEventTouchUpInside];
	assert_equal(2, cnt);
	
	[button removeBlockForControlEvents:UIControlEventTouchUpInside];
	[button sendActionsForControlEvents:UIControlEventTouchUpInside];
	
	assert_equal(2, cnt);
}

-(void) test_superclass {
	assert_equal(@"UIControl", NSStringFromClass([UIButton superclass]));
	assert_equal(@"UIView", NSStringFromClass([UIControl superclass]));
	assert_equal(@"UIResponder", NSStringFromClass([UIView superclass]));
	assert_equal(@"NSObject", NSStringFromClass([UIResponder superclass]));
}

@end