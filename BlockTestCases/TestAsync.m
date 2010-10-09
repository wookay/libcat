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
	__block int cnt = 0;
	[Async perform:^{ 
		cnt += 1;
		assert_equal(1, cnt); 
	}];
//	assert_equal(0, cnt); 

	[Async perform:^{ 
			cnt += 1;
			assert_equal(2, cnt); 
		}
		whenCompleted:^{ 
			cnt += 1;
			assert_equal(3, cnt); 
		}];
	
//	assert_equal(1, cnt); 
}

@end
