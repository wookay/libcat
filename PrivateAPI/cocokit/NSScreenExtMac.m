//
//  NSScreenExtMac.m
//  MacApp
//
//  Created by WooKyoung Noh on 08/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "NSScreenExtMac.h"


@implementation NSScreen (ExtMac)
-(CGRect) bounds {
	return NSRectToCGRect([UIApplication sharedApplication].keyWindow.frame);
}
@end
