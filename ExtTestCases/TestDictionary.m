//
//  TestDictionary.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TestDictionary.h"
#import "NSDictionaryExt.h"
#import "UnitTest.h"

@implementation TestDictionary

-(void) test_dictionary {
	NSDictionary* expected = [NSDictionary dictionaryWithObjectsAndKeys:
											@"object", @"key",
											nil];
	NSDictionary* got = [NSDictionary dictionaryWithKeysAndObjects:
											@"key", @"object",
											nil];
	assert_equal(expected, got);
}

@end
