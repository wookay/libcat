//
//  NSObjectObserverExt.h
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxyMutableDictionary.h"
#import "Observer.h"




@interface NSObject (ObserverExt)

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withObjectChangedBlock:(ObjectChangedBlock)block ;
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withSetChangedBlock:(SetChangedBlock)block ;
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withArrayChangedBlock:(ArrayChangedBlock)block ;
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withDictionarySetBlock:(DictionaryChangedBlock)block ;

@end


@interface NSObject (NSKeyValueCodingExt)

-(id) mutableDictionaryValueForKeyPath:(NSString*)keyPath ;

@end

