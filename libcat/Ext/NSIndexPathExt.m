//
//  NSIndexPathExt.m
//  JanggiNorm
//
//  Created by Woo-Kyoung Noh on 18/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSIndexPathExt.h"


@implementation NSIndexPath (Ext)

+(NSIndexPath*) indexPathWithSection:(NSUInteger)section_ Row:(NSUInteger)row_ {
	return [NSIndexPath indexPathForRow:row_ inSection:section_];
}

@end
