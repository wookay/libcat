//
//  ObserverManager.m
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ObserverManager.h"
#import "Logger.h"
#import "NSMutableArrayExt.h"
#import "NSStringExt.h"


@implementation ObserverManager


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
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

@end





@implementation NSObject (Observer)

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withObjectChangedBlock:(ObjectChangedBlock)block {
	[self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:block];
}

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withArrayChangedBlock:(ArrayChangedBlock)block {
	[self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:block];
}

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withSetChangedBlock:(SetChangedBlock)block {
	[self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:block];
}

@end


NSString* keyValueChangeToString(NSKeyValueChange kind) {
	return [_w(@"nil NSKeyValueChangeSetting NSKeyValueChangeInsertion NSKeyValueChangeRemoval NSKeyValueChangeReplacement")
			objectAtIndex:kind];
}

@implementation Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	//	log_info(@"observeValueForKeyPath %@ %@ %@ %d", keyPath, object, change, context);
	if (nil != context) {
		NSKeyValueChange kind = [[change objectForKey:@"kind"] intValue];
		
		if (NSKeyValueChangeSetting == kind) {
			ObjectChangedBlock block = context;
			id obj = [change objectForKey:@"new"];
			id oldObj = [change objectForKey:@"old"];
			block(kind, obj, oldObj);
		} else {
			NSIndexSet* indexes = [change objectForKey:@"indexes"];			
			if (nil == indexes) {
				switch (kind) {
					case NSKeyValueChangeRemoval: {
							NSArray* old = [change objectForKey:@"old"];
							SetChangedBlock block = context;
							for (id oldObj in old) {
								block(kind, nil, oldObj);
							}						
						}
						break;
					case NSKeyValueChangeInsertion: {
							SetChangedBlock block = context;
							NSArray* new = [change objectForKey:@"new"];
							for (id obj in new) {
								block(kind, obj, nil);
							}					
						}
						break;
					default:
						log_info(@"default nilindex");
						break;
				}			
			} else {
				ArrayChangedBlock block = context;
				NSArray* old = [change objectForKey:@"old"];
				NSArray* new = [change objectForKey:@"new"];
				__block int idx = 0;
				[indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
					switch (kind) {
						case NSKeyValueChangeRemoval: {
								id oldObj = [old objectAtIndex:idx];
								block(kind, nil, oldObj, index);
							}
							break;												
						case NSKeyValueChangeInsertion: {
								id obj = [new objectAtIndex:idx];
								block(kind, obj, nil, index);
							}
							break;
						case NSKeyValueChangeReplacement: {
							id oldObj = [old objectAtIndex:idx];
							id newObj = [new objectAtIndex:idx];
							block(kind, newObj, oldObj, index);
						}
							break;						
						default:
							break;
					}
					idx += 1;
				}];		
			}
		}
	}
}

@end
