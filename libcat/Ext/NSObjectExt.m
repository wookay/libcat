//
//  NSObjectExt.m
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSObjectExt.h"
#import "objc/runtime.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Logger.h"

@implementation NSObject (Ext)

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti {
	[self performSelector:selector withObject:nil afterDelay:ti];
}

-(BOOL) isNull {
	return [self isKindOfClass:[NSNull class]];
}

-(BOOL) isNotNull {
	return ! [self isKindOfClass:[NSNull class]];
}

-(NSArray*) methods {
	Class targetClass = [self class];
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int methodCount;
	Method *methods = class_copyMethodList((Class)targetClass, &methodCount);
	for (size_t idx = 0; idx < methodCount; ++idx) {
		Method method = methods[idx];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		[ary addObject:selectorName];
	}
	return [ary sort];
}

-(NSArray*) class_methods {
	Class targetClass = [self class]->isa;
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int methodCount;
	Method *methods = class_copyMethodList((Class)targetClass, &methodCount);
	for (size_t idx = 0; idx < methodCount; ++idx) {
		Method method = methods[idx];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		[ary addObject:selectorName];
	}
	return [ary sort];
}

-(NSString*) downcasedClassName {
	return [SWF(@"%@", [self class]) lowercaseString];
}

@end