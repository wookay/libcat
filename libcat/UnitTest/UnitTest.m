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

#define UNITTEST_TARGET_CLASS_FILTERING_SELECTOR @selector(hasPrefix:)



@implementation UnitTest

+(void) run {
	[self setup];
	[self run_all_tests];
	[self report];
}

+(void) setup {
	UNITTESTMAN.test_started_at = [NSDate date];
	print_log_info(@"Started\n");
}

+(void) report {
	UNITTESTMAN.elapsed = ABS([UNITTESTMAN.test_started_at timeIntervalSinceNow]);
	print_log_info(@"\nFinished in %.3g seconds.\n", UNITTESTMAN.elapsed);
	print_log_info(@"\n%d tests, %d assertions, %d failures, %d errors\n", UNITTESTMAN.tests, UNITTESTMAN.assertions, UNITTESTMAN.failures, UNITTESTMAN.errors);
}

+(void) report_on_window {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	UILabel* label = [[UILabel alloc] initWithFrame:window.frame];
	label.text = SWF(@"%d tests, %d assertions, %d failures, %d errors\n", UNITTESTMAN.tests, UNITTESTMAN.assertions, UNITTESTMAN.failures, UNITTESTMAN.errors);
	label.textAlignment = UITextAlignmentCenter;
	label.adjustsFontSizeToFitWidth = true;
	if (UNITTESTMAN.failures > 0) {
		label.backgroundColor = [UIColor redColor];
	} else if (UNITTESTMAN.assertions > 0) {
		label.backgroundColor = [UIColor greenColor];
	}
	[window addSubview:label];
	[label release];
}

+(void) assert:(id)got equals:(id)expected message:(NSString*)message inFile:(NSString*)file atLine:(int)line {	
	UNITTESTMAN.assertions += 1;
	BOOL equals = false;
	if (nil == expected && nil == got) {
		equals = true;
	} else {
		equals = [expected isEqual:got];
	}
	
	if (equals) {
		if (UNITTESTMAN.dot_if_passed) {
			print_log_info(@".");
		} else {
			print_log_info(@"%@%d%@%@", file, line, @"passed: %@", [got inspect]);			
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
			print_log_info(@"%@ #%03d\nAssertion failed\nExpected: %@\nGot: %@\n", file, line, [(NSDate*)expected gmtString], [(NSDate*)got gmtString]);
		} else {
			print_log_info(@"%@ #%03d\nAssertion failed\nExpected: %@\nGot: %@\n", file, line, expected_message, [got inspect]);
		}
	}	
}

+(void) assert:(NSValue*)got equals:(NSValue*)expected inFile:(NSString*)file atLine:(int)line {	
	return [self assert:got equals:expected message:nil inFile:file atLine:line];
}

+(void) assertBlock:(AssertBlock)block raise:(NSString*)exceptionName inFile:(NSString*)file atLine:(int)line {
	@try {
		block();
	} @catch (NSException* exception) {
		[self assert:(NSValue*)exception.name equals:(NSValue*)exceptionName message:nil inFile:file atLine:line];
	}
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
		print_log_info(format, [SWF(@"%@", [self class]) UTF8String], [methodStr UTF8String]);				
	}
	[self performSelector:sel];
}

-(void) run_tests {
	NSArray* methods = [self methodNames];
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

