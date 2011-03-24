//
//  TestBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"
#import "NSArrayBlock.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Logger.h"

@interface TestBlock : NSObject
@end

@implementation TestBlock

-(void) test_lambda {
	id lambda = ^(id obj) {
		assert_equal(@"a", obj);
	};
	[_w(@"a") each:lambda];
	
	assert_true([lambda isKindOfClass:[NSObject class]]);
}

@end