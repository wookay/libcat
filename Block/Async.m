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
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		block();
	});	
}

+(void) perform:(AsyncBlock)block afterDone:(AsyncBlock)doneBlock {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		block();
		[self performSelectorOnMainThread:@selector(taskDone:) withObject:doneBlock waitUntilDone:NO];
	});
}

+(void) taskDone:(AsyncBlock)doneBlock {
	doneBlock();
}

@end
