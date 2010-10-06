//
//  UIAlertViewBlock.m
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIAlertViewBlock.h"
#import "NSStringExt.h"
#import "Logger.h"

@implementation UIAlertView (Block)

+(void) alert:(NSString*)message_ OK:(AlertBlock)block {
	[self alert:message_ OK:block pass:nil];
}

+(void) alert:(NSString*)message_ OK:(AlertBlock)block pass:(PassBlock)passBlock {
	if (nil == passBlock) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TEXT_ALERT
														message:message_
													   delegate:[ProcForAlertView procWithBlock:block]
											  cancelButtonTitle:nil
											  otherButtonTitles:TEXT_OK, nil];
		[alert show];
		[alert release];
	} else {
		int buttonIndex = passBlock();
		block(buttonIndex);
	}
}

+(void) alert:(NSString*)message_ Cancel_OK:(AlertBlock)block {
	[self alert:message_ Cancel_OK:block pass:nil];
}

+(void) alert:(NSString*)message_ Cancel_OK:(AlertBlock)block pass:(PassBlock)passBlock {
	if (nil == passBlock) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TEXT_ALERT
														message:message_
													   delegate:[ProcForAlertView procWithBlock:block]
											  cancelButtonTitle:TEXT_CANCEL
											  otherButtonTitles:TEXT_OK, nil];
		[alert show];
		[alert release];
	} else {
		int buttonIndex = passBlock();
		block(buttonIndex);
	}
}

@end




@implementation ProcForAlertView
@synthesize callBlock;

- (void)didPresentAlertView:(UIAlertView *)alertView {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	callBlock(buttonIndex);	
	[alertView.delegate release];
}

+(ProcForAlertView*) procWithBlock:(AlertBlock)block {
	ProcForAlertView* proc = [[ProcForAlertView alloc] init];
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

- (void)dealloc {
	if (nil != callBlock) {
		Block_release(callBlock);
	}
    [super dealloc];
}

@end