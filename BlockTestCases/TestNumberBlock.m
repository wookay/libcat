//
//  TestNumberBlock.m
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSNumberExt.h"
#import "NSNumberBlock.h"
#import "UnitTest.h"

@interface TestNumberBlock : NSObject
@end

@implementation TestNumberBlock

-(void) test_number_block {
	[FIXNUM(1) times:^(int idx) {
		assert_true(idx < 1);
	}];
	[FIXNUM(1) times:^ {
		assert_true(true);
	}];	
	[FIXNUM(2) upto:3 :^(int idx) {
		assert_true(idx <= 3);
	}];
	[FIXNUM(2) upto:3 :^ {
		assert_true(true);
	}];	
	[FIXNUM(3) downto:2 :^(int idx) {
		assert_true(idx <= 3);
	}];
	[FIXNUM(3) downto:2 :^ {
		assert_true(true);
	}];
	
	id lambda = ^ { };
	[FIXNUM(2) upto:3 :lambda];
}

@end
