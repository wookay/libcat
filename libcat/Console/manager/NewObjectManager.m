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
@synthesize neoObjects;
@synthesize neoOne;
@synthesize oldOne;

-(void) setNewObject:(id)obj forKey:(NSString*)key {
	if ([NEW_ONE_NAME isEqualToString:key]) {
		self.neoOne = obj;
	} else {
		[self.neoObjects setObject:obj forKey:key];
	}	
}

-(id) newObjectForKey:(NSString*)key {
	if ([NEW_ONE_NAME isEqualToString:key]) {
		return neoOne;
	} else {
		return [neoObjects objectForKey:key];
	}
}


-(void) updateNewOne:(id)obj {
	self.neoOne = obj;
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
		self.neoObjects = [NSMutableDictionary dictionary];
		self.neoOne = nil;
		self.oldOne = nil;
	}
	return self;
}

- (void)dealloc {
	[neoObjects release];
	neoOne = nil;
	oldOne = nil;
	[super dealloc];
}

@end
