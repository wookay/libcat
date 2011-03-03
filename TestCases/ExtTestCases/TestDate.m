//
//  TestDate.m
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSLocaleExt.h"
#import "NSDateExt.h"
#import "UnitTest.h"
#import "Inspect.h"
#import "NSArrayExt.h"
#import "Logger.h"
#import "NSStringExt.h"

@interface TestDate : NSObject 
@end

@implementation TestDate

-(void) test_weekdayIndexForCalendar {
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:@"gregorian"];
	
	NSLocale* locale_es_ES = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];	
	[calendar setLocale:locale_es_ES];
	assert_equal(WEEKDAY_MONDAY, [calendar firstWeekday]);
	NSDateComponents* mar = [NSDateComponents dateComponentsFrom:2011 month:2 day:1];
	assert_equal(WEEKDAY_TUESDAY, [mar weekday]);
	assert_equal(1, [mar weekdayIndexForCalendar:calendar]);	
	NSDateComponents* mie = [NSDateComponents dateComponentsFrom:2011 month:2 day:2];
	assert_equal(WEEKDAY_WEDNESDAY, [mie weekday]);
	assert_equal(2, [mie weekdayIndexForCalendar:calendar]);
	NSDateComponents* dom = [NSDateComponents dateComponentsFrom:2011 month:2 day:6];
	assert_equal(WEEKDAY_SUNDAY, [dom weekday]);
	assert_equal(6, [dom weekdayIndexForCalendar:calendar]);
	[locale_es_ES release];
	
	NSLocale* locale_ko_KR = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];		
	[calendar setLocale:locale_ko_KR];
	assert_equal(WEEKDAY_SUNDAY, [calendar firstWeekday]);
	NSDateComponents* hwa = [NSDateComponents dateComponentsFrom:2011 month:2 day:1];
	assert_equal(WEEKDAY_TUESDAY, [hwa weekday]);
	assert_equal(2, [hwa weekdayIndexForCalendar:calendar]);
	NSDateComponents* su = [NSDateComponents dateComponentsFrom:2011 month:2 day:2];
	assert_equal(WEEKDAY_WEDNESDAY, [su weekday]);
	assert_equal(3, [su weekdayIndexForCalendar:calendar]);
	NSDateComponents* il = [NSDateComponents dateComponentsFrom:2011 month:2 day:6];
	assert_equal(WEEKDAY_SUNDAY, [il weekday]);
	assert_equal(0, [il weekdayIndexForCalendar:calendar]);	
	[locale_ko_KR release];
	
	[calendar release];
}

-(void) test_date {
	NSDate* date = [NSDate dateFrom:2010 month:8 day:15 hour:13 minute:26 second:57];
	assert_equal(date.day, [date endOfDate].day);
	assert_false([date isFuture]);
}

-(void) test_date_formmat_string {
	NSDate* date = [NSDate dateFrom:2010 month:8 day:15 hour:13 minute:26 second:57];
	assert_equal(@"2010-08-15", [date year_month_day_MINUS]);
	assert_equal(@"2010. 8. 15.", [date year_month_day_DOT_SPACE]);
	assert_equal(@"2010-08-15 13:26", [date year_month_day_MINUS_hour_minute_COLON]);
	assert_equal(@"2010-08-15 13:26:57", [date year_month_day_MINUS_hour_minute_second_COLON]);
	if (IS_LOCALE_KOREAN) {
		assert_equal(@"2010-08-15 오후 01:26", [date year_month_day_MINUS_AMPM_hour_minute_COLON]);
		assert_equal(@"2010년 8월", [date year_monthName_SPACE]);
		assert_equal(@"2010년 8월 15일", [date year_monthName_day_SPACE]);
		assert_equal(@"8.15", [date month_day_DOT]);
		assert_equal(@"8월", [date monthName]);
		assert_equal(@"8월 15일", [date monthName_day_SPACE]);
		assert_equal(@"8월 15일 일요일", [date monthName_day_weekday_SPACE]);
		assert_equal(@"오후 1시 26분", [date amPM_hourName_minute_SPACE]);
		assert_equal(@"오후 1시", [date amPM_hourName_SPACE]);
		assert_equal(@"13시", [date hourName_SPACE]);
		assert_equal(@"13시 26분", [date hourName_minute_SPACE]);
		assert_equal(@"13시 26분 57초", [date hourName_minute_second_SPACE]);
		assert_equal(@"13:26", [date hour_minute_COLON]);
		assert_equal(@"13:26:57", [date hour_minute_second_COLON]);	
	}
}

-(void) test_date_formatter_symbols {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];

	NSLocale* ko_KR = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
	[formatter setLocale:ko_KR];
	[ko_KR release];
	assert_equal(_w(@"기원전 서기"), [formatter eraSymbols]);
	assert_equal(_w(@"1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월"), [formatter monthSymbols]);
	assert_equal(_w(@"1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월"), [formatter shortMonthSymbols]);
	assert_equal(_w(@"일요일 월요일 화요일 수요일 목요일 금요일 토요일"), [formatter weekdaySymbols]);
	assert_equal(_w(@"일 월 화 수 목 금 토"), [formatter shortWeekdaySymbols]);
	assert_equal(_w(@"1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월"), [formatter veryShortMonthSymbols]);
	assert_equal(_w(@"1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월"), [formatter standaloneMonthSymbols]);
	assert_equal(_w(@"1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월"), [formatter shortStandaloneMonthSymbols]);
	assert_equal(_w(@"1월 2월 3월 4월 5월 6월 7월 8월 9월 10월 11월 12월"), [formatter veryShortStandaloneMonthSymbols]);
	assert_equal(_w(@"일 월 화 수 목 금 토"), [formatter veryShortWeekdaySymbols]);
	assert_equal(_w(@"일요일 월요일 화요일 수요일 목요일 금요일 토요일"), [formatter standaloneWeekdaySymbols]);
	assert_equal(_w(@"일 월 화 수 목 금 토"), [formatter shortStandaloneWeekdaySymbols]);
	assert_equal(_w(@"일 월 화 수 목 금 토"), [formatter veryShortStandaloneWeekdaySymbols]);
	assert_equal([@"제 1/4분기, 제 2/4분기, 제 3/4분기, 제 4/4분기" split:COMMA_SPACE], [formatter quarterSymbols]);
	assert_equal(_w(@"1분기 2분기 3분기 4분기"), [formatter shortQuarterSymbols]);
	assert_equal([@"제 1/4분기, 제 2/4분기, 제 3/4분기, 제 4/4분기" split:COMMA_SPACE], [formatter standaloneQuarterSymbols]);
	
	NSLocale* en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:en_US];
	[en_US release];
	assert_equal(_w(@"BC AD"), [formatter eraSymbols]);
	assert_equal(_w(@"January February March April May June July August September October November December"), [formatter monthSymbols]);
	assert_equal(_w(@"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"), [formatter shortMonthSymbols]);
	assert_equal(_w(@"Sunday Monday Tuesday Wednesday Thursday Friday Saturday"), [formatter weekdaySymbols]);
	assert_equal(_w(@"Sun Mon Tue Wed Thu Fri Sat"), [formatter shortWeekdaySymbols]);
	assert_equal(_w(@"J F M A M J J A S O N D"), [formatter veryShortMonthSymbols]);
	assert_equal(_w(@"January February March April May June July August September October November December"), [formatter standaloneMonthSymbols]);
	assert_equal(_w(@"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"), [formatter shortStandaloneMonthSymbols]);
	assert_equal(_w(@"J F M A M J J A S O N D"), [formatter veryShortStandaloneMonthSymbols]);
	assert_equal(_w(@"S M T W T F S"), [formatter veryShortWeekdaySymbols]);
	assert_equal(_w(@"Sunday Monday Tuesday Wednesday Thursday Friday Saturday"), [formatter standaloneWeekdaySymbols]);
	assert_equal(_w(@"Sun Mon Tue Wed Thu Fri Sat"), [formatter shortStandaloneWeekdaySymbols]);
	assert_equal(_w(@"S M T W T F S"), [formatter veryShortStandaloneWeekdaySymbols]);
	assert_equal([@"1st quarter, 2nd quarter, 3rd quarter, 4th quarter" split:COMMA_SPACE], [formatter quarterSymbols]);
	assert_equal(_w(@"Q1 Q2 Q3 Q4"), [formatter shortQuarterSymbols]);
	assert_equal([@"1st quarter, 2nd quarter, 3rd quarter, 4th quarter" split:COMMA_SPACE], [formatter standaloneQuarterSymbols]);

	[formatter release];
}

-(void) test_DDay {
	NSDate* christmasEve = [NSDate dateFrom:2010 month:12 day:24];
	NSDate* christmas = [NSDate dateFrom:2010 month:12 day:25];
	assert_equal(1, [christmasEve countDownOfTheDay:christmas]);
}

-(void) test_AM_PM {
	if (IS_LOCALE_KOREAN) {
		
		NSDate* date;
		
		int hour24 = [NSDate ampm:HOUR_AM hour12_to_hour24:0];
		assert_equal(0, hour24);
		
		AMPMHour12 ampmHour12 = [NSDate hour24_to_ampm_hour12:12];
		assert_equal(ampmHour12.ampm, HOUR_PM);
		assert_equal(ampmHour12.hour12, 0);
		
		
		date = [NSDate dateFrom:2010 month:10 day:7 hour:0];
		assert_equal(@"오전 12시", [date amPM_hourName_SPACE]);

		date = [NSDate dateFrom:2010 month:10 day:7 hour:1];
		assert_equal(@"오전 1시", [date amPM_hourName_SPACE]);

		date = [NSDate dateFrom:2010 month:10 day:7 hour:11];
		assert_equal(@"오전 11시", [date amPM_hourName_SPACE]);

		date = [NSDate dateFrom:2010 month:10 day:7 hour:12];
		assert_equal(@"오후 12시", [date amPM_hourName_SPACE]);

		date = [NSDate dateFrom:2010 month:10 day:7 hour:23];
		assert_equal(@"오후 11시", [date amPM_hourName_SPACE]);

	}
}

@end
