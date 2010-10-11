//
//  TestObject.m
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"

@interface TestObject : NSObject
@end

@implementation TestObject

-(void) test_class {
	assert_nil(NSClassFromString(@"no class"));
	assert_not_nil(NSClassFromString(@"UIButton"));
}

@end
