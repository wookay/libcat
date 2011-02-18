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
#import "GeometryExt.h"
#import "NSArrayExt.h"
#import "Logger.h"

@implementation NSObject (Ext)

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
	return [self class_methods:targetClass];
}

-(NSArray*) class_methods:(Class)targetClass {
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

-(NSArray*) class_properties:(Class)targetClass {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList((Class)targetClass, &count);
    for(unsigned int idx = 0; idx < count; idx++ ) {
        objc_property_t property = properties[idx];
		const char* name = property_getName(property);
		NSString* propertyName = SWF(@"%s", name);
		SEL sel = NSSelectorFromString(propertyName);
		BOOL failed = false;
		id obj = [self getPropertyValue:sel failed:&failed];
		if (failed) {
		} else {
			const char* attr = property_getAttributes(property);
			const char *aTypeDescription = (const char*)&attr[1];
			NSString* attributesString = SWF(@"%s", aTypeDescription);
			NSArray* attributes = [attributesString split:COMMA];
			[ary addObject:TRIO(propertyName, obj, attributes)];								
		}
	}
	free(properties);
	return [ary sortByFirstObject];	
}

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti {
	[self performSelector:selector withObject:nil afterDelay:ti];
}

-(BOOL) isNil {
	return [self isKindOfClass:[NilClass class]];
}

-(BOOL) isNotNil {
	return ! [self isNil];
}

-(NSString*) className {
	return SWF(@"%@", [self class]);
}

-(NSString*) downcasedClassName {
	return [SWF(@"%@", [self class]) lowercaseString];
}

+(id) objectWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription {
	if (_C_PTR == *aTypeDescription && nil == *(id *)aValue) {
		return nil;
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
				return nil;
			} else {
				return *(id *)aValue;
			}
		case _C_PTR: // pointer, no string stuff supported right now
		case _C_STRUCT_B: // struct, only simple ones containing only basic types right now
		case _C_ARY_B: // array, of whatever, just gets the address
			if (NULL == aValue) {
				return nil;
			} else {
				return [NSValue valueWithBytes:aValue objCType:aTypeDescription];
			}
	}
	return [NSValue valueWithBytes:aValue objCType:aTypeDescription];	
}

-(BOOL) propertyHasObjectType:(SEL)sel {
	if (! [self respondsToSelector:sel]) {
		return false;
	}
	NSMethodSignature* sig = [self methodSignatureForSelector:sel];
	const char* aTypeDescription = [sig methodReturnType];
	switch (*aTypeDescription) {
		case _C_ID:
			return true;
			break;
	
		default:
			break;
	}		
	return false;
}

-(Class) classForProperty:(NSString*)propertyName {
	for (Class targetClass in [self class_hierarchy]) {
		unsigned int count = 0;
		objc_property_t *properties = class_copyPropertyList((Class)targetClass, &count);
		BOOL found = false;
		for(unsigned int idx = 0; idx < count; idx++ ) {
			objc_property_t property = properties[idx];
			const char* name = property_getName(property);
			NSString* targetPropertyName = SWF(@"%s", name);
			if ([targetPropertyName isEqualToString:propertyName]) {
				found = true;
				break;
			}
		}
		free(properties);
		if (found) {
			return targetClass;
		}
	}
	return NULL;
}

-(id) getPropertyValue:(SEL)sel failed:(BOOL*)failed {
	if (! [self respondsToSelector:sel]) {
		*failed = true;
		return nil;
	}
	
	id obj = nil;
	NSMethodSignature* sig = [self methodSignatureForSelector:sel];
	const char* aTypeDescription = [sig methodReturnType];
	switch (*aTypeDescription) {
		case _C_VOID:
			*failed = true;
			break;
			
		case _C_STRUCT_B:
		case _C_STRUCT_E: {
				NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
				[invocation setSelector:sel];
				[invocation setTarget:self];
				[invocation invoke];		
				NSString* attributesString = SWF(@"%s", aTypeDescription);
				if ([attributesString hasPrefix:@"{CGRect"]) {
					CGRect rect;
					[invocation getReturnValue:&rect];
					obj = NSStringFromCGRect(rect);	
				} else if ([attributesString hasPrefix:@"{CGAffineTransform"]) {
					CGAffineTransform t;
					[invocation getReturnValue:&t];
					obj = NSStringFromCGAffineTransform(t);					
				} else if ([attributesString hasPrefix:@"{CGSize"]) {
					CGSize size;
					[invocation getReturnValue:&size];
					obj = NSStringFromCGSize(size);					
				} else if ([attributesString hasPrefix:@"{CGPoint"]) {
					CGPoint point;
					[invocation getReturnValue:&point];
					obj = NSStringFromCGPoint(point);										
				} else if ([attributesString hasPrefix:@"{UIEdgeInsets"]) {					
					UIEdgeInsets edgeInsets;
					[invocation getReturnValue:&edgeInsets];
					obj = NSStringFromUIEdgeInsets(edgeInsets);															
				} else {
					// @"{CATransform3D"
					log_info(@"propertyName %@ attributesString %@", NSStringFromSelector(sel), attributesString);
				}
				if (nil == obj) {
					*failed = true;
				}
			}
			break;
			
		default: {
				id value = [self performSelector:sel];
				obj = [NSObject objectWithValue:&value withObjCType:aTypeDescription];
			}
			break;
	}
	return obj;
}

-(BOOL) setProperty:(NSString*)propertyName value:(id)value attributeString:(NSString*)attributeString {
	NSString* setter = SWF(@"set%@:", [propertyName uppercaseFirstCharacter]);
	SEL sel = NSSelectorFromString(setter);
	if ([self respondsToSelector:sel]) {
		NSMethodSignature* sig = [self methodSignatureForSelector:sel];
		const char* argType = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
		Method m = class_getInstanceMethod([self class], sel);
		IMP imp = method_getImplementation(m);
		switch (*argType) {
			case _C_ID:
				[self performSelector:sel withObject:value];
				break;
				
			case _C_CHR:
			case _C_BOOL:
				((void (*)(id, SEL, BOOL))imp)(self, sel, [value boolValue]);
				break;
				
			case _C_INT:
				((void (*)(id, SEL, int))imp)(self, sel, [value intValue]);
				break;
				
			case _C_UINT:
				((void (*)(id, SEL, unsigned int))imp)(self, sel, [value unsignedIntValue]);
				break;
				
			case _C_FLT:
				((void (*)(id, SEL, float))imp)(self, sel, [value floatValue]);
				break;
				
			case _C_STRUCT_B:
			case _C_STRUCT_E: {
					NSMethodSignature* sig = [self methodSignatureForSelector:sel];
					NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
					[invocation setSelector:sel];
					[invocation setTarget:self];
					BOOL invoke = true;
					int idx = ARGUMENT_INDEX_ONE;
					if ([attributeString hasPrefix:@"{CGRect"]) {
						CGRect rect = CGRectForString(value);
						[invocation setArgument:&rect atIndex:idx];
					} else if ([attributeString hasPrefix:@"{CGAffineTransform"]) {
						CGAffineTransform t = CGAffineTransformFromString(value);
						[invocation setArgument:&t atIndex:idx];
					} else if ([attributeString hasPrefix:@"{CATransform3D"]) {
						invoke = false;
					} else if ([attributeString hasPrefix:@"{CGSize"]) {
						CGSize size = CGSizeFromString(value);
						[invocation setArgument:&size atIndex:idx];
					} else if ([attributeString hasPrefix:@"{CGPoint"]) {
						CGPoint point = CGPointFromString(value);
						[invocation setArgument:&point atIndex:idx];
					} else {
						invoke = false;
					}
					if (invoke) {
						[invocation invoke];								
					}
				}
				break;
			
			default:
				break;
		}		
		return true;
	} else {
		return false;
	}
}

@end



@implementation NilClass
-(NSString*) description {
	return @"nil";
}
-(BOOL) isNil {
	return true;
}
+(NilClass*) nilClass {
	static NilClass* nilClass = nil;
	if (!nilClass) {
		nilClass = [NilClass new];
	}
	return nilClass;
}
@end