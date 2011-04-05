//
//  NSLocaleExt.h
//  BigCalendar
//
//  Created by wookyoung noh on 27/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IS_LANG_KOREAN		[@"ko" isEqualToString:[[NSLocale preferredLanguages] objectAtIndex:0]]
#define IS_LOCALE_KOREAN	[@"ko_KR" isEqualToString:[[NSLocale currentLocale] localeIdentifier]]


@interface NSLocale (Ext)
+(NSString*) firstPreferredLanguage ;
+(BOOL) isFirstPreferredLanguage:(NSString*)lang ;
+(BOOL) isCurrentLocaleIdentifier:(NSString*)identifier ;
@end