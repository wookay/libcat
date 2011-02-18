//
//  Logger.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Logger.h"
#import "UserConstants.h"

void stdout_log_info(BOOL filename_lineno_flag, const char* filename, int lineno, id format, ...) {
#if LOGGER_OFF
	return;
#endif
	
	NSString *str;
	if ([format isKindOfClass:[NSString class]]) {
		va_list args;
		va_start (args, format);
		str = [[NSString alloc] initWithFormat:format  arguments: args];
		va_end (args);		
	} else {
		str = [[NSString alloc] initWithString:[format description]];
	}
	
	BOOL log_print = true;	
	
#ifdef LOG_FILTER_HASPREFIX
	if (nil != LOG_FILTER_HASPREFIX) {
		log_print = [str hasPrefix:LOG_FILTER_HASPREFIX];
	}
#endif
	
	if (log_print) {		
		NSString* text;
		if (filename_lineno_flag) {
			NSString* printFormat = [NSString stringWithFormat:@"%%%ds #%%03d   %%@\n", FILENAME_PADDING];
			text = [NSString stringWithFormat:printFormat, filename, lineno, str]; 
		} else {
			text = [NSString stringWithFormat:@"%@", str];
		}
		if (nil != LOGGERMAN.delegate) {
			[LOGGERMAN.delegate loggerTextOut:text];
		}
		printf("%s", [text UTF8String]);
	}
	
	[str release];
}



@implementation LoggerManager
@synthesize delegate;

//-(void) show_ip_address {
//	if (nil != delegate) {
//		[delegate show_ip_address];
//	}
//}

- (id) init {
	self = [super init];
	if (self) {
		self.delegate = nil;
	}
	return self;
}

+ (LoggerManager*) sharedManager {
	static LoggerManager* manager = nil;
	if (! manager) {		
		manager = [LoggerManager new];
	}
	return manager;
}

- (void)dealloc {
	delegate = nil;
    [super dealloc];
}

@end