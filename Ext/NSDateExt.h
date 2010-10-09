//
//  NSDateExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 29/07/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ONE_DAY_SECONDS		86400 // 1 day = 60*60*24 seconds
#define ONE_HOUR_SECONDS	3600 // 60*60
#define ONE_MINUTE_SECONDS	60

#define WEEKDAY_COUNT 7
#define FIRST_WEEKDAY_OF_CALENDAR [[NSCalendar currentCalendar] firstWeekday]

enum WeekdayIndexes {
	WEEKDAY_SUNDAY = 1,
	WEEKDAY_MONDAY = 2,
	WEEKDAY_TUESDAY = 3,
	WEEKDAY_WEDNESDAY = 4,
	WEEKDAY_THIRSDAY = 5,
	WEEKDAY_FRIDAY = 6,
	WEEKDAY_SATURDAY = 7
};

enum PostfixTypes {
	POSTFIX_MONTH = 1,
	POSTFIX_DAY = 2,
	POSTFIX_HOUR = 3,
	POSTFIX_MINUTE = 4,
};
NSString* postfix_string(int postfix) ;





@interface NSDate (Ext)

#pragma mark int
-(int) year ;
-(int) month ;
-(int) day ;
-(int) hour ;	
-(int) minute ;
-(int) second ;
-(int) weekday ;

#pragma mark NSDate
+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day ;
+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day hour:(int)hour ;
+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute ;
-(NSDate*) after:(NSTimeInterval)ti ;
-(NSDate*) beginOfDate ;
-(NSDate*) endOfDate ;	
-(NSDate*) oneYearAgo ;
-(NSDate*) oneYearAfter ;
-(NSDate*) oneDayBefore ;

#pragma mark NSDateComponents
-(NSDateComponents*) today_components ;
-(NSDateComponents*) tomorrow_components ;

#pragma mark NSString
-(NSString*) year_month_day_MINUS ;
-(NSString*) year_month_day_DOT_SPACE ;	
-(NSString*) year_month_day_MINUS_hour_minute_COLON ;
-(NSString*) year_month_day_MINUS_hour_minute_second_COLON ;
-(NSString*) year_month_day_MINUS_AMPM_hour_minute_COLON ;
-(NSString*) year_monthName_SPACE ;
-(NSString*) year_monthName_day_SPACE ;
-(NSString*) month_day_DOT ;
-(NSString*) monthName_day_SPACE ;
-(NSString*) monthName_day_weekday_SPACE ;
-(NSString*) amPM_hourName_minute_SPACE ;
-(NSString*) amPM_hourName_SPACE ;	
-(NSString*) hourName_minute_SPACE ;
-(NSString*) hourName_SPACE ;	
-(NSString*) hour_minute_COLON ;
-(NSString*) hour_minute_second_COLON ;
-(NSString*) gmtString ;

#pragma mark month
-(int) numberOfDaysInMonth ;
-(int) firstWeekdayInMonth ;
-(int) lastWeekdayInMonth ;
-(NSDate*) firstDayInMonth ;
-(NSDate*) lastDayInMonth ;
-(NSDate*) tomorrow ;
-(NSDate*) yesterday ;
-(NSDate*) firstDayOfPreviousMonth ;
-(NSArray*) lastWeekOfPreviousMonth ;
-(NSDate*) firstDayOfNextMonth ;
-(int) firstWeekdayOfNextMonth ;
-(NSArray*) firstWeekOfNextMonth ;
-(NSArray*) allDaysInMonth ;
-(int) numberOfWeeksInMonth ;
-(NSArray*) monthTable ;
-(int) weekdayIndex ;
+(NSArray*) weekdayNames ;
-(NSString*) weekdayName ;
-(BOOL) isSameMonth:(NSDate*)date ;

@end



#pragma mark AMPM
typedef struct AMPMHour12 {
	int ampm;
	int hour12;
} AMPMHour12;
enum { HOUR_AM, HOUR_PM };

@interface NSDate (AMPM)
+(int) ampm:(int)amPm hour12_to_hour24:(int)hour12 ;
+(AMPMHour12) hour24_to_ampm_hour12:(int)hour24 ;
@end
