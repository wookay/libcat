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



@interface NSFormatterToInspectObjC (Private)
- (NSString *)stringForArrayAndSet:(id)anObject ;
@end

@implementation NSFormatterToInspectObjC
- (NSString *)stringForArrayAndSet:(id)anObject {
	NSArray* myary;
	NSString* construtStr;
	if ([anObject isKindOfClass:[NSSet class]]) {
		myary = [anObject allObjects];
		construtStr = @"NSSet set";
	} else {
		myary = anObject;
		construtStr = @"NSArray array";
	}
	switch (myary.count) {
		case 1:
			return SWF(@"[%@WithObject:%@]", construtStr, [[myary lastObject] inspect_objc]);
			break;
		default: {
			NSMutableArray* ary = [NSMutableArray array];
			for (id obj in (NSArray*)anObject) {
				[ary addObject:SWF(@"%@", [obj inspect_objc])];
			}
			return SWF(@"[%@WithObjects:%@, nil]", construtStr, [ary componentsJoinedByString:COMMA_LF]);			
		}
			break;
	}
}

- (NSString *)stringForObjectValue:(id)anObject {
	if ([anObject isKindOfClass:[NSArray class]]) {
		return [self stringForArrayAndSet:anObject];
	} else if ([anObject isKindOfClass:[NSSet class]]) {
		return [self stringForArrayAndSet:anObject];
	} else if ([anObject isKindOfClass:[NSDictionary class]]) {
		NSMutableArray* ary = [NSMutableArray array];
		for (id key in anObject) {
			id obj = [anObject objectForKey:key];
			if ([obj isKindOfClass:[NSArray class]]) {
				[ary addObject:[NSString stringWithFormat:@"%@, %@", [key inspect_objc], [obj inspect_objc]]];				
			} else {
				[ary addObject:[NSString stringWithFormat:@"%@, %@", [key inspect_objc], [obj inspect]]];
			}
		}
		return SWF(@"[NSDictionary dictionaryWithKeysAndObjects:\n%@,\n nil]", [ary componentsJoinedByString:COMMA_LF]);
	} else if ([anObject isKindOfClass:[NSString class]]) {
		return SWF(@"%@\"%@\"", AT_SIGN, anObject);
	} else if ([anObject isKindOfClass:[NSDate class]]) {
		return [anObject gmtString];
	} else if ([anObject isKindOfClass:[NSDateComponents class]]) {
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




@interface NSFormatterToInspect (Private)
-(NSString*) stringForArray:(NSArray*)myAry ;
@end


@implementation NSFormatterToInspect
-(NSString*) stringForArray:(NSArray*)myAry {
	switch (myAry.count) {
		case 1:
			return SWF(@"[%@]", [[myAry lastObject] inspect]);
			break;
		default: {
#define OVER_LINE_LIMIT 80
			int overLine = 0;
			NSMutableArray* ary = [NSMutableArray array];
			for (id obj in myAry) {
				NSString* str = SWF(@"%@", [obj inspect]);
				[ary addObject:str];
				if (OVER_LINE_LIMIT > overLine) {
					overLine += str.length;
				}
			}
			if (OVER_LINE_LIMIT > overLine) {
				return SWF(@"[%@]", [ary componentsJoinedByString:COMMA_SPACE]);			
			} else {
				NSMutableArray* indentedArray = [NSMutableArray array];
				for (id obj in  ary) {
					[indentedArray addObject:SWF(@"  %@", obj)];
				}
				return SWF(@"[\n%@\n]", [indentedArray componentsJoinedByString:COMMA_LF]);			
			}
		}
			break;
	}
}

- (NSString *)stringForObjectValue:(id)anObject {
	if ([anObject isKindOfClass:[NSArray class]]) {
		return [self stringForArray:anObject];
	} else if ([anObject isKindOfClass:[NSSet class]]) {
		return [self stringForArray:[anObject allObjects]];
	} else if ([anObject isKindOfClass:[NSDictionary class]]) {
		NSMutableArray* ary = [NSMutableArray array];
		for (id key in anObject) {
			id obj = [anObject objectForKey:key];
			if ([obj isKindOfClass:[NSArray class]]) {
				[ary addObject:[NSString stringWithFormat:@"%@ : %@", [key inspect], [obj inspect]]];				
			} else {
				[ary addObject:[NSString stringWithFormat:@"%@ : %@", [key inspect], [obj inspect]]];
			}
		}
		return SWF(@"{%@}", [ary componentsJoinedByString:COMMA_LF]);
	} else if ([anObject isKindOfClass:[NSString class]]) {
		return SWF(@"\"%@\"", anObject);
	} else if ([anObject isKindOfClass:[NSDate class]]) {
		return [anObject gmtString];
	} else if ([anObject isKindOfClass:[NSDateComponents class]]) {
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

