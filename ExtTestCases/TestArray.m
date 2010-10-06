//
//  TestArray.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSArrayExt.h"
#import "UnitTest.h"
#import "Logger.h"
#import "NSStringExt.h"


@interface TestArray : NSObject
@end


@implementation TestArray

-(void) test_array {
	NSArray* ary = _w(@"1 2 3");
	
	assert_equal(@"1", [ary objectAtFirst]);
	assert_equal(@"2", [ary objectAtSecond]);
	assert_equal(@"3", [ary objectAtLast]);

	assert_equal(_w(@"1 2 3"), [_w(@"2 1 3") sort]);
}

-(void) test_pair {
	assert_equal(_w(@"a b"), PAIR(@"a", @"b"));
}

-(void) test_trio {
	assert_equal(_w(@"a b c"), TRIO(@"a", @"b", @"c"));
}

-(void) test_transpose {
	NSArray* expected = _array2(_w(@"1 3 5"), _w(@"2 4 6"));
	assert_equal(expected, [_array3(_w(@"1 2"), _w(@"3 4"), _w(@"5 6")) transpose]);
	
	expected = _array3(_w(@"1 2"), _w(@"3 4"), _w(@"5 6"));
	assert_equal(expected, [[_array3(_w(@"1 2"), _w(@"3 4"), _w(@"5 6")) transpose] transpose]);
	
	assert_equal(_array0(), [_array0() transpose]);
}

@end
