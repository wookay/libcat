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
#import "Logger.h"

@interface TestDate : NSObject 
@end

@implementation TestDate

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
