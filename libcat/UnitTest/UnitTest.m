//
//  UnitTest.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 05/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"
#import "NSStringExt.h"
#import "Inspect.h"
#import "Logger.h"
#import "objc/runtime.h"
#import "NSDateExt.h"
#import "NSArrayExt.h"
#import "NSObjectExt.h"


#define UNITTEST_TARGET_CLASS_FILTERING_SELECTOR @selector(hasPrefix:)



@implementation UnitTest

+(void) setup {
	UNITTESTMAN.test_started_at = [NSDate date];
	printf("Started\n");
}

+(void) report {
	UNITTESTMAN.elapsed = ABS([UNITTESTMAN.test_started_at timeIntervalSince1970]);
	printf("\nFinished in %.3g seconds.\n", UNITTESTMAN.elapsed);
	printf("\n%d tests, %d assertions, %d failures, %d errors\n", UNITTESTMAN.tests, UNITTESTMAN.assertions, UNITTESTMAN.failures, UNITTESTMAN.errors);
}

+(void) assert:(NSValue*)got equals:(NSValue*)expected message:(NSString*)message inFile:(NSString*)file atLine:(int)line {	
	UNITTESTMAN.assertions += 1;
	BOOL equals = false;
	if (nil == expected && nil == got) {
		equals = true;
	} else {		
		equals =[expected isEqual:got];
	}
	
	if (equals) {
		if (UNITTESTMAN.dot_if_passed) {
			printf(".");
		} else {
			print_log_info([file UTF8String], line, @"passed: %@", [got inspect]);			
		}
	} else {
		UNITTESTMAN.failures += 1;
		printf("\n");
		
		NSString* expected_message;
		if (nil == message) {
			expected_message = [expected inspect];
		} else {
			expected_message = message;
		}
		if ([expected isKindOfClass:[NSDate class]] && [got isKindOfClass:[NSDate class]]) {
			print_log_info([file UTF8String], line, @"Assertion failed\nExpected: %@\nGot: %@", [(NSDate*)expected gmtString], [(NSDate*)got gmtString]);
		} else {
			print_log_info([file UTF8String], line, @"Assertion failed\nExpected: %@\nGot: %@", expected_message, [got inspect]);
		}
	}	
}

+(void) assert:(NSValue*)got equals:(NSValue*)expected inFile:(NSString*)file atLine:(int)line {	
	return [self assert:got equals:expected message:nil inFile:file atLine:line];
}

+(id) target:(NSString*)targetClassString {
	Class* targetClass = (Class*)NSClassFromString(targetClassString);
	return [[[(id)targetClass alloc] init] autorelease];
}

+(void) run_all_tests {
	NSMutableArray* targetClasses = [NSMutableArray array];
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        Class *classes = malloc(sizeof(Class) * numClasses);
        (void) objc_getClassList (classes, numClasses);
        for (int idx = 0; idx < numClasses; idx++) {
			NSString* className = NSStringFromClass(classes[idx]);
			if (objc_msgSend(className, UNITTEST_TARGET_CLASS_FILTERING_SELECTOR, @"Test")) {
				[targetClasses addObject:className];
			}
        }
        free(classes);
    }
	for(NSString* targetClassString in targetClasses) {
		[[self target:targetClassString] run_tests];
	}
}

@end


@implementation NSObject (UnitTest)
-(void) run_test:(SEL)sel {
	UNITTESTMAN.tests += 1;
	NSString* format = SWF(@"%%%ds        - %%s\n", FILENAME_PADDING-2);
	if (UNITTESTMAN.dot_if_passed) {
	} else {
		NSString* methodStr = NSStringFromSelector(sel);
		printf ([format UTF8String], [SWF(@"%@", [self class]) UTF8String], [methodStr UTF8String]);				
	}
	[self performSelector:sel];
}

-(void) run_tests {
	NSArray* methods = [self methods];
	NSMutableArray* ary = [NSMutableArray array];
	for (NSString* methodStr in methods) {
		if ([methodStr isEqualToString:@"setup"]) {
			[self performSelector:NSSelectorFromString(methodStr)];
		} else if ([methodStr hasPrefix:@"test"]) {
			[ary addObject:methodStr];
		}
	}
	for (NSString* methodStr in ary) {
		[self run_test:NSSelectorFromString(methodStr)];
	}
}

@end



@implementation NSValue (UnitTest)
+ valueWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription {
	if (_C_PTR == *aTypeDescription && nil == *(id *)aValue) {
		return nil; // nil should stay nil, even if it's technically a (void *)
	}
	
	switch (*aTypeDescription) {			
		case _C_CHR: // BOOL, char
			return [NSNumber numberWithChar:*(char *)aValue];
		case _C_UCHR: return [NSNumber numberWithUnsignedChar:*(unsigned char *)aValue];
		case _C_SHT: return [NSNumber numberWithShort:*(short *)aValue];
		case _C_USHT: return [NSNumber numberWithUnsignedShort:*(unsigned short *)aValue];
		case _C_INT: return [NSNumber numberWithInt:*(int *)aValue];
		case _C_UINT: return [NSNumber numberWithUnsignedInt:*(unsigned *)aValue];
		case _C_LNG: return [NSNumber numberWithLong:*(long *)aValue];
		case _C_ULNG: return [NSNumber numberWithUnsignedLong:*(unsigned long *)aValue];
		case _C_LNG_LNG: return [NSNumber numberWithLongLong:*(long long *)aValue];
		case _C_ULNG_LNG: return [NSNumber numberWithUnsignedLongLong:*(unsigned long long *)aValue];
		case _C_FLT: return [NSNumber numberWithFloat:*(float *)aValue];
		case _C_DBL: return [NSNumber numberWithDouble:*(double *)aValue];
		case _C_ID: return *(id *)aValue;
		case _C_PTR: // pointer, no string stuff supported right now
		case _C_STRUCT_B: // struct, only simple ones containing only basic types right now
		case _C_ARY_B: // array, of whatever, just gets the address
			return [NSValue valueWithBytes:aValue objCType:aTypeDescription];
	}
	return [NSValue valueWithBytes:aValue objCType:aTypeDescription];	
}
@end





@implementation UnitTestManager
@synthesize dot_if_passed;
@synthesize test_started_at;
@synthesize elapsed;
@synthesize tests;
@synthesize assertions;
@synthesize failures;
@synthesize errors;

+ (UnitTestManager*) sharedManager {
	static UnitTestManager*	manager = nil;
	if (!manager) {
		manager = [UnitTestManager new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
		dot_if_passed = true;
		test_started_at = nil;
		elapsed = 0;
		tests = 0;
		assertions = 0;
		failures = 0;
		errors = 0;			
	}
	return self;
}

- (void)dealloc {
	[test_started_at release];
	[super dealloc];
}

@end

