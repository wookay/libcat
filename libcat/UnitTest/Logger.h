//
//  Logger.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FILENAME_PADDING 23

void stdout_log_info(BOOL filename_lineno_flag, const char* filename, int lineno, id format, ...) ;

#define __FILENAME__ (strrchr(__FILE__,'/')+1)
#define log_info(const_chars_fmt, ...) stdout_log_info(1, __FILENAME__, __LINE__, const_chars_fmt, ##__VA_ARGS__)
#define print_log_info(const_chars_fmt, ...) stdout_log_info(0, __FILENAME__, __LINE__, const_chars_fmt, ##__VA_ARGS__)

@protocol LoggerDelegate
-(void) loggerTextOut:(NSString*)text ;
-(void) show_ip_address ;
@end

#define LOGGERMAN	[LoggerManager sharedManager]
@interface LoggerManager : NSObject {
	id<LoggerDelegate> delegate;
}
@property (nonatomic, retain)	id<LoggerDelegate> delegate;
+ (LoggerManager*) sharedManager ;
-(void) show_ip_address ;
@end