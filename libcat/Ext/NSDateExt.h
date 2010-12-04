//
//  NSDateExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 29/07/10.
//  Copyright 2010 factorcat. All rights reserved.
//


#define ONE_DAY_SECONDS		86400 // 1 day = 60*60*24 seconds
#define ONE_HOUR_SECONDS	3600 // 60*60
#define ONE_MINUTE_SECONDS	60
#define ONE_YEAR_DAYS		355

#define WEEKDAY_COUNT 7
#define FIRST_WEEKDAY_OF_CALENDAR [[NSCalendar currentCalendar] firstWeekday]

typedef enum {
	WEEKDAY_NONE = 0,
	WEEKDAY_SUNDAY = 1,
	WEEKDAY_MONDAY = 2,
	WEEKDAY_TUESDAY = 3,
	WEEKDAY_WEDNESDAY = 4,
	WEEKDAY_THIRSDAY = 5,
	WEEKDAY_FRIDAY = 6,
	WEEKDAY_SATURDAY = 7
} kWeekdayIndex ;

enum PostfixTypes {
	POSTFIX_YEAR = 1,
	POSTFIX_MONTH = 2,
	POSTFIX_DAY = 3,
	POSTFIX_HOUR = 4,
	POSTFIX_MINUTE = 5,
};
NSString* postfix_string(int postfix) ;
NSString* hourName_minute_second_SPACE(NSTimeInterval ti) ;




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
+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second ;
-(NSDate*) after:(NSTimeInterval)ti ;
-(NSDate*) beginOfDate ;
-(NSDate*) endOfDate ;	
-(NSDate*) oneYearAgo ;
-(NSDate*) oneYearAfter ;
-(NSDate*) oneDayBefore ;
-(int) countDownOfTheDay:(NSDate*)comingDate ;

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
-(NSString*) monthName ;
-(NSString*) monthName_day_SPACE ;
-(NSString*) monthName_day_weekday_SPACE ;
-(NSString*) amPM_hourName_minute_SPACE ;
-(NSString*) amPM_hourName_SPACE ;	
-(NSString*) hourName_SPACE ;	
-(NSString*) hourName_minute_SPACE ;
-(NSString*) hourName_minute_second_SPACE ;
-(NSString*) hour_minute_COLON ;
-(NSString*) hour_minute_second_COLON ;
-(NSString*) gmtString ;

@end

@interface NSDate (Month)
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
-(BOOL) isSameMonth:(NSDate*)date ;
@end


@interface NSDate (Weekday)
+(NSArray*) weekdayNames ;
+(int) sundayWeekdayIndex ;
-(NSString*) weekdayName ;
-(BOOL) isSunday ;
@end


@interface NSDate (Day)
-(BOOL) isSameDay:(NSDate*)date ;
-(BOOL) isToday ;
-(BOOL) isFuture ;
-(BOOL) isPast ;
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
