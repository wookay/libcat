//
//  NSObjectObserverExt.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSObjectObserverExt.h"
#import "Logger.h"
#import "NSArrayExt.h"

@implementation NSObject (ObserverExt)

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withObjectChangedBlock:(ObjectChangedBlock)block {
	[self addObserver:observer
		   forKeyPath:keyPath 
			  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew 
			  context:PAIR([NSObject class], Block_copy(block))];
}

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withArrayChangedBlock:(ArrayChangedBlock)block {
	[self addObserver:observer 
		   forKeyPath:keyPath 
			  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
			  context:PAIR([NSMutableArray class], Block_copy(block))];
}
	
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withSetChangedBlock:(SetChangedBlock)block {
	[self addObserver:observer 
		   forKeyPath:keyPath
			  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew 
			  context:PAIR([NSMutableSet class], Block_copy(block))];
}

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withDictionarySetBlock:(DictionaryChangedBlock)block {
	[self addObserver:observer 
		   forKeyPath:keyPath 
			  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
			  context:PAIR([NSMutableDictionary class], Block_copy(block))];
}

@end


@implementation NSObject (NSKeyValueCodingExt)

-(id) mutableDictionaryValueForKeyPath:(NSString*)keyPath {
	id obj = [self valueForKeyPath:keyPath];
	if ([obj isKindOfClass:[ProxyMutableDictionary class]]) {
		return obj;
	} else {
		ProxyMutableDictionary* dict = [[[ProxyMutableDictionary alloc] init] autorelease];
		dict.proxyKeyPath = keyPath;
		if ([obj isKindOfClass:[NSDictionary class]]) {
			dict.proxyDict = [NSMutableDictionary dictionaryWithDictionary:obj];
		}
		[self setValue:dict forKeyPath:keyPath];
		return dict;
	}
}

@end
