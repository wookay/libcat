//
//  NSDataExt.m
//  HangulPlayer
//
//  Created by Woo-Kyoung Noh on 19/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDataExt.h"
#import "NSStringExt.h"
#import "Logger.h"

NSData* unichar_to_data(unichar ch) {
	return [NSData dataWithBytes:&ch length:2];
}

@implementation NSData (Ext)

-(unichar) to_unichar {
	unichar uch;
	[self getBytes:&uch length:2];
	return uch;
}

-(NSData*) swap {
	NSData* uno = [self subdataWithRange:NSMakeRange(0, 1)];
	NSData* dos = [self subdataWithRange:NSMakeRange(1, 1)];
	return [dos append:uno];
}

-(NSData*) append:(NSData*)data {
	NSMutableData* da = [NSMutableData dataWithData:self];
	[da appendData:data];
	return da;
}

-(NSString*) ucs2_to_utf8_string {
//	NSUTF16LittleEndianStringEncoding
//	NSUTF16StringEncoding
	NSRange range;
	unichar emptyJong = 0x115f; // swaped
	NSData* emptyJongData = [NSData dataWithBytes:&emptyJong length:2];
	NSData* jongData = [self subdataWithRange:NSMakeRange(4, 2)];
	if ([emptyJongData isEqualToData:jongData]) {
		range = NSMakeRange(0, 4);
	} else {
		range = NSMakeRange(0, 6);
	}
	NSString* str = [[NSString alloc] initWithData:[self subdataWithRange:range] encoding:NSUTF16LittleEndianStringEncoding];
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	[str release];
	return [data to_utf8_string];
}

-(NSString*) to_utf8_string  {
	NSString* str = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
	NSString* ret = [NSString stringWithFormat:@"%@", str];
	[str release];	
	return ret;
}



static const char *const digits = "0123456789ABCDEF";
- (NSString*) to_hex
{
    NSString *result = @"";
    size_t length = [self length];
    if (0 != length) {
        NSMutableData *temp = [NSMutableData dataWithLength:(length << 1)];
        if (temp) {
            const unsigned char *src = [self bytes];
            unsigned char *dst = [temp mutableBytes];
            if (src && dst) {
                while (length-- > 0) {
                    *dst++ = digits[(*src >> 4) & 0x0f];
                    *dst++ = digits[(*src++ & 0x0f)];
                }
                NSString* str = [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
                result = [NSString stringWithFormat:@"%@", str];
                [str release];
            }
        }
    }
    NSMutableArray* ary = [NSMutableArray array];
    int idx;
    for (idx = 0; idx< result.length; idx+=2) {
        NSString* str = SWF(@"0x%@", [result substringWithRange:NSMakeRange(idx, 2)]);
        [ary addObject:str];
    }
    return SWF(@"[%@]", [ary componentsJoinedByString:@", "]);
}

@end
