//
//  UnitTest.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 05/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObjectExt.h"

#define __FILENAME__ (strrchr(__FILE__,'/')+1)

#define assert_equal(expected, got) \
 do { \
	__typeof__(expected) __expected = (expected); \
	__typeof__(got) __got = (got); \
	NSValue* expected_encoded = [NSObject objectWithValue:&__expected withObjCType: @encode(__typeof__(expected))]; \
	NSValue* got_encoded = [NSObject objectWithValue:&__got withObjCType: @encode(__typeof__(got))]; \
	[UnitTest assert:got_encoded equals:expected_encoded inFile:[NSString stringWithUTF8String:__FILENAME__] atLine:__LINE__]; \
} while(0)

#define assert_equal_message(expected, got, expected_message) \
do { \
	__typeof__(expected) __expected = (expected); \
	__typeof__(got) __got = (got); \
	NSValue* expected_encoded = [NSObject objectWithValue:&__expected withObjCType: @encode(__typeof__(expected))]; \
	NSValue* got_encoded = [NSObject objectWithValue:&__got withObjCType: @encode(__typeof__(got))]; \
	[UnitTest assert:got_encoded equals:expected_encoded message:expected_message inFile:[NSString stringWithUTF8String:__FILENAME__] atLine:__LINE__]; \
} while(0)

#define assert_true(expr) assert_equal_message(true, expr, @"true")
#define assert_false(expr) assert_equal_message(false, expr, @"false")
#define assert_nil(expr) assert_equal_message(true, nil == expr, @"nil")
#define assert_not_nil(expr) assert_equal_message(false, nil == expr, @"not nil")
#define assert_not_null(expr) assert_equal_message(false, NULL == expr, @"not NULL")
#define assert_not_equals(not_expected, got) assert_equal_message(false, not_expected == got, @"not equals")

typedef void (^AssertBlock)();
#define assert_raise(exceptionName, block) \
do { \
	[UnitTest assertBlock:block raise:exceptionName inFile:[NSString stringWithUTF8String:__FILENAME__] atLine:__LINE__]; \
} while(0)

@interface UnitTest : NSObject

+(void) run ;
+(void) setup ;
+(void) report ;
+(void) report_on_window ;
+(void) assert:(NSValue*)got equals:(NSValue*)expected inFile:(NSString*)file atLine:(int)line ;
+(void) assert:(NSValue*)got equals:(NSValue*)expected message:(NSString*)message inFile:(NSString*)file atLine:(int)line ;
+(void) assertBlock:(AssertBlock)block raise:(NSString*)exceptionName inFile:(NSString*)file atLine:(int)line ;
+(id) target:(NSString*)targetClassString ;
+(void) run_all_tests ;

@end


@interface NSObject (UnitTest)
-(void) run_test:(SEL)sel ;
-(void) run_tests ;
@end


#define UNITTESTMAN [UnitTestManager sharedManager]
@interface UnitTestManager : NSObject {
	BOOL dot_if_passed;
	NSDate* test_started_at;
	NSTimeInterval elapsed;
	int tests;
	int assertions;
	int failures;
	int errors;	
}
@property (nonatomic) BOOL dot_if_passed;
@property (nonatomic, retain) NSDate* test_started_at;
@property (nonatomic) NSTimeInterval elapsed;
@property (nonatomic) int tests;
@property (nonatomic) int assertions;
@property (nonatomic) int failures;
@property (nonatomic) int errors;

+ (UnitTestManager*) sharedManager ;
@end
