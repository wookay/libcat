//
//  TestNumber.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"
#import "NSNumberExt.h"
#import "NSStringExt.h"

@interface TestNumber : NSObject 
@end

@implementation TestNumber

typedef enum {
	kEnumTypeZero,
	kEnumTypeOne,
} kEnumType;

-(void) test_enum {
	assert_equal(@"1", SWF(@"%@", Enum(kEnumTypeOne)));
}

-(void) test_number {
	assert_equal(FIXNUM(2), [FIXNUM(1) next]);
	
	assert_equal(LONGNUM(4), [LONGNUM(3.14) ceiling]);
	assert_equal(LONGNUM(2), [LONGNUM(1.66) ceiling]);
	
	assert_equal(LONGNUM(3), [LONGNUM(3.14) round_up]);
	assert_equal(LONGNUM(2), [LONGNUM(1.66) round_up]);
	
	assert_equal(LONGNUM(3), [LONGNUM(3.14) floor_down]);
	assert_equal(LONGNUM(1), [LONGNUM(1.66) floor_down]);

	assert_equal(@"A", [FIXNUM(65) chr]);
	
	assert_false(is_odd(0));
	assert_true(is_odd(1));
	assert_false(is_odd(2));
	assert_true(is_odd(3));

}

@end
