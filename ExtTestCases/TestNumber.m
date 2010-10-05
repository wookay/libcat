//
//  TestNumber.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"
#import "NSNumberExt.h"

@interface TestNumber : NSObject 
@end

@implementation TestNumber

-(void) test_number {
	assert_equal(LONGNUM(4), [LONGNUM(3.14) ceiling]);
	assert_equal(LONGNUM(2), [LONGNUM(1.66) ceiling]);
	
	assert_equal(LONGNUM(3), [LONGNUM(3.14) round_up]);
	assert_equal(LONGNUM(2), [LONGNUM(1.66) round_up]);
	
	assert_equal(LONGNUM(3), [LONGNUM(3.14) floor_down]);
	assert_equal(LONGNUM(1), [LONGNUM(1.66) floor_down]);

	assert_equal(@"A", [FIXNUM(65) chr]);
}

@end
