//
//  ObserverManager.m
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ObserverManager.h"

@implementation ObserverManager
@synthesize observeBlock;


-(void) addDictionaryChangedBlock:(id)block forKeyPath:(NSString*)keyPath {
	[observeBlock setObject:Block_copy(block) forKey:keyPath];
}

-(void) removeDictionaryChangedBlockForKeyPath:(NSString*)keyPath {
	id block = [observeBlock objectForKey:keyPath];
	Block_release(block);
	[observeBlock removeObjectForKey:keyPath];
}


+ (ObserverManager*) sharedManager {
	static ObserverManager*	manager = nil;
	if (!manager) {
		manager = [ObserverManager new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
		self.observeBlock = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc {
	for (id block in [observeBlock allValues]) {
		Block_release(block);
	}
	[observeBlock release];	
	[super dealloc];
}

@end

