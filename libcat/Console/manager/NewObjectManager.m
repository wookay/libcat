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
@synthesize oldOne;

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


-(void) updateNewOne:(id)obj {
	self.newOne = obj;
}

-(void) updateOldOne:(id)obj {
	self.oldOne = obj;
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
		self.oldOne = nil;
	}
	return self;
}

- (void)dealloc {
	[newObjects release];
	newOne = nil;
	oldOne = nil;
	[super dealloc];
}

@end
