//
//  TestView.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIViewBlock.h"
#import "UIButtonBlock.h"
#import "UIAlertViewBlock.h"
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
	 
	__block int cnt = 0;
	[UIView animate:^{
				[UIApplication sharedApplication].keyWindow.alpha = 0.99;
				assert_not_nil([UIApplication sharedApplication].keyWindow);
				cnt += 1;
			}
			afterDone:^{
				[UIApplication sharedApplication].keyWindow.alpha = 1;
				assert_not_nil([UIApplication sharedApplication].keyWindow);
				cnt += 1;
				assert_equal(2, cnt);
			}];
	assert_equal(1, cnt);
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

-(void) test_alert {
	[UIAlertView alert:@"alert ok"
					OK:^(int idx) {
						assert_equal(kAlertCancelOK_OK, idx);
					}
				  pass:^int {
					  return kAlertCancelOK_OK;
				  }];
	
	[UIAlertView alert:@"alert cancel ok"
			 Cancel_OK:^(int idx) {
						assert_equal(kAlertCancelOK_OK, idx);
				}
				  pass:^int {
						return kAlertCancelOK_OK;
				}];

}

@end