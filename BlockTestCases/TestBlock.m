//
//  TestBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TestBlock.h"
#import "UnitTest.h"
#import "NSArrayBlock.h"
#import "NSDictionaryBlock.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "NSDictionaryExt.h"
#import "UIButtonBlock.h"
#import "Logger.h"
#import "NSNumberExt.h"
#import "NSNumberBlock.h"

@implementation TestBlock

-(void) test_number {
	[FIXNUM(5) times:^(int idx) {
		assert_true(idx < 5);
	}];
}

-(void) test_block {
	id lambda;
	lambda = ^ {
		assert_equal(@"a", @"a");
	};
	[_array1(@"a") each:lambda];
	
	lambda = ^(id obj) {
		assert_equal(@"a", obj);
	};
	[_array1(@"a") each:lambda];
	
	assert_true([lambda isKindOfClass:[NSObject class]]);
}

-(void) test_button {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button addBlock:^(id sender) {
		assert_equal(button, sender);
	} forControlEvents:UIControlEventTouchUpInside];
	[button sendActionsForControlEvents:UIControlEventTouchUpInside];
	[button removeBlockForControlEvents:UIControlEventTouchUpInside];
}

-(void) test_dictionary {
	assert_equal(_hash2(@"a", @"b", @"c", @"d"), HashSTAR(_w(@"a b c d")));

	assert_equal(_w(@"ab cd"), [HashSTAR(_w(@"a b c d")) map:^id(id k, id v) {
		return [_array2(k,v) join];
	}]);	
}

-(void) test_array {
	assert_equal(_w(@"A B C"), [_w(@"a b c") map:^id(id obj) {
		return [obj uppercaseString];
	}]);
	assert_equal(_w(@"b"), [_w(@"a b c") select:^BOOL(id obj) {
		return [@"b" isEqualToString:obj];
	}]);	
	assert_equal(_w(@"a c"), [_w(@"a b c") reject:^BOOL(id obj) {
		return [@"b" isEqualToString:obj];
	}]);		
}

@end
