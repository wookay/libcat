//
//  ObserverManager.h
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer.h"
#import "NSObjectObserverExt.h"



#define OBSERVERMAN	[ObserverManager sharedManager]

@interface ObserverManager : Observer {
	NSMutableDictionary* observeBlock;
}
@property (nonatomic, retain) 	NSMutableDictionary* observeBlock;

-(void) addDictionaryChangedBlock:(id)block forKeyPath:(NSString*)keyPath ;
-(void) removeDictionaryChangedBlockForKeyPath:(NSString*)keyPath ;

+ (ObserverManager*) sharedManager ;
@end

