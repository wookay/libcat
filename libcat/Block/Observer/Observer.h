//
//  Observer.h
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* keyValueChangeToString(NSKeyValueChange kind) ;

typedef void (^ObjectChangedBlock)(NSString* keyPath, id object, NSDictionary* change);

@interface Observer : NSObject

@end
