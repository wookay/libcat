//
//  NSLocaleExt.h
//  BigCalendar
//
//  Created by wookyoung noh on 20/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//


@implementation NSLocale (Ext)

// zh-Hant 번체
// zh-Hans 간체

+(NSString*) firstPreferredLanguage {
	return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+(BOOL) isFirstPreferredLanguage:(NSString*)lang {
	return [lang isEqualToString:[[NSLocale preferredLanguages] objectAtIndex:0]];
}

+(BOOL) isCurrentLocaleIdentifier:(NSString*)identifier {
	return [identifier isEqualToString:[[NSLocale currentLocale] localeIdentifier]];
}

@end
