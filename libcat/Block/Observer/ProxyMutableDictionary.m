//
//  ProxyMutableDictionary.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ProxyMutableDictionary.h"
#import "ObserverManager.h"
#import "Logger.h"
#import "NSDictionaryExt.h"
#import "NSNumberExt.h"

@implementation ProxyMutableDictionary
@synthesize proxyKeyPath;
@synthesize proxyDict;

- (id) init {
	self = [super init];
	if (self) {
		self.proxyKeyPath = nil;
		self.proxyDict = [NSMutableDictionary dictionary];
	}
	return self;
}

-(id) objectForKey:(id)aKey {
	return [proxyDict objectForKey:aKey];
}

-(void) setDictionary:(NSDictionary *)otherDictionary {
	[self removeAllObjects];
	[self addEntriesFromDictionary:otherDictionary];
}

-(void) addEntriesFromDictionary:(NSDictionary *)otherDictionary {
	for (id key in otherDictionary) {
		id obj = [otherDictionary objectForKey:key];
		[self setObject:obj forKey:key];
	}
}

-(void) removeAllObjects {
	[self removeObjectsForKeys:[proxyDict allKeys]];
}

-(void) removeObjectsForKeys:(NSArray*)keyArray {
	for (id key in keyArray) {
		[self removeObjectForKey:key];
	}
}

-(void) setObject:(id)anObject forKey:(id)aKey {
	BOOL hasKey = [proxyDict hasKey:aKey];
	id oldObj = [proxyDict objectForKey:aKey];
	[proxyDict setObject:anObject forKey:aKey];
	ObjectChangedBlock changedBlock = [OBSERVERMAN.observeBlock objectForKey:proxyKeyPath];
	if (nil != changedBlock) {
		if (hasKey) {
			if ([oldObj isEqual:anObject]) {
			} else {
                    changedBlock(proxyKeyPath, self, [NSDictionary dictionaryWithKeysAndObjects:
                                                      @"kind", Enum(NSKeyValueChangeReplacement),
                                                      nil]);
			}
		} else {
            changedBlock(proxyKeyPath, self, [NSDictionary dictionaryWithKeysAndObjects:
                                              @"kind", Enum(NSKeyValueChangeInsertion),
                                              nil]);

		}
	}
}

-(void) removeObjectForKey:(id)aKey {
	id oldObj = [proxyDict objectForKey:aKey];
	[proxyDict removeObjectForKey:aKey];
	ObjectChangedBlock changedBlock = [OBSERVERMAN.observeBlock objectForKey:proxyKeyPath];
	if (nil != changedBlock) {
        oldObj = nil;
        changedBlock(proxyKeyPath, self, [NSDictionary dictionaryWithKeysAndObjects:
                                          @"kind", Enum(NSKeyValueChangeRemoval),
                                          nil]);
	}
}

-(void)dealloc {
	[proxyKeyPath release];
	[proxyDict release];
	[super dealloc];
}

@end
