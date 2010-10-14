//
//  UIViewBlock.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIViewBlock.h"
#import "Async.h"
#import "NSArrayExt.h"

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

-(void) traverseSubviews:(TraverseBlock)block {
	[self traverseSubviews:block reverse:false];
}

-(void) traverseSubviews:(TraverseBlock)block reverse:(BOOL)reverse {
	[self traverseSubviews:block depth:0 reverse:reverse];
}

-(void) traverseSubviews:(TraverseBlock)block depth:(int)depth reverse:(BOOL)reverse {
	block(depth, self);
	for (UIView* subview in (reverse ? [[self subviews] reverse] : [self subviews])) {
		[subview traverseSubviews:block depth:depth+1 reverse:reverse];
	}
}

@end