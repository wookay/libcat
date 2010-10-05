//
//  TestString.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSStringExt.h"
#import "UnitTest.h"

@interface TestString : NSObject 
@end


@implementation TestString

-(void) test_SWF {
	assert_equal(@"0xff", SWF(@"0x%x", 255));
}

-(void) test_string {
	assert_equal(@"cba", [@"abc" reverse]);
	assert_equal(@"bc", [@"abc" slice:1 :2]);
}

@end
