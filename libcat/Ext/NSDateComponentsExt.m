//
//  NSDateComponentsExt.m
//  Cal
//
//  Created by WooKyoung Noh on 26/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "NSDateComponentsExt.h"
#import "NSStringExt.h"
#import "Logger.h"
#import "NSDateExt.h"

@implementation NSDateComponents (Ext)
+(NSArray*) daysFromYear:(int)year {
	NSMutableArray* ary = [NSMutableArray array];
	for (int monthIdx = 1; monthIdx <= MONTH_COUNT; monthIdx++) {
		NSDate* monthDate = [NSDate dateFrom:year month:monthIdx day:1];
		for (int dayIdx = 1; dayIdx <= [monthDate numberOfDaysInMonth]; dayIdx++) {
			NSDate* date = [NSDate dateFrom:year month:monthIdx day:dayIdx];
			[ary addObject:[date today_dateComponents]];
		}
	}	
	return ary;
}

+(NSDateComponents*) dateComponentsFrom:(int)year month:(int)month {
	return [self dateComponentsFrom:year month:month day:1];
}

+(NSDateComponents*) dateComponentsFrom:(int)year month:(int)month day:(int)day {
	NSDate* date = [NSDate dateFrom:year month:month day:day];
	return [[NSCalendar currentCalendar] components:UNIT_FLAGS_YMDWW fromDate:date];
}

-(int) weekdayIndexForCalendar:(NSCalendar*)calendar {
	int weekday = [self weekday];
	int firstWeekday = [calendar firstWeekday];
	if (WEEKDAY_MONDAY == firstWeekday && WEEKDAY_SUNDAY == weekday) {
		return 6; // WEEKDAY_COUNT - 1
	} else {
		return weekday - firstWeekday;
	}
}

+(int) sundayIndexForCalendar:(NSCalendar*)calendar {
	return (WEEKDAY_COUNT - [calendar firstWeekday] + 1) % WEEKDAY_COUNT;
}


-(NSDate*) to_date {
	return [[NSCalendar currentCalendar] dateFromComponents:self];
}

-(NSString*) gmtString {
	return SWF(@"%04d-%02d-%02d %02d:%02d:%02d %d,%d", [self year], [self month], [self day], [self hour], [self minute], [self second], [self week], [self weekday]);
}
@end