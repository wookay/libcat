//
//  TestObject.m
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UnitTest.h"

@interface AssignObject : NSNumber
@end

@interface RetainObject : NSArray
@end

@interface CopyObject : NSData
@end

@interface TestObject : NSObject
@property (nonatomic, retain) RetainObject* retainObject;
@property (nonatomic, assign) AssignObject* assignObject;
@property (nonatomic, copy) CopyObject* copyObject;
@end

@implementation TestObject
@synthesize retainObject;
@synthesize assignObject;
@synthesize copyObject;

-(void) test_class {
	assert_nil(NSClassFromString(@"no class"));
	assert_not_nil(NSClassFromString(@"UIButton"));
}

@end
