//
//  TestString.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSStringExt.h"
#import "UnitTest.h"
#import "Logger.h"
#import "GeometryExt.h"

@interface TestString : NSObject 
@end


@implementation TestString

-(void) test_pointer {
	NSString* p = SWF(@"%p", self);
	size_t address = [p to_size_t];
	id obj = (id)address;
	assert_equal(self, obj);
}

-(void) test_isNumber {
	assert_true([@"0" isNumber]);
	assert_true([@" 0" isNumber]);
	assert_true([@"-1" isNumber]);
	assert_false([@"a" isNumber]);
	assert_false([@"1 2" isNumber]);
	assert_true([@"3.14" isNumber]);
	assert_true([@"1 2" isNumberWithSpace]);
}

-(void) test_isAlphabet {
	assert_true([@"hello" isAlphabet]);
	assert_false([@"hello world" isAlphabet]);
	assert_false([@"a1" isAlphabet]);
	assert_false([@"1" isAlphabet]);
}

-(void) test_SWF {
	assert_equal(@"0xff", SWF(@"0x%x", 255));
}

-(void) test_w {
	NSArray* expected = [@"a b" componentsSeparatedByString:SPACE];
	assert_equal(expected, _w(@"a b"));
}

-(void) test_string {
	assert_equal(@"cba", [@"abc" reverse]);
	assert_equal(@"bc", [@"abc" slice:1 :2]);
	assert_equal(@"abcd", [@"abcff" gsub:@"ff" to:@"d"]);
	assert_true([@"abcff" hasText:@"ff"]);

}

-(void) test_CGRectForString {
	assert_equal(CGRectMake(11,12,21,22), CGRectFromString(@"{{11, 12}, {21, 22}}"));
	assert_equal(CGRectZero, CGRectFromString(@"(11 12; 21 22)"));
	assert_equal(CGRectMake(11,12,21,22), CGRectForString(@"(11 12; 21 22)"));
}

@end