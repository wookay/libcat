//
//  Observer.h
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* keyValueChangeToString(NSKeyValueChange kind) ;

typedef void (^ObjectChangedBlock)(NSKeyValueChange kind, id obj, id oldObj) ;
typedef void (^SetChangedBlock)(NSKeyValueChange kind, id obj, id oldObj) ;
typedef void (^ArrayChangedBlock)(NSKeyValueChange kind, id obj, id oldObj, int idx) ;
typedef void (^DictionaryChangedBlock)(NSKeyValueChange kind, id obj, id oldObj, id key) ;

@interface Observer : NSObject

@end
