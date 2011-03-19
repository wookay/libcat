//
//  NSBundleExt.m
//  JanggiNorm
//
//  Created by Woo-Kyoung Noh on 18/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSBundleExt.h"


@implementation NSBundle (Ext)

+ (NSString*) bundleName {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];	
}

+ (NSString*) bundleDisplayName {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];	
}

+ (NSString*) bundleVersion {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];	
}

@end
