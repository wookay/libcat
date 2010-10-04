//
//  TestString.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TestString.h"
#import "NSStringExt.h"
#import "UnitTest.h"

@implementation TestString

-(void) test_string {
	assert_equal(@"0xff", SWF(@"0x%x", 255));
}

@end
