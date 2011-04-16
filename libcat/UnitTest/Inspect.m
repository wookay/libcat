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
#import <objc/runtime.h>
#import "NSObjectExt.h"
#import "NSNumberExt.h"
#import "NSDateExt.h"
#import <QuartzCore/QuartzCore.h>
#import "GeometryExt.h"
#import "NSArrayExt.h"

@implementation NSObject (ObjectInspect)
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
-(NSString*) stringForFont:(UIFont*)font ;
-(NSString*) stringForArray:(NSArray*)myAry ;
@end


@implementation NSFormatterToInspect
-(NSString*) stringForFont:(UIFont*)font {
	return SWF(@"<%@: %p; %@ %g>", [font class], font, font.fontName, font.pointSize);
}
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
	} else if ([anObject isKindOfClass:[UIFont class]]) {
		return [self stringForFont:anObject];
	} else if ([anObject isKindOfClass:[UIColor class]]) {
		return NSStringFromCGColor([anObject CGColor]);
	} else if ([anObject isKindOfClass:[CALayer class]]) {
		if ([anObject isKindOfClass:[CALayer class]]) {
			CALayer* layer = anObject;
			id layerDelegate = layer.delegate;
			return SWF(@"<%@: %p; delegate = <%@: %p>; frame = %@>", [layer class], layer, [layerDelegate class], layerDelegate, NSStringFromCGRect(layer.frame));
		} else {
			return SWF(@"%@", anObject);
		}
	} else if ([anObject isKindOfClass:[DisquotatedObject class]]) {
		DisquotatedObject* disq = (DisquotatedObject*) anObject;
		if ([disq.descript isKindOfClass:[NSArray class]]) {
			NSArray* ary = disq.descript;
			return [ary join:LF];
		} else if ([disq.descript isKindOfClass:[NSString class]]) {
			return SWF(@"%@", disq.descript);
		}
	} else if ([anObject isKindOfClass:[NSValue class]]) {
		const char* aTypeDescription = [(NSValue*)anObject objCType];
		switch (*aTypeDescription) {
			case _C_SEL: {
					SEL value = [anObject pointerValue];
					if (nil == value) {
						return STR_NIL;
					} else {
						return NSStringFromSelector(value);
					}
				}
				break;

			case _C_CLASS:
				return SWF(@"%@", [anObject pointerValue]);
				break;
			
			case _C_PTR: {
					NSString* structName = SWF(@"%s", aTypeDescription);
					if ([structName hasPrefix:@"^{CGColor"]) {
						return NSStringFromCGColor([anObject pointerValue]);
					}
				}
				break;
				
			case _C_STRUCT_B:
			case _C_STRUCT_E: {
					NSString* structName = SWF(@"%s", aTypeDescription);
					if ([structName hasPrefix:@"{CGRect"]) {
						return NSStringFromCGRect([anObject CGRectValue]);
					} else if ([structName hasPrefix:@"{CGSize"]) {
						return NSStringFromCGSize([anObject CGSizeValue]);
					} else if ([structName hasPrefix:@"{CGPoint"]) {
						return NSStringFromCGPoint([anObject CGPointValue]);
					} else if ([structName hasPrefix:@"{CGAffineTransform"]) {
						return NSStringFromCGAffineTransform([anObject CGAffineTransformValue]);						
					} else if ([structName hasPrefix:@"{UIEdgeInsets"]) {
						return NSStringFromUIEdgeInsets([anObject UIEdgeInsetsValue]);
					} else if ([structName hasPrefix:@"{CATransform3D"]) {
						return NSStringFromCATransform3D([anObject CATransform3DValue]);
					}
				}
				break;
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



NSString* NSStringFromCGColor(CGColorRef colorRef) {
	const CGFloat* components = CGColorGetComponents(colorRef);
	float red, green, blue;
	if (2 == CGColorGetNumberOfComponents(colorRef)) {
		red = components[0];
		green = components[0];
		blue = components[0];
	} else {
		red = components[0];
		green = components[1];
		blue = components[2];		
	}
	float alpha = CGColorGetAlpha(colorRef);
	return SWF(@"[%g %g %g %g]", red, green, blue, alpha);
}



NSString* objectInspect(id obj) {
	if (nil == obj) {
		return STR_NIL;
	} else if ([obj isKindOfClass:[NSObject class]]) {
		return [obj inspect];
	} else {
		return EMPTY_STRING;
	}
}