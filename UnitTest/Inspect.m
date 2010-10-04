//
//  Inspect.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Inspect.h"
#import "NSStringExt.h"
#import "Logger.h"
#import "objc/runtime.h"
#import "NSNumberExt.h"
#import "NSDateExt.h"

@implementation NSObject (Inspect)
-(id) inspect {
	NSFormatterToInspect* formatter = [[NSFormatterToInspect alloc] init];
	NSString* str = [formatter stringForObjectValue:self];
	[formatter release];
	return str;
}
-(id) inspect_objc {
	NSFormatterToInspectObjC* formatter = [[NSFormatterToInspectObjC alloc] init];
	NSString* str = [formatter stringForObjectValue:self];
	[formatter release];
	return str;		
}
@end



@implementation NSFormatterToInspectObjC
- (NSString *)stringForObjectValue:(id)anObject {
	if ([anObject isKindOfClass:[NSArray class]]) {
		NSArray* myary = (NSArray*)anObject;
		switch (myary.count) {
			case 1:
				return SWF(@"[NSArray arrayWithObject:%@]", [[myary lastObject] inspect_objc]);
				break;
			default: {
					NSMutableArray* ary = [NSMutableArray array];
					for (id obj in (NSArray*)anObject) {
						[ary addObject:SWF(@"%@", [obj inspect_objc])];
					}
					return SWF(@"[NSArray arrayWithObjects:%@, nil]", [ary componentsJoinedByString:COMMA_LF]);			
				}
				break;
		}
	} else if ([anObject isKindOfClass:[NSDictionary class]]) {
		NSMutableArray* ary = [NSMutableArray array];
		for (id key in anObject) {
			id obj = [anObject objectForKey:key];
			if ([obj isKindOfClass:[NSArray class]]) {
				[ary addObject:[NSString stringWithFormat:@"%@, %@", [key inspect_objc], [obj inspect_objc]]];				
			} else {
				[ary addObject:[NSString stringWithFormat:@"%@, %@", key, [obj inspect]]];
			}
		}
		return SWF(@"[NSDictionary dictionaryWithKeysAndObjects:\n%@,\n nil]", [ary componentsJoinedByString:COMMA_LF]);
	} else if ([anObject isKindOfClass:[NSString class]]) {
		return SWF(@"%@\"%@\"", AT_SIGN, anObject);
	} else if ([anObject isKindOfClass:[NSDate class]]) {
		return [anObject gmtString];
	} else if ([anObject isKindOfClass:[NSValue class]]) {
		const char* aTypeDescription = [(NSValue*)anObject objCType];
		switch (*aTypeDescription) {
			case _C_FLT: {
				float value = [anObject doubleValue];
				if ([[anObject floor_down] doubleValue] == value) {
					return SWF(@"%.1f", value);						
				} else {
					return SWF(@"%f", value);												
				}
			}
				break;
			default:
				break;
		}
	}
	return SWF(@"%@", anObject);
}
@end






@implementation NSFormatterToInspect
- (NSString *)stringForObjectValue:(id)anObject {
	if ([anObject isKindOfClass:[NSArray class]]) {
		NSArray* myary = (NSArray*)anObject;
		switch (myary.count) {
			case 1:
				return SWF(@"[%@]", [[myary lastObject] inspect]);
				break;
			default: {
				NSMutableArray* ary = [NSMutableArray array];
				for (id obj in (NSArray*)anObject) {
					[ary addObject:SWF(@"%@", [obj inspect])];
				}
				return SWF(@"[%@]", [ary componentsJoinedByString:COMMA_SPACE]);			
			}
				break;
		}
	} else if ([anObject isKindOfClass:[NSDictionary class]]) {
		NSMutableArray* ary = [NSMutableArray array];
		for (id key in anObject) {
			id obj = [anObject objectForKey:key];
			if ([obj isKindOfClass:[NSArray class]]) {
				[ary addObject:[NSString stringWithFormat:@"%@ : %@", [key inspect], [obj inspect]]];				
			} else {
				[ary addObject:[NSString stringWithFormat:@"%@ : %@", key, [obj inspect]]];
			}
		}
		return SWF(@"{%@}", [ary componentsJoinedByString:COMMA_LF]);
	} else if ([anObject isKindOfClass:[NSString class]]) {
		return SWF(@"\"%@\"", anObject);
	} else if ([anObject isKindOfClass:[NSDate class]]) {
		return [anObject gmtString];
	} else if ([anObject isKindOfClass:[NSValue class]]) {
		const char* aTypeDescription = [(NSValue*)anObject objCType];
		switch (*aTypeDescription) {
			case _C_FLT: {
				float value = [anObject doubleValue];
				if ([[anObject floor_down] doubleValue] == value) {
					return SWF(@"%.1f", value);						
				} else {
					return SWF(@"%f", value);												
				}
			}
				break;
			default:
				break;
		}
	}
	return SWF(@"%@", anObject);
}
@end

