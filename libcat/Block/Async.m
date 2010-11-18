//
//  Async.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Async.h"
#import "NSTimerExt.h"
#import "NSArrayExt.h"

@implementation Async

+(void) perform:(AsyncBlock)block {
	AsyncBlock copiedBlock = Block_copy(block);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		copiedBlock();
	});	
}

+(void) perform:(AsyncBlock)block afterDone:(AsyncBlock)completeBlock {
	AsyncBlock copiedBlock = Block_copy(block);
	AsyncBlock copiedCompleteBlock = Block_copy(completeBlock);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		copiedBlock();
		[self performSelectorOnMainThread:@selector(__taskCompleted:) withObject:copiedCompleteBlock waitUntilDone:NO];
	});
}

+(void) __taskCompleted:(AsyncBlock)completeBlock {
	completeBlock();
}

+(void) __taskPerform:(NSTimer*)timer {
	NSArray* pair = [timer userInfo];
	[self perform:[pair objectAtFirst] afterDone:[pair objectAtSecond]];
}

+(void) afterDelay:(NSTimeInterval)delay perform:(AsyncBlock)block {
	[self performSelector:@selector(perform:) withObject:Block_copy(block) afterDelay:delay];
}

+(void) afterDelay:(NSTimeInterval)delay perform:(AsyncBlock)block afterDone:(AsyncBlock)completeBlock {
	[NSTimer afterDelay:delay target:self action:@selector(__taskPerform:) userInfo:_array2(Block_copy(block), Block_copy(completeBlock))];
}

@end

