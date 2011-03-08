//
//  NSDateComponentsExt.h
//  Cal
//
//  Created by WooKyoung Noh on 26/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UNIT_FLAGS_YMDHMSWW (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekCalendarUnit )
#define UNIT_FLAGS_YMDHMS	(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
#define UNIT_FLAGS_YMDWW	(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekCalendarUnit )
#define UNIT_FLAGS_YM		(NSYearCalendarUnit | NSMonthCalendarUnit )


@interface NSDateComponents (Ext)
+(NSDateComponents*) dateComponentsFrom:(int)year month:(int)month ;
+(NSDateComponents*) dateComponentsFrom:(int)year month:(int)month day:(int)day ;
+(NSArray*) daysFromYear:(int)year ;
-(int) weekdayIndexForCalendar:(NSCalendar*)calendar ;
+(int) sundayIndexForCalendar:(NSCalendar*)calendar ;
-(NSDate*) to_date ;
-(NSString*) gmtString ;
@end