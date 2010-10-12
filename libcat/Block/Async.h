//
//  Async.h
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AsyncBlock)();

@interface Async : NSObject {

}
+(void) perform:(AsyncBlock)block ;
+(void) perform:(AsyncBlock)block afterDelay:(NSTimeInterval)delay ;
+(void) perform:(AsyncBlock)block afterDone:(AsyncBlock)completeBlock ;

@end
