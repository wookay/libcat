//
//  ObserverManager.h
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OBSERVERMAN	[ObserverManager sharedManager]


NSString* keyValueChangeToString(NSKeyValueChange kind) ;

typedef void (^ObjectChangedBlock)(NSKeyValueChange kind, id obj, id oldObj) ;
typedef void (^SetChangedBlock)(NSKeyValueChange kind, id obj, id oldObj) ;
typedef void (^ArrayChangedBlock)(NSKeyValueChange kind, id obj, id oldObj, int idx) ;


@interface Observer : NSObject
@end


@interface NSObject (Observer)
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withObjectChangedBlock:(ObjectChangedBlock)block ;
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withSetChangedBlock:(SetChangedBlock)block ;
-(void) addObserver:(Observer*)observer forKeyPath:(NSString *)keyPath withArrayChangedBlock:(ArrayChangedBlock)block ;
@end



@interface ObserverManager : Observer {

}

+ (ObserverManager*) sharedManager ;

@end
