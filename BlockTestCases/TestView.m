//
//  TestView.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIViewBlock.h"
#import "UIButtonBlock.h"
#import "UnitTest.h"
#import "Logger.h"
#import "NSNumberBlock.h"
#import "NSNumberExt.h"

@interface TestView : NSObject 
@end


@implementation TestView

-(void) test_animation {
	[FIXNUM(2) times:^{
		[UIView animate:^{
					[UIApplication sharedApplication].keyWindow.alpha = 0.98;
					assert_not_nil([UIApplication sharedApplication].keyWindow);
		}];
	}];
	 
	[UIView animate:^{
				[UIApplication sharedApplication].keyWindow.alpha = 0.99;
				assert_not_nil([UIApplication sharedApplication].keyWindow);
			}
			afterDone:^{
				[UIApplication sharedApplication].keyWindow.alpha = 1;
				assert_not_nil([UIApplication sharedApplication].keyWindow);
			}];
}

-(void) test_button {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button addBlock:^(id sender) {
		assert_equal(button, sender);
	} forControlEvents:UIControlEventTouchUpInside];
	[button sendActionsForControlEvents:UIControlEventTouchUpInside];
	[button removeBlockForControlEvents:UIControlEventTouchUpInside];
}

@end
