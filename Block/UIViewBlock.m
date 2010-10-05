//
//  UIViewBlock.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIViewBlock.h"

#define DEFAULT_DURATION 0.2

@implementation UIView (Block)

+(void) animate:(AnimationBlock)block {
	[self animateWithDuration:DEFAULT_DURATION
				   animations:^{
					   block(); 
				   }];
}

+(void) animate:(AnimationBlock)block afterDone:(AnimationBlock)doneBlock {
	[self animateWithDuration:DEFAULT_DURATION
				   animations:^{
					   block();
				   }
				   completion:^(BOOL finished) {
						if (finished) {
							doneBlock();
						}
				   }];
}

@end
