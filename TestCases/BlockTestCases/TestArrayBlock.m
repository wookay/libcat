//
//  TestArrayBlock.m
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSNumberExt.h"
#import "NSNumberBlock.h"
#import "NSStringExt.h"
#import "NSArrayBlock.h"
#import "UnitTest.h"
#import "NSMutableArrayExt.h"

@interface TestArrayBlock : NSObject 
@end


@implementation TestArrayBlock

-(void) test_array_block {
	assert_equal(_w(@"A B C"), [_w(@"a b c") map:^id(id obj) {
		return [obj uppercaseString];
	}]);
	assert_equal(_w(@"b"), [_w(@"a b c") select:^BOOL(id obj) {
		return [@"b" isEqualToString:obj];
	}]);	
	assert_equal(_w(@"a c"), [_w(@"a b c") reject:^BOOL(id obj) {
		return [@"b" isEqualToString:obj];
	}]);
	
	assert_equal(8, FIXNUM(8));
	assert_equal(8, [_w(@"1 2 3") reduce:FIXNUM(2) :^id(id result, id item) {
		return FIXNUM([result intValue] + [item intValue]);
	}]);
	assert_equal(_w(@"1 2 3"), [_w(@"1 2 3") reduce:[NSMutableArray array] :^id(id result, id item) {
		return [result push:item];
	}]);	
	
	assert_equal(_w(@"3 2 1"), [_w(@"1 3 2") sort:^NSComparisonResult(id uno, id dos) {
		return [dos compare:uno];
	}]);
}

@end
