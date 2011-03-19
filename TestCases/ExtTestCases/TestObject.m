//
//  TestObject.m
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"
#import "NSObjectExt.h"
#import "NSArrayExt.h"
#import "NSStringExt.h"
#import "Logger.h"
#import "objc/runtime.h"
#import "objc/message.h"


@interface TestObject : NSObject
@end
@implementation TestObject

-(void) test_raise {
	assert_raise(NSRangeException, ^{
		NSArray* ary = [NSArray array];
		[ary objectAtIndex:1];
	});
}

-(void) test_null {
	id obj = [NSNull null];
	assert_false(nil == obj);
}

-(void) test_superclass {
	assert_equal(_array3([NSMutableString class], [NSString class], [NSObject class]), [@"" superclasses]);
	assert_equal(_array1([NSObject class]), [NSString superclasses]);
	assert_equal(_array0(), [NSObject superclasses]);
}

-(void) test_class {
	assert_nil(NSClassFromString(@"no class"));
	assert_not_nil(NSClassFromString(@"NSString"));
}

@end




@interface SizeObject : NSObject {
	CGSize size;
}
@property (nonatomic) CGSize size;
@end
@implementation SizeObject
@synthesize size;
-(id) init {
	self = [super init];
	if (self) {
		self.size = CGSizeMake(1.5, 1.2);
	}
	return self;
}
@end

@interface TestProperty : NSObject
@end
@implementation TestProperty

-(void) test_encode {
	assert_equal("{CGSize=ff}", @encode(CGSize));
}

-(void) test_property {
	SizeObject* object = [[SizeObject alloc] init];
	assert_false([object propertyHasObjectType:@selector(size)]);
	[object release];
}

-(void) test_invocation {
	SizeObject* object = [[SizeObject alloc] init];
	unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([SizeObject class], &count);
	assert_equal(1, count);
	objc_property_t property = properties[0];
	const char* name = property_getName(property);
	NSString* propertyName = SWF(@"%s", name);
	assert_equal(@"size", propertyName);
	SEL sel = NSSelectorFromString(propertyName);	
	NSMethodSignature* sig = [object methodSignatureForSelector:sel];
	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
	[invocation setSelector:sel];
	[invocation setTarget:object];
	[invocation invoke];
	CGSize size;
	[invocation getReturnValue:&size];
	assert_equal(@"{1.5, 1.2}", NSStringFromCGSize(size));
	free(properties);
	[object release];
}

@end