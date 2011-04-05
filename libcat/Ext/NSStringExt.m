//
//  NSStringExt.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 05/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSStringExt.h"
#import "NSNumberExt.h"
#import "Logger.h"
#import "NSArrayExt.h"

NSString* SWF(NSString* format, ...) {
	va_list args;
	va_start(args, format);
	NSString* alloc_str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);
	NSString* ret = [NSString stringWithFormat:@"%@", alloc_str];
	[alloc_str release];
	return ret;
}

NSArray* _w(NSString* str) {
	return [[str strip] componentsSeparatedByString:SPACE];
}

NSString* char_to_string(char ch) {
	return [NSString stringWithFormat:@"%c", ch];
}

NSString* int_to_string(int n) {
	return [NSString stringWithFormat:@"%d", n];
}

NSString* double_to_string(double n) {
	return [NSString stringWithFormat:@"%f", n];
}

NSString* unichar_to_string(unichar ch) {
	return [NSString stringWithFormat:@"%C", ch];
}

NSString* nil_to_empty_string(NSString* str) {
	return (nil == str) ? EMPTY_STRING : str;
}

NSInteger sortByStringComparator(NSString* uno, NSString* dos, void* context) {
	return [uno localizedCaseInsensitiveCompare:dos];
}

char unichar_high(unichar uch) {
	return uch >> 8;
}

unsigned short unichar_low(unichar uch) {
	return uch & 0xFF;
}

@implementation NSString (Ext)

// BOOL
-(BOOL) isEmpty {
	return 0 == self.length;	
}

-(BOOL) isNotEmpty {
	return self.length > 0;
}

-(BOOL) isIntegerNumber {	
	NSScanner* scanner = [NSScanner scannerWithString:self];
	if ([scanner scanInt:NULL]) {
		return [scanner isAtEnd];
	} else {
		return NO;
	}
}

-(BOOL) isIntegerNumberWithSpace {
	return [[self gsub:SPACE to:EMPTY_STRING] isIntegerNumber];
}

-(BOOL) isAlphabet {
	NSScanner* scanner = [NSScanner scannerWithString:self];
	NSString* str = nil;
	if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&str]) {
		return [scanner isAtEnd];
	} else {
		return NO;
	}
}

-(BOOL) hasSurrounded:(NSString*)a :(NSString*)b {
	return [self hasPrefix:a] && [self hasSuffix:b];
}

-(BOOL) hasText:(NSString*)str {
	NSRange range = [self rangeOfString:str];
	return NSNotFound != range.location;
}

// int
-(char) to_char {
	return [self characterAtIndex:0];	
}

-(int) to_int {
	return [self intValue];
}

-(unichar) to_unichar {
	return [self characterAtIndex:0];
}

-(size_t) to_size_t {
	double result = 0;
	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner scanHexDouble:&result];
	return result;
}


// NSString*
-(NSString*) slice:(int)loc :(int)length_ {
	NSRange range;
	if (self.length > loc + length_) {
		range = NSMakeRange(loc, length_);
	} else {
		range = NSMakeRange(loc, self.length - loc);
	}
	return [self substringWithRange:range];
}

-(NSString*) slice:(int)loc backward:(int)backward {
	return [self slice:loc :self.length + backward + 1];
}

-(NSString*) strip {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*) uppercaseFirstCharacter {
	if (self.length > 0) {
		return SWF(@"%@%@", [[self slice:0 :1] uppercaseString], [self slice:1 backward:-1]);
	} else {
		return self;
	}
}

-(NSString*) gsub:(NSString*)str to:(NSString*)to {
	return [self stringByReplacingOccurrencesOfString:str withString:to];	
}

-(NSString*) stringAtIndex:(int)idx {
	return [self substringWithRange:NSMakeRange(idx, 1)];
}

-(unichar) unicharAtIndex:(int)idx {
	return [[self stringAtIndex:idx] to_unichar];
}

-(NSString*) last {
	if (self.length > 0) {
		return [self stringAtIndex:self.length - 1];
	} else {
		return EMPTY_STRING;
	}
}

-(NSString*) repeat:(int)times {
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 0; idx < times; idx++) {
		[ary addObject:self];
	}
	return [ary componentsJoinedByString:EMPTY_STRING];
}

- (NSString*) reverse {
	return [[[self split:EMPTY_STRING] reverse] join:EMPTY_STRING];
}

-(NSString*) truncate:(int)lengthToCut {
#define STR_DOTS @"..."
	int lengthDots = [STR_DOTS length];
	if (lengthToCut < lengthDots) {
		return self;
	}
	if (self.length > lengthToCut) {
		return SWF(@"%@%@", [self substringToIndex:lengthToCut - lengthDots], STR_DOTS);
	} else {
		return self;
	}
}

-(NSString*) ljust:(int)justified {
	if (self.length < justified) {
		NSString* padStr = SPACE;
		return SWF(@"%@%@", self, [padStr repeat:justified - self.length]);
	} else {
		return self;
	}
}

+(NSString*) stringWithCharacter:(unichar) ch {
	return [NSString stringWithFormat:@"%C", ch];
}

+(NSString*) stringFormat:(NSString*)formatString withArray:(NSArray*)arguments {
	char *argList = (char *)malloc(sizeof(NSString *) * [arguments count]);
    [arguments getObjects:(id *)argList];
    NSString* contents = [[NSString alloc] initWithFormat:formatString arguments:argList];
    free(argList);
	NSString* ret = SWF(@"%@", contents);
	[contents release];
	return ret;
}

// NSArray*
-(NSArray*) each_chars {
	return [self split:EMPTY_STRING];
}


- (NSArray*) split {
	return [self split:SPACE];
}

- (NSArray*) split:(id)sep {
	if ([EMPTY_STRING isEqualToString:self]) {
		return [NSArray array];
	} 
	if ([EMPTY_STRING isEqualToString:sep]) {
		NSMutableArray* ary = [NSMutableArray array];
		int idx;
		for (idx=0;idx<self.length; idx++) {
			NSRange range = NSMakeRange(idx, 1);
			NSString* ch = [self substringWithRange:range];
			[ary addObject:ch];
		}
		return ary;
	} else {
		NSArray* ret = [NSArray arrayWithArray:[self componentsSeparatedByString:sep]];
		return ret;
	}
}

// NSData*
-(NSData*) to_data {
	return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end


