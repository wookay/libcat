//
//  UIButtonBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIButtonBlock.h"
#import "Logger.h"


@implementation UIButton (Block)

-(void) addBlock:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents {
	[self addTarget:[ProcForButton procWithBlock:block] action:@selector(call:) forControlEvents:controlEvents];
}

-(void) removeBlockForControlEvents:(UIControlEvents)controlEvents {
	for (id target in [self allTargets]) {
		if ([target isKindOfClass:[ProcForButton class]]) {
			NSArray* actions = [self actionsForTarget:target forControlEvent:controlEvents];
			for (NSString* strAction in actions) {
				[self removeTarget:target action:NSSelectorFromString(strAction) forControlEvents:controlEvents];
				[target release];
			}
		}
	}
}

@end




@implementation ProcForButton
@synthesize callBlock;

-(void) call:(id)sender {
	callBlock(sender);
}

+(ProcForButton*) procWithBlock:(ButtonBlock)block {
	ProcForButton* proc = [[ProcForButton alloc] init];
	proc.callBlock = Block_copy(block);
	return proc;
}

- (id) init {
	self = [super init];
	if (self) {
		self.callBlock = nil;
	}
	return self;
}

-(void) dealloc {
	if (nil != callBlock) {
		Block_release(callBlock);
	}
    [super dealloc];
}

@end