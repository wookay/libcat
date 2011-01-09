//
//  NSWindowExtMac.m
//  MacApp
//
//  Created by WooKyoung Noh on 07/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "NSWindowExtMac.h"
#import "Logger.h"
#import "NSArrayExt.h"

@implementation NSWindow (ExtMac)
-(NSArray*) subviews {
	return [[self contentView] subviews];
}
- (CALayer *) layer {
	return [[self contentView] layer];
}
@end