//
//  TestAsync.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Async.h"
#import "UnitTest.h"
#import "Logger.h"

@interface TestAsync : NSObject
@end


@implementation TestAsync

-(void) test_async {
	[Async perform:^{ assert_true(true); } afterDone:^{ assert_true(true); }];
}

@end
