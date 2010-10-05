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
	return [str componentsSeparatedByString:SPACE];
}

NSString* int_to_string(int n) {
	return [NSString stringWithFormat:@"%d", n];
}

NSString* unichar_to_string(unichar ch) {
	return [NSString stringWithFormat:@"%C", ch];
}

NSInteger sortByStringComparator(NSString* uno, NSString* dos, void* context) {
	return [uno localizedCaseInsensitiveCompare:dos];
}


@implementation NSString (Ext)

-(BOOL) isEmpty {
	return 0 == self.length;	
}

-(BOOL) isNotEmpty {
	return self.length > 0;
}

-(int) to_int {
	return [self intValue];
}

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

-(NSString*) gsub:(NSString*)str to:(NSString*)to {
	return [self stringByReplacingOccurrencesOfString:str withString:to];	
}

-(unichar) to_unichar {
	return [self characterAtIndex:0];
}

-(char) to_char {
	return [self characterAtIndex:0];	
}

-(NSData*) to_data {
	return [self dataUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL) hasText:(NSString*)str {
	NSRange range = [self rangeOfString:str];
	return NSNotFound != range.location;
}

+(NSString*) stringWithCharacter:(unichar) ch {
	return [NSString stringWithFormat:@"%C", ch];
}

-(NSString*) stringAtIndex:(int)idx {
	return [self substringWithRange:NSMakeRange(idx, 1)];
}

-(NSString*) last {
	if (self.length > 0) {
		return [self stringAtIndex:self.length - 1];
	} else {
		return EMPTY_STRING;
	}
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

-(NSString*) repeat:(int)times {
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 0; idx < times; idx++) {
		[ary addObject:self];
	}
	return [ary componentsJoinedByString:EMPTY_STRING];
}

-(NSArray*) each_chars {
	return [self split:EMPTY_STRING];
}

- (NSString*) reverse {
	return [[[self split:EMPTY_STRING] reverse] join:EMPTY_STRING];
}

@end