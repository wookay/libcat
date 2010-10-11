//
//  NewObjectManager.m
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NewObjectManager.h"
#import "NSArrayExt.h"
#import "NSStringExt.h"
#import "ConsoleManager.h"

@implementation NewObjectManager
@synthesize newObjects;
@synthesize newOne;

-(void) setNewObject:(id)obj forKey:(NSString*)key {
	if ([NEW_ONE_NAME isEqualToString:key]) {
		self.newOne = obj;
	} else {
		[self.newObjects setObject:obj forKey:key];
	}	
}

-(id) newObjectForKey:(NSString*)key {
	if ([NEW_ONE_NAME isEqualToString:key]) {
		return newOne;
	} else {
		return [newObjects objectForKey:key];
	}
}

-(NSString*) makeNewOne:(NSString*)className {
	NSMutableArray* ary = [NSMutableArray array];
	if (nil == className) {
		[ary addObject:SWF(@"NEW_OBJECTS: %@", self.newObjects)];
		[ary addObject:SWF(@"%@: %@", NEW_ONE_NAME, self.newOne)];
	} else {
		Class klass = NSClassFromString(className);
		if (nil == klass) {
			[ary addObject:NSLocalizedString(@"Not Found", nil)];
		} else {
			self.newOne = klass;
			[ary addObject:SWF(@"%@ = %@", NEW_ONE_NAME, klass)];
		}
	}
	return [ary join:LF];
}

-(void) updateNewOne:(id)obj {
	self.newOne = obj;
}

+ (NewObjectManager*) sharedManager {
	static NewObjectManager* manager = nil;
	if (!manager) {
		manager = [NewObjectManager new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
		self.newObjects = [NSMutableDictionary dictionary];
		self.newOne = nil;
	}
	return self;
}

- (void)dealloc {
	[newObjects release];
	newOne = nil;
	[super dealloc];
}

@end
