//
//  NSTimerExt.h
//  JanggiNorm
//
//  Created by Woo-Kyoung Noh on 16/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (Ext)
+ (void) afterDelay:(NSTimeInterval)ti target:(id)aTarget action:(SEL)aSelector ;
+ (void) afterDelay:(NSTimeInterval)ti target:(id)aTarget action:(SEL)aSelector userInfo:(id)userInfo ;
@end
