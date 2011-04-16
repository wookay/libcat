//
//  NSDateExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 29/07/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDateComponentsExt.h"

#define ONE_DAY_SECONDS		86400 // 1 day = 60*60*24 seconds
#define ONE_HOUR_SECONDS	3600 // 60*60
#define ONE_MINUTE_SECONDS	60
#define ONE_DAY_HOURS		24

#define WEEKDAY_COUNT 7
#define MONTH_COUNT	12
#define FIRST_WEEKDAY_OF_CALENDAR [[NSCalendar currentCalendar] firstWeekday]
#define TIMEINTERVAL_CHALNA 0.00000000000000000000001

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

NSString* hourName_minute_second_SPACE(NSTimeInterval ti) ;
NSString* monthName_standalone(int month) ;
NSString* monthName_short_standalone(int month) ;
NSString* monthName_day_SPACE(int month, int day) ;
NSString* monthLongName_day_SPACE(int month, int day) ;
NSString* int_to_yearName(int year) ;
NSString* int_to_monthName(int month) ;
NSString* int_to_dayName(int day) ;
NSString* int_to_hourName(int hour) ;
NSString* int_to_minuteName(int minute) ;
NSString* int_to_secondName(int second) ;

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
-(NSDate*) nDaysAfter:(int)nDays ;
-(int) countDownOfTheDay:(NSDate*)comingDate ;

#pragma mark NSDateComponents
-(NSDateComponents*) to_dateComponents ;
-(NSDateComponents*) today_dateComponents ;
-(NSDateComponents*) tomorrow_dateComponents ;
-(NSDateComponents*) yesterday_dateComponents ;

#pragma mark NSString
-(NSString*) yearName ;
-(NSString*) year_month_day_MINUS ;
-(NSString*) year_month_day_DOT_SPACE ;	
-(NSString*) year_month_day_MINUS_hour_minute_COLON ;
-(NSString*) year_month_day_MINUS_hour_minute_second_COLON ;
-(NSString*) year_month_day_MINUS_hour_minute_second_MINUS ;
-(NSString*) year_month_day_MINUS_AMPM_hour_minute_COLON ;
-(NSString*) year_monthName_SPACE ;
-(NSString*) year_monthName_day_SPACE ;
-(NSString*) month_day_DOT ;
-(NSString*) monthName ;
-(NSString*) monthName_day_SPACE ;
-(NSString*) monthLongName_day_SPACE ;
-(NSString*) monthName_day_weekday_SPACE ;
-(NSString*) amPM_hourName_minute_SPACE ;
-(NSString*) amPM_hourName_SPACE ;	
-(NSString*) hourName_SPACE ;	
-(NSString*) hourName_minute_SPACE ;
-(NSString*) hourName_minute_second_SPACE ;
-(NSString*) hour_minute_COLON ;
-(NSString*) hour_minute_second_COLON ;
-(NSString*) gmtString ;
+(NSDate*) dateWithGMTString:(NSString*)str ;

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
-(NSString*) weekdayName ;
+(NSArray*) weekdayNames ;
-(NSString*) shortWeekdayName ;
+(NSArray*) shortWeekdayNames ;
-(NSString*) shortWeekdayHanjaName ;
+(NSArray*) shortWeekdayHanjaNames ;	
+(int) sundayWeekdayIndex ;
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