//
//  Logger.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FILENAME_PADDING 23

void print_log_info(const char* filename, int lineno, id format, ...) ;

#define __FILENAME__ (strrchr(__FILE__,'/')+1)
#define log_info(const_chars_fmt, ...) print_log_info(__FILENAME__, __LINE__, const_chars_fmt, ##__VA_ARGS__)