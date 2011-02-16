//
//  NSObjectExt.m
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSObjectExt.h"
#import "objc/runtime.h"
#import "objc/message.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Logger.h"

@implementation NSObject (Ext)

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti {
	[self performSelector:selector withObject:nil afterDelay:ti];
}

-(BOOL) isNull {
	return [self isKindOfClass:[NSNull class]];
}

-(BOOL) isNotNull {
	return ! [self isKindOfClass:[NSNull class]];
}

-(NSArray*) class_hierarchy {
	Class nsobject = [NSObject class];
	Class klass = [self class];
	NSMutableArray* ary = [NSMutableArray arrayWithObject:klass];
	Class sup = [self superclass];
	if (klass == sup || nil == sup) {
		return ary;
	}
	while (true) {
		[ary addObject:sup];
		if (sup == nsobject) {
			break;
		}		
		sup = [sup superclass];
	}
	return ary;	
}

-(NSArray*) superclasses {
	return [[self class_hierarchy] slice:1 backward:-1];
}

-(NSArray*) class_properties:(Class)targetClass {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList((Class)targetClass, &count);
    for(unsigned int idx = 0; idx < count; idx++ ) {
        objc_property_t property = properties[idx];
		const char* name = property_getName(property);
		NSString* propertyName = SWF(@"%s", name);
		SEL sel = NSSelectorFromString(propertyName);
		if ([self respondsToSelector:sel]) {
			const char* attr = property_getAttributes(property);
			const char *aTypeDescription = (const char*)&attr[1];
			NSString* attributesString = SWF(@"%s", aTypeDescription);
			NSArray* attributes = [attributesString split:COMMA];
			if ([attributesString hasPrefix:OPENING_BRACE]) { // struct
				NSMethodSignature* sig = [self methodSignatureForSelector:sel];
				NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
				[invocation setSelector:sel];
				[invocation setTarget:self];
				[invocation invoke];				
				id obj = nil;
				if ([attributesString hasPrefix:@"{CGRect"]) {
					CGRect rect;
					[invocation getReturnValue:&rect];
					obj = NSStringFromCGRect(rect);	
				} else if ([attributesString hasPrefix:@"{CGAffineTransform"]) {
					CGAffineTransform t;
					[invocation getReturnValue:&t];
					obj = NSStringFromCGAffineTransform(t);					
				} else if ([attributesString hasPrefix:@"{CATransform3D"]) {
//					CATransform3D t;
//					[invocation getReturnValue:&t];
//					obj = [NSValue valueWithCATransform3D:t];										
				} else if ([attributesString hasPrefix:@"{CGSize"]) {
					CGSize size;
					[invocation getReturnValue:&size];
					obj = NSStringFromCGSize(size);					
				} else if ([attributesString hasPrefix:@"{CGPoint"]) {
					CGPoint point;
					[invocation getReturnValue:&point];
					obj = NSStringFromCGPoint(point);										
				} else {
					log_info(@"propertyName %@ attributesString %@", propertyName, attributesString);
				}
				if (nil != obj) {
					[ary addObject:TRIO(propertyName, obj, attributes)];
				}
			} else {
				id value = [self performSelector:sel];
				id obj = [NSObject objectWithValue:&value withObjCType:aTypeDescription];
				[ary addObject:TRIO(propertyName, obj, attributes)];								
			}
		}
    }
    free(properties);
	return [ary sortByFirstObject];	
}

-(NSArray*) class_properties {
	Class targetClass = [self class];
	return [self class_properties:targetClass];
}

-(NSArray*) methods {
	Class targetClass = [self class];
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int methodCount;
	Method *methods = class_copyMethodList((Class)targetClass, &methodCount);
	for (size_t idx = 0; idx < methodCount; ++idx) {
		Method method = methods[idx];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		[ary addObject:selectorName];
	}
	free(methods);
	return [ary sort];
}

-(NSArray*) class_methods {
	Class targetClass = [self class]->isa;
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int methodCount;
	Method *methods = class_copyMethodList((Class)targetClass, &methodCount);
	for (size_t idx = 0; idx < methodCount; ++idx) {
		Method method = methods[idx];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		[ary addObject:selectorName];
	}
	return [ary sort];
}

-(NSString*) downcasedClassName {
	return [SWF(@"%@", [self class]) lowercaseString];
}

//+(id) objectByAddress:(const void *)aValue withObjCType:(const char *)aTypeDescription {
//	if (_C_PTR == *aTypeDescription && nil == aValue) {
//		return nil; // nil should stay nil, even if it's technically a (void *)
//	}
//	
//	switch (*aTypeDescription) {
//		case _C_CHR: // BOOL, char
//			if (1 == (size_t)aValue) {
//				return [NSNumber numberWithBool:TRUE];
//			} else if (NULL == aValue) {
//				return [NSNumber numberWithBool:FALSE];
//			} else {
//				return [NSNumber numberWithChar:(size_t)aValue];
//			}
//		case _C_UCHR: return [NSNumber numberWithUnsignedChar:(size_t)aValue];
//		case _C_SHT: return [NSNumber numberWithShort:(size_t)aValue];
//		case _C_USHT: return [NSNumber numberWithUnsignedShort:(size_t)aValue];
//		case _C_INT: 
//			return [NSNumber numberWithInt:(size_t)aValue];
//		case _C_UINT: return [NSNumber numberWithUnsignedInt:(size_t)aValue];
//		case _C_LNG: return [NSNumber numberWithLong:(size_t)aValue];
//		case _C_ULNG: return [NSNumber numberWithUnsignedLong:(size_t)aValue];
//		case _C_LNG_LNG: return [NSNumber numberWithLongLong:(size_t)aValue];
//		case _C_ULNG_LNG: return [NSNumber numberWithUnsignedLongLong:(size_t)aValue];
//		case _C_FLT:
//			return [NSNumber numberWithFloat:(size_t)aValue];
//		case _C_DBL: return [NSNumber numberWithDouble:(size_t)aValue];
//		case _C_ID:
//			if (nil == aValue) {
//				return [NSNull null];
//			} else {
//				return (id)aValue;
//			}
//		case _C_PTR: // pointer, no string stuff supported right now
//		case _C_STRUCT_B: // struct, only simple ones containing only basic types right now
//		case _C_ARY_B: // array, of whatever, just gets the address
//			if (nil == aValue) {
//				return [NSNull null];
//			} else {
//				return [NSValue valueWithBytes:aValue objCType:aTypeDescription];
//			}
//	}
//	
//	if (nil == aValue) {
//		return [NSNull null];
//	} else {
//		return [NSValue value:aValue withObjCType:aTypeDescription];
//	}
//}

+(id) objectWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription {
	if (_C_PTR == *aTypeDescription && nil == *(id *)aValue) {
		return nil; // nil should stay nil, even if it's technically a (void *)
	}
	
	switch (*aTypeDescription) {
		case _C_CHR: // BOOL, char
			if (1 == (size_t)aValue) {
				return [NSNumber numberWithBool:TRUE];
			} else if (NULL == aValue) {
				return [NSNumber numberWithBool:FALSE];
			} else {
				return [NSNumber numberWithChar:*(char *)aValue];
			}
		case _C_UCHR: return [NSNumber numberWithUnsignedChar:*(unsigned char *)aValue];
		case _C_SHT: return [NSNumber numberWithShort:*(short *)aValue];
		case _C_USHT: return [NSNumber numberWithUnsignedShort:*(unsigned short *)aValue];
		case _C_INT: 
			return [NSNumber numberWithInt:*(int *)aValue];
		case _C_UINT: return [NSNumber numberWithUnsignedInt:*(unsigned *)aValue];
		case _C_LNG: return [NSNumber numberWithLong:*(long *)aValue];
		case _C_ULNG: return [NSNumber numberWithUnsignedLong:*(unsigned long *)aValue];
		case _C_LNG_LNG: return [NSNumber numberWithLongLong:*(long long *)aValue];
		case _C_ULNG_LNG: return [NSNumber numberWithUnsignedLongLong:*(unsigned long long *)aValue];
		case _C_FLT:
			return [NSNumber numberWithFloat:*(float *)aValue];
		case _C_DBL: return [NSNumber numberWithDouble:*(double *)aValue];
		case _C_ID:
			if (nil == aValue) {
				return [NSNull null];
			} else {
				return *(id *)aValue;
			}
		case _C_PTR: // pointer, no string stuff supported right now
		case _C_STRUCT_B: // struct, only simple ones containing only basic types right now
		case _C_ARY_B: // array, of whatever, just gets the address
			if (NULL == aValue) {
				return [NSNull null];
			} else {
				return [NSValue valueWithBytes:aValue objCType:aTypeDescription];
			}
	}
	return [NSValue valueWithBytes:aValue objCType:aTypeDescription];	
}

@end