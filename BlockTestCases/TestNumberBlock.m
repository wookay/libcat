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
	__block int cnt = 0;
	[FIXNUM(5) times:^(int idx) {
		cnt += 1;
	}];
	assert_equal(5, cnt);

	cnt = 0;
	[FIXNUM(5) times:^ {
		cnt += 1;
	}];	
	assert_equal(5, cnt);

	cnt = 0;
	[FIXNUM(2) upto:5 :^(int idx) {
		cnt += 1;
	}];
	assert_equal(4, cnt);
	
	cnt = 0;
	[FIXNUM(2) upto:5 :^ {
		cnt += 1;
	}];	
	assert_equal(4, cnt);

	cnt = 0;
	[FIXNUM(3) downto:1 :^(int idx) {
		cnt += 1;
	}];
	assert_equal(3, cnt);

	cnt = 0;
	[FIXNUM(3) downto:1 :^ {
		cnt += 1;
	}];
	assert_equal(3, cnt);
	
	id lambda = ^ { };
	[FIXNUM(2) upto:3 :lambda];
}

@end
