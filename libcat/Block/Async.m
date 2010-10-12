//
//  Async.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Async.h"

@implementation Async

+(void) perform:(AsyncBlock)block {
	AsyncBlock copiedBlock = Block_copy(block);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		copiedBlock();
	});	
}

+(void) perform:(AsyncBlock)block afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(perform:) withObject:Block_copy(block) afterDelay:delay];
}

+(void) perform:(AsyncBlock)block afterDone:(AsyncBlock)completeBlock {
	AsyncBlock copiedBlock = Block_copy(block);
	AsyncBlock copiedCompleteBlock = Block_copy(completeBlock);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		copiedBlock();
		[self performSelectorOnMainThread:@selector(taskComplete:) withObject:copiedCompleteBlock waitUntilDone:NO];
	});
}

+(void) taskComplete:(AsyncBlock)completeBlock {
	completeBlock();
}

@end
