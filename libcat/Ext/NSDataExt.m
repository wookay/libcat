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



@implementation NSData (Ext)

-(NSData*) slice:(int)loc :(int)length_ {
	NSRange range;
	if (self.length > loc + length_) {
		range = NSMakeRange(loc, length_);
	} else {
		range = NSMakeRange(loc, self.length - loc);
	}
	return [self subdataWithRange:range];
}

-(NSData*) slice:(int)loc backward:(int)backward {
	return [self slice:loc :self.length + backward + 1];
}

-(NSData*) append:(NSData*)data {
	NSMutableData* da = [NSMutableData dataWithData:self];
	[da appendData:data];
	return da;
}

-(char) onebyte_to_char {
	char byte = 0;
	if (1 == self.length) {
		[self getBytes:&byte length:1];
	} else {
		log_info(@"byte_to_int length != 1");
	}
	return byte;
}

-(int) onebyte_to_int {
	int byte = 0;
	if (1 == self.length) {
		[self getBytes:&byte length:1];
	} else {
		log_info(@"byte_to_int length != 1");
	}
	return byte;
}

static const char *const digits = "0123456789ABCDEF";
-(NSString*) to_hex {
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



@implementation NSData (UTF8EncodingExt)

NSData* unichar_to_data(unichar ch) {
	return [NSData dataWithBytes:&ch length:2];
}

-(NSData*) swap {
	NSData* uno = [self subdataWithRange:NSMakeRange(0, 1)];
	NSData* dos = [self subdataWithRange:NSMakeRange(1, 1)];
	return [dos append:uno];
}

-(unichar) to_unichar {
	unichar uch;
	[self getBytes:&uch length:2];
	return uch;
}

-(NSString*) to_utf8_string  {
	NSString* str = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
	NSString* ret = [NSString stringWithFormat:@"%@", str];
	[str release];	
	return ret;
}

@end

