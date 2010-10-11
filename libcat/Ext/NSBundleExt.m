//
//  NSBundleExt.m
//  JanggiNorm
//
//  Created by Woo-Kyoung Noh on 18/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSBundleExt.h"


@implementation NSBundle (Ext)

+ (NSString*) bundleVersion {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];	
}

@end
