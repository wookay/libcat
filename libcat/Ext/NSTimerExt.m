//
//  NSTimerExt.m
//  JanggiNorm
//
//  Created by Woo-Kyoung Noh on 16/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSTimerExt.h"


@implementation NSTimer (Ext)

+(void) afterDelay:(NSTimeInterval)ti target:(id)aTarget action:(SEL)aSelector {
	[self scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:nil repeats:false];
}

+(void) afterDelay:(NSTimeInterval)ti target:(id)aTarget action:(SEL)aSelector userInfo:(id)userInfo {
	[self scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:false];
}

@end
