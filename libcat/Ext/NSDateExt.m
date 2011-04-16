//
//  NSDateExt.m
//  Concats
//
//  Created by Woo-Kyoung Noh on 29/07/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDateExt.h"
#import "Logger.h"
#import "NSStringExt.h"
#import "NSLocaleExt.h"
#import "Numero.h"
#import "NSDictionaryExt.h"
#import "NSArrayExt.h"
#import "Inspect.h"


NSString* timeInterval_to_hourName_minute_second_SPACE(NSTimeInterval ti) {
	NSMutableArray* ary = [NSMutableArray array];
	NSTimeInterval left = ti;
	if (left > ONE_HOUR_SECONDS) {
		int hour = left/ONE_HOUR_SECONDS;
		left -= hour*ONE_HOUR_SECONDS;
		if (IS_LANG_KOREAN) {
			[ary addObject:SWF(@"%d시간", hour)];
		} else {
			[ary addObject:SWF(@"%d %@", hour, 1 == hour ? NSLocalizedString(@"hour", nil) : NSLocalizedString(@"hours", nil))];
		}
	}
	if (left > ONE_MINUTE_SECONDS) {
		int minute = left/ONE_MINUTE_SECONDS;
		left -= minute*ONE_MINUTE_SECONDS;
		[ary addObject:int_to_minuteName(minute)];
	}
	int seconds = left;
	if (0 == seconds) {
	} else {
		[ary addObject:int_to_minuteName(seconds)];
	}
	return [ary componentsJoinedByString:SPACE];
}

NSString* int_to_yearName(int year) {
	return [[NSDate dateFrom:year month:1 day:1] yearName];
}

NSString* int_to_monthName(int month) {
	return [[NSDate dateFrom:1 month:month day:1] monthName];
}

NSString* int_to_dayName(int day) {
	if (IS_LANG_KOREAN) {
		return SWF(@"%d일", day);
	} else {
		return SWF(@"%d", day);
	}	
}

NSString* int_to_hourName(int hour) {
	if (IS_LANG_KOREAN) {
		return SWF(@"%d시", hour);
	} else {
		return SWF(@"%d", hour);
	}		
}

NSString* int_to_minuteName(int minute) {
	if (IS_LANG_KOREAN) {
		return SWF(@"%02d분", minute);
	} else {
		return SWF(@"%02d", minute);
	}		
}

NSString* int_to_secondName(int second) {
	if (IS_LANG_KOREAN) {
		return SWF(@"%d초", second);
	} else {
		return SWF(@"%02d", second);
	}	
}

NSString* monthName_standalone(int month) {
	int idx = month - 1;
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	NSString* monthName = [[formatter standaloneMonthSymbols] objectAtIndex:idx];
	[formatter release];
	return monthName;
}

NSString* monthName_short_standalone(int month) {
	int idx = month - 1;
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	NSString* monthName = [[formatter shortStandaloneMonthSymbols] objectAtIndex:idx];
	[formatter release];
	return monthName;
}

NSString* monthName_day_SPACE(int month, int day) {
	NSDate* date = [NSDate dateFrom:0 month:month day:day];
	return [date monthName_day_SPACE];
}

NSString* monthLongName_day_SPACE(int month, int day) {
	NSDate* date = [NSDate dateFrom:0 month:month day:day];
	return [date monthLongName_day_SPACE];
}


#ifdef BUILD_313
@interface NSDate (Build313)
-(NSDate*) dateByAddingTimeInterval:(NSTimeInterval)ti ;
@end
@implementation NSDate (Build313)
-(NSDate*) dateByAddingTimeInterval:(NSTimeInterval)ti {
	return [self addTimeInterval:ti];
}
@end
#endif


@interface NSDate (Private)
-(NSString*) formatWith:(NSString*)format ;
-(NSDate*) internal_dateByAddingTimeInterval:(NSTimeInterval)ti ;
@end
@implementation NSDate (Private)
-(NSDate*) internal_dateByAddingTimeInterval:(NSTimeInterval)ti {
	if ([self respondsToSelector:@selector(dateByAddingTimeInterval:)]) {
		return [self dateByAddingTimeInterval:ti];
	} else {
		NSTimeInterval secs = [self timeIntervalSinceReferenceDate];
		secs += ti;
		return [NSDate dateWithTimeIntervalSinceReferenceDate:secs];
	}
	return nil;
}

-(NSString*) formatWith:(NSString*)format {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
	NSString* str = [df stringFromDate:self];
	[df release];
	return str;		
}
@end



@implementation NSDate (Ext)


#pragma mark int
-(int) year {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
	return comps.year;
}

-(int) month {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
	return comps.month;
}

-(int) day {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
	return comps.day;
}

-(int) hour {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];
	return comps.hour;	
}
-(int) minute {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];
	return comps.minute;	
}

-(int) second {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];
	return comps.second;	
}

-(int) weekday {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
	return comps.weekday;	
}


#pragma mark NSDate
+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day {
	return [self dateFrom:year month:month day:day hour:0];
}

+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day hour:(int)hour {
	return [self dateFrom:year month:month day:day hour:hour minute:0];
}

+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute {
	return [self dateFrom:year month:month day:day hour:hour minute:0 second:0];
}

+(NSDate*) dateFrom:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second {
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:UNIT_FLAGS_YMDHMS fromDate:self];
	comps.year = year;
	comps.month = month;
	comps.day = day;
	comps.hour = hour;
	comps.minute = minute;
	comps.second = second;
	return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

-(NSDate*) after:(NSTimeInterval)ti {
	return [self internal_dateByAddingTimeInterval:ti];
}

-(NSDate*) beginOfDate {
	return [NSDate dateFrom:[self year] month:[self month] day:[self day]];
}

-(NSDate*) endOfDate {
	return [[self beginOfDate] internal_dateByAddingTimeInterval:ONE_DAY_SECONDS-1];
}

-(NSDate*) oneDayBefore {
	return [self internal_dateByAddingTimeInterval: -ONE_DAY_SECONDS];
}

-(NSDate*) nDaysAfter:(int)nDays {
	NSDateComponents* comps = [[NSDateComponents alloc] init];
	comps.day = nDays;
	NSDate* date = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	[comps release];
	return date;
}

-(NSDate*) oneYearAgo {
	return [NSDate dateFrom:[self year]-1 month:[self month] day:[self day]];
}

-(NSDate*) oneYearAfter {
	return [NSDate dateFrom:[self year]+1 month:[self month] day:[self day]];
}

-(int) countDownOfTheDay:(NSDate*)comingDate {
	return [[comingDate beginOfDate] timeIntervalSinceDate:[self beginOfDate]] / ONE_DAY_SECONDS;
}

#pragma mark NSDateComponents
-(NSDateComponents*) to_dateComponents {
	unsigned unitFlags = UNIT_FLAGS_YMDHMSWW;
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
	return comps;	
}

-(NSDateComponents*) today_dateComponents {
	unsigned unitFlags = UNIT_FLAGS_YMDWW;
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
	return comps;	
}

-(NSDateComponents*) tomorrow_dateComponents {
	unsigned unitFlags = UNIT_FLAGS_YMDWW;
	NSDate* tomorrow = [self internal_dateByAddingTimeInterval:ONE_DAY_SECONDS];
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:tomorrow];
	return comps;
}

-(NSDateComponents*) yesterday_dateComponents {
	unsigned unitFlags = UNIT_FLAGS_YMDWW;
	NSDate* tomorrow = [self internal_dateByAddingTimeInterval:-ONE_DAY_SECONDS];
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:tomorrow];
	return comps;
}


#pragma mark NSString

-(NSString*) year_month_day_MINUS {
	return [self formatWith:@"yyyy-MM-dd"];
}

-(NSString*) month_day_DOT {
	return [self formatWith:@"M.d"];
}

-(NSString*) yearName {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"yyyy년"];
	} else {
		return [self formatWith:@"yyyy"];
	}	
}

-(NSString*) year_monthName_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"yyyy년 LLL"];
	} else {
		return [self formatWith:@"LLL yyyy"];
	}	
}

-(NSString*) year_monthName_day_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"yyyy년 LLL d일"];
	} else {
		return [self formatWith:@"LLL d, yyyy"];
	}	
}

-(NSString*) amPM_hourName_minute_SPACE {
	if (0 == self.minute) {
		if (IS_LOCALE_KOREAN) {
			return [self formatWith:@"a h시"];
		} else {
			return [self formatWith:@"a h"];
		}		
	} else {
		if (IS_LOCALE_KOREAN) {
			return [self formatWith:@"a h시 m분"];
		} else {
			return [self formatWith:@"a h:mm"];
		}
	}
}

-(NSString*) amPM_hourName_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"a h시"];
	} else {
		return [self formatWith:@"a h"];
	}
}

-(NSString*) hourName_minute_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"H시 m분"];
	} else {
		return [self formatWith:@"H:m"];
	}
}

-(NSString*) hourName_minute_second_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"H시 m분 s초"];
	} else {
		return [self formatWith:@"H:m:s"];
	}
}

-(NSString*) hourName_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"H시"];
	} else {
		return [self formatWith:@"H"];
	}
}

-(NSString*) monthName {
	return [self formatWith:@"LLLL"];
}

-(NSString*) monthName_day_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"LLL d일"];
	} else {
		return [self formatWith:@"d/LLL"];
	}
}

-(NSString*) monthLongName_day_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"LLLL d일"];
	} else {
		return [self formatWith:@"d / LLLL"];
	}
}

-(NSString*) monthName_day_weekday_SPACE {
	if (IS_LOCALE_KOREAN) {
		return [self formatWith:@"M월 d일 E요일"];
	} else {		
		return [self formatWith:@"EEEE, d MMM"];
	}
}

-(NSString*) year_month_day_DOT_SPACE {
	return [self formatWith:@"Y. M. d."];
}

-(NSString*) hour_minute_second_COLON {
	return [self formatWith:@"HH:mm:ss"];
}

-(NSString*) hour_minute_COLON {
	return [self formatWith:@"HH:mm"];
}

-(NSString*) year_month_day_MINUS_hour_minute_COLON {
	return [self formatWith:@"yyyy-MM-dd HH:mm"];
}

-(NSString*) year_month_day_MINUS_AMPM_hour_minute_COLON {
	return [self formatWith:@"yyyy-MM-dd a hh:mm"];
}

-(NSString*) AMPM_hour_minute_COLON {
	return [self formatWith:@"a h:mm"];
}

-(NSString*) year_month_day_MINUS_hour_minute_second_COLON {
	return [self formatWith:@"yyyy-MM-dd HH:mm:ss"];
}

-(NSString*) year_month_day_MINUS_hour_minute_second_MINUS {
	return [self formatWith:@"yyyy-MM-dd HH-mm-ss"];
}

-(NSString*) gmtString {
	return [self formatWith:@"yyyy-MM-dd HH:mm:ss Z"];
}

+(NSDate*) dateWithGMTString:(NSString*)str {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
	NSDate* date = [dateFormatter dateFromString:str];
	[dateFormatter release];
	return date;
}

@end



@implementation NSDate (Month)

-(int) numberOfDaysInMonth {
	int count = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
	return count;
}

-(int) firstWeekdayInMonth {
	int weekday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
	return weekday;
}

-(int) lastWeekdayInMonth {
	int weekday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
	return (weekday + [self numberOfDaysInMonth] - 1) % WEEKDAY_COUNT;
}

-(NSDate*) tomorrow {
	NSDateComponents* comp = [self tomorrow_dateComponents];
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

-(NSDate*) yesterday {
	NSDateComponents* comp = [self yesterday_dateComponents];
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}


#pragma mark month
-(NSDate*) firstDayInMonth {
	NSDate* date = nil;
	[[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&date interval:NULL forDate:self];
	return date;
}

-(NSDate*) lastDayInMonth {
	unsigned unitFlags = NSYearCalendarUnit | kCFCalendarUnitMonth;
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
	return [NSDate dateFrom:comps.year month:comps.month day:[self numberOfDaysInMonth]];
}

-(NSDate*) firstDayOfPreviousMonth {
	NSDateComponents* comps = [[NSDateComponents alloc] init];
	comps.month = -1;
	NSDate* date = [[[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0] firstDayInMonth];  
	[comps release];
	return date;
}

-(NSDate*) firstDayOfNextMonth {
	NSDateComponents* comps = [[NSDateComponents alloc] init];
	comps.month = 1;
	NSDate* date = [[[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0] firstDayInMonth];
	[comps release];
	return date;
}

-(NSArray*) lastWeekOfPreviousMonth {
	NSDate* firstDayOfPreviousMonth = [self firstDayOfPreviousMonth];	
	unsigned unitFlags = NSYearCalendarUnit | kCFCalendarUnitMonth;
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:firstDayOfPreviousMonth];
	int lastWeekdayInMonth = [firstDayOfPreviousMonth lastWeekdayInMonth];
	int numberOfDaysInMonth = [firstDayOfPreviousMonth numberOfDaysInMonth];
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = numberOfDaysInMonth - lastWeekdayInMonth + 1 ; idx <= numberOfDaysInMonth; idx++) {
		[ary addObject:[NSDate dateFrom:comps.year month:comps.month day:idx]];
	}
	return ary;
}

-(NSArray*) firstWeekOfNextMonth {
	NSDate* firstDayOfNextMonth = [self firstDayOfNextMonth];
	int firstWeekdayInMonth = [firstDayOfNextMonth firstWeekdayInMonth];
	unsigned unitFlags = NSYearCalendarUnit | kCFCalendarUnitMonth;
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:firstDayOfNextMonth];
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 1; idx <= WEEKDAY_COUNT - firstWeekdayInMonth + 1; idx++) {
		[ary addObject:[NSDate dateFrom:comps.year month:comps.month day:idx]];
	}
	return ary;
}

-(int) firstWeekdayOfNextMonth {
	NSDate* firstDayOfNextMonth = [self firstDayOfNextMonth];
	return [firstDayOfNextMonth firstWeekdayInMonth];
}

-(NSArray*) allDaysInMonth {
	int year_ = self.year;
	int month_ = self.month;
	NSMutableArray* ary = [NSMutableArray array];
	for (int day_ = 1; day_ <= [self numberOfDaysInMonth]; day_++) {
		NSDate* date = [NSDate dateFrom:year_ month:month_ day:day_];
		[ary addObject:date];
	}
	return ary;
}

-(int) numberOfWeeksInMonth {
	CGFloat firstWeekdayInMonth = [self firstWeekdayInMonth] - FIRST_WEEKDAY_OF_CALENDAR;
	return ceil((firstWeekdayInMonth + [self numberOfDaysInMonth]) / WEEKDAY_COUNT);
}

-(NSArray*) monthTable {	
	NSMutableArray* totalDays = [NSMutableArray array];
	[totalDays addObjectsFromArray:[self lastWeekOfPreviousMonth]];
	[totalDays addObjectsFromArray:[self allDaysInMonth]];
	if (WEEKDAY_SUNDAY != [self firstWeekdayOfNextMonth]) {
		[totalDays addObjectsFromArray:[self firstWeekOfNextMonth]];
	}
	NSMutableArray* weeks = [NSMutableArray array];
	for (int idx = 0; idx < totalDays.count; idx += WEEKDAY_COUNT) {
		NSArray* weekdays = [totalDays slice:idx :WEEKDAY_COUNT];
		[weeks addObject:weekdays];
	}
	return weeks;
}

-(BOOL) isSameMonth:(NSDate*)date {
	return [self month] == [date month];
}

@end




@interface NSDate (WeekdayPrivate)
-(NSString*) weekdayNameBy:(SEL)sel ;
+(NSArray*) weekdayNamesBy:(SEL)sel ;
@end
@implementation NSDate (WeekdayPrivate)
-(NSString*) weekdayNameBy:(SEL)sel {
	int idx = [self weekday] - WEEKDAY_SUNDAY;
	return [[NSDate weekdayNamesBy:sel] objectAtIndex:idx];
}

+(NSArray*) weekdayNamesBy:(SEL)sel {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];	
	NSArray* names = [dateFormatter performSelector:sel];
	[dateFormatter release];
	return names;
}
@end



@implementation NSDate (Weekday)

-(NSString*) weekdayName {
	return [self weekdayNameBy:@selector(weekdaySymbols)];
}

+(NSArray*) weekdayNames {
	return [NSDate weekdayNamesBy:@selector(weekdaySymbols)];
}

-(NSString*) shortWeekdayName {
	return [self weekdayNameBy:@selector(shortWeekdaySymbols)];
}

+(NSArray*) shortWeekdayNames {
	return [NSDate weekdayNamesBy:@selector(shortWeekdaySymbols)];
}

-(NSString*) shortWeekdayHanjaName {
	int idx = [self weekday] - WEEKDAY_SUNDAY;
	return [[NSDate shortWeekdayHanjaNames] objectAtIndex:idx];
}

+(NSArray*) shortWeekdayHanjaNames {
	NSArray* shortWeekdayNames = [self shortWeekdayNames];
	if (IS_LOCALE_KOREAN) {
		NSDictionary* dict = [NSDictionary dictionaryWithKeysAndObjects:
							  @"일", @"日", // 1
							  @"월", @"月", // 2
							  @"화", @"火",
							  @"수", @"水",
							  @"목", @"木",
							  @"금", @"金",
							  @"토", @"土",
							  nil];
		NSMutableArray* ary = [NSMutableArray array];
		for (NSString* shortWeekdayName in shortWeekdayNames) {
			NSString* hanja = [dict objectForKey:shortWeekdayName];
			if (nil == hanja) {
				[ary addObject:shortWeekdayName];
			} else {
				[ary addObject:hanja];
			}
		}
		return ary;
	} else {
		return shortWeekdayNames;
	}
}

+(int) sundayWeekdayIndex {
	switch (FIRST_WEEKDAY_OF_CALENDAR) {
		case WEEKDAY_SUNDAY:
			return 1;
		case WEEKDAY_MONDAY:
			return 7;
		default:
			break;
	}
	return 0;
}

-(BOOL) isSunday {
	return [self weekday] == WEEKDAY_SUNDAY;
}

@end



@implementation NSDate (Day)

-(BOOL) isSameDay:(NSDate*)date {
	return (self.year == date.year && self.month == date.month && self.day == date.day);
}

-(BOOL) isToday {
	return [self isSameDay:[NSDate date]];
}

-(BOOL) isFuture {
	return NSOrderedDescending == [self compare:[NSDate date]];
}

-(BOOL) isPast {
	return ! [self isFuture];
}

@end



@implementation NSDate (AMPM)
+(int) ampm:(int)amPm hour12_to_hour24:(int)hour12 {
	switch (amPm) {
		case HOUR_PM:
			return hour12 + DOCE;
			break;
		default:
			break;
	}
	return hour12;
}
+(AMPMHour12) hour24_to_ampm_hour12:(int)hour24 {
	AMPMHour12 amPmHour12;
	if (hour24 >= DOCE) {
		amPmHour12.ampm = HOUR_PM;
		amPmHour12.hour12 = hour24 - DOCE;
	} else {
		amPmHour12.ampm = HOUR_AM;
		amPmHour12.hour12 = hour24;
	}
	return amPmHour12;
}
@end