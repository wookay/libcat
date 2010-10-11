//
//  NSObjectExt.m
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSObjectExt.h"


@implementation NSObject (Ext)

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti {
	[self performSelector:selector withObject:nil afterDelay:ti];
}

-(BOOL) isNull {
	return [self isKindOfClass:[NSNull class]];
}

-(BOOL) isNotNull {
	return ! [self isKindOfClass:[NSNull class]];
}

@end