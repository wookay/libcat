//
//  Logger.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOGGERMAN	[LoggerManager sharedManager]

#define PRINT_HERE log_info(@"%@", NSStringFromSelector(_cmd));
#define log_object(obj)	log_info(@"%@ %@", NSStringFromSelector(_cmd), obj)

#define FILENAME_PADDING 23
#define __FILENAME__ (strrchr(__FILE__,'/')+1)
#define log_info(const_chars_fmt, ...) stdout_log_info(1, __FILENAME__, __LINE__, const_chars_fmt, ##__VA_ARGS__)
#define print_log_info(const_chars_fmt, ...) stdout_log_info(0, __FILENAME__, __LINE__, const_chars_fmt, ##__VA_ARGS__)

void stdout_log_info(BOOL filename_lineno_flag, const char* filename, int lineno, id format, ...) ;

@protocol LoggerDelegate
-(void) loggerTextOut:(NSString*)text ;
-(void) addLogTextView ;
-(void) removeLogTextView ;
@end



@interface LoggerManager : NSObject {
	id<LoggerDelegate> delegate;
}
@property (nonatomic, assign)	id<LoggerDelegate> delegate;
+ (LoggerManager*) sharedManager ;
//-(void) show_ip_address ;
@end