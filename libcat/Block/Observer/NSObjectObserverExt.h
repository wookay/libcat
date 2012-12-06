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

-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath changed:(ObjectChangedBlock)block ;

@end


