//
//  TestDictionary.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDictionaryExt.h"
#import "UnitTest.h"
#import "NSStringExt.h"

@interface TestDictionary : NSObject 
@end


@implementation TestDictionary

-(void) test_dictionaryWithKeysAndObjects {
	NSDictionary* expected = [NSDictionary dictionaryWithObjectsAndKeys:
											@"object", @"key",
											nil];
	NSDictionary* got = [NSDictionary dictionaryWithKeysAndObjects:
											@"key", @"object",
											nil];
	assert_equal(expected, got);
}

-(void) test_HashSTAR {
	NSDictionary* expected = [NSDictionary dictionaryWithKeysAndObjects:
							  @"key", @"object",
							  nil];	
	assert_equal(expected, HashSTAR(_w(@"key object")));
}

@end
