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

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath changed:(ObjectChangedBlock)block {
	[self addObserver:observer
		   forKeyPath:keyPath 
			  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew 
			  context:block];
}

@end


