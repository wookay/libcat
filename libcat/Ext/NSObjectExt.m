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
#import "NSDateExt.h"
#import "Inspect.h"

NSString* TypeEncodingDescription(char* code) {
	switch (code[0]) {
		case _C_ID:
			return @"id";
		case _C_CLASS:
			return @"Class";
		case _C_SEL:
			return @"SEL";
		case _C_CHR:
			return @"char";
		case _C_UCHR:
			return @"u_char";
		case _C_SHT:
			return @"short";
		case _C_USHT:
			return @"ushort";
		case _C_INT:
			return @"int";
		case _C_UINT:
			return @"uint";
		case _C_LNG:
			return @"long";
		case _C_ULNG:
			return @"u_long";
		case _C_LNG_LNG:
			return @"long long";
		case _C_ULNG_LNG:
			return @"unsigned long long";
		case _C_FLT:
			return @"float";
		case _C_DBL:
			return @"double";
		case _C_BFLD:
			return @"bit field";
		case _C_BOOL:
			return @"BOOL";
		case _C_VOID:
			return @"void";
		case _C_UNDEF:
			return @"unknown";
		case _C_PTR:
			return @"void*";
		case _C_CHARPTR:
			return @"char*";
		case _C_ATOM:
			return @"atom";
		case _C_ARY_B:
		case _C_ARY_E:
			return @"array";
		case _C_UNION_B:
		case _C_UNION_E:
			return @"union";
		case _C_STRUCT_B:
		case _C_STRUCT_E: {
				NSString* structStr = [[[[SWF(@"%s", code) gsub:@"{_" to:EMPTY_STRING] gsub:OPENING_BRACE to:EMPTY_STRING] split:EQUAL] first];
				if ([QUESTION_MARK isEqualToString:structStr]) {
					return @"struct";
				} else {
					return structStr;
				}
			}
			break;
		case _C_VECTOR:
			return @"vector";
		case _C_CONST:
			return @"const";
		default:
			break;
	}
	return SWF(@"%s", code);
}

@implementation NSObject (Ext)

-(NSArray*) classInfo {
	return [NSObject interfaceForClass:[self class] withObject:self];
}

-(NSArray*) methodNames {
	return [NSObject methodNamesForClass:[self class]];
}

-(NSArray*) properties {
	NSMutableArray* ary = [NSMutableArray array];
	for (NSArray* trio in [self propertiesForClass:[self class]]) {
		[ary addObject:[trio objectAtFirst]];
	}
	return ary;
}

-(NSArray*) protocols {
	return [NSObject protocolsForClass:[self class]];
}

-(NSArray*) classHierarchy {
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
	return [[self classHierarchy] slice:1 backward:-1];
}

-(NSArray*) classMethodNames {
	Class targetClass = [self class]->isa;
	return [NSObject methodNamesForClass:targetClass];
}

-(NSArray*) classMethods {
	Class targetClass = [self class]->isa;
	return [NSObject methodsForClass:targetClass];
}


-(NSArray*) methods {
	return [NSObject methodsForClass:[self class]];
}

-(NSArray*) ivars {
	return [NSObject ivarsForClass:[self class] withObject:self];
}

+(NSArray*) ivarNamesForClass:(Class)targetClass {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count;
	Ivar* ivarList = class_copyIvarList(targetClass, &count);
	for (unsigned int idx = 0; idx < count; idx++) {
		Ivar ivar = ivarList[idx];
		const char* name = ivar_getName(ivar);
		NSString* nameStr = SWF(@"%s", name);
		[ary addObject:nameStr];
	}
	free(ivarList);
	return [ary sort];
}

+(NSArray*) methodNamesForClass:(Class)targetClass {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count;
	Method *methods = class_copyMethodList((Class)targetClass, &count);
	for (size_t idx = 0; idx < count; ++idx) {
		Method method = methods[idx];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		[ary addObject:selectorName];
	}
	free(methods);
	return [ary sort];	
}

+(NSArray*) ivarsForClass:(Class)targetClass withObject:(id)object {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count;
	Ivar* ivarList = class_copyIvarList((Class)targetClass, &count);
	int retStrMax = 0;
	int nameStrMax = 0;
	for (unsigned int idx = 0; idx < count; ++idx) {
		Ivar ivar = ivarList[idx];
		const char* name = ivar_getName(ivar);
		NSString* nameStr = SWF(@"%s", name);
		const char* typeEncoding = ivar_getTypeEncoding(ivar);
		NSString* retStr = SWF(@"%@", TypeEncodingDescription((char*)typeEncoding));
		[ary addObject:PAIR(nameStr, retStr)];
		retStrMax = MAX(retStrMax, retStr.length);
		nameStrMax = MAX(nameStrMax, nameStr.length);
	}
	free(ivarList);
	NSMutableArray* ret = [NSMutableArray array];
	for (NSArray* pair in [ary sortByFirstObject]) {
		NSString* name = [pair objectAtFirst];
		NSString* decl = SWF(@"  %@ %@", [[pair objectAtSecond] ljust:retStrMax], name);
		if (nil == object || object == [object class]) {
			[ret addObject:SWF(@"%@ ;", decl)];
		} else {
			BOOL failed = false;
			id value = [object getInstanceVariableValue:name failed:&failed];
			[ret addObject:SWF(@"%@ %@", [decl ljust:retStrMax + nameStrMax + 3], objectInspect(value))];
		}
	}
	return ret;	
}

+(NSArray*) methodsForProtocol:(Protocol*)protocol isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int outCount;
	struct objc_method_description* methodDescriptionList = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &outCount);
	for (unsigned int idx = 0; idx < outCount; ++idx) {
		struct objc_method_description methodDescription = methodDescriptionList[idx];
		SEL selector = methodDescription.name;
		NSString* selectorString = NSStringFromSelector(selector);
		[ary addObject:SWF(@"    %@", selectorString)];
	}
	free(methodDescriptionList);	
	return [ary sort];
}

+(NSArray*) protocolsForProtocol:(Protocol*)protocol {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int outCount;
	Protocol** protocolList = protocol_copyProtocolList(protocol, &outCount);
	for (unsigned int idx = 0; idx < outCount; ++idx) {
		Protocol* proto = protocolList[idx];
		[ary addObject:SWF(@"%s", protocol_getName(proto))];
	}
	free(protocolList);
	return [ary sort];
}

+(NSArray*) interfaceForClass:(Class)targetClass withObject:(id)object {
	NSString* className = NSStringFromClass(targetClass);
	NSString* superclassName = NSStringFromClass([targetClass superclass]);
	NSString* superclassPart = nil == superclassName ? EMPTY_STRING : SWF(@" : %@", superclassName);
	NSMutableArray* ary = [NSMutableArray array];
	NSArray* protocols = [self protocolsForClass:targetClass];
	NSArray* ivars = [self ivarsForClass:targetClass withObject:object];
	NSString* protocolPart = protocols.count > 0 ? SWF(@" <%@>", [protocols join:COMMA_SPACE]) : EMPTY_STRING;
	NSString* ivarsPart = ivars.count > 0 ? SWF(@" {\n%@\n}", [ivars join:LF]) : EMPTY_STRING;
	[ary addObject:SWF(@"@interface %@%@%@%@", className, superclassPart, protocolPart, ivarsPart)];
	unsigned int classMethodsCount = [self countMethodsForClass:targetClass->isa];
	unsigned int instanceMethodsCount = [self countMethodsForClass:targetClass];
	if (classMethodsCount > 0) {
		[ary addObject:SWF(@"+ %d classMethods ...", classMethodsCount)];
	}
	if (instanceMethodsCount > 0) {
		[ary addObject:SWF(@"- %d methods ...", instanceMethodsCount)];
	}
	return ary;	
}

+(NSArray*) protocolInfoForProtocol:(Protocol*)protocol {
	NSString* protocolName = SWF(@"%s", protocol_getName(protocol));
	NSMutableArray* ary = [NSMutableArray array];
	NSArray* protocols = [self protocolsForProtocol:protocol];
	NSString* protocolPart = protocols.count > 0 ? SWF(@" <%@>", [protocols join:COMMA_SPACE]) : EMPTY_STRING;
	[ary addObject:SWF(@"@protocol %@%@", protocolName, protocolPart)];
	NSMutableArray* optional = [NSMutableArray array];
	[optional addObjectsFromArray:[self methodsForProtocol:protocol isRequiredMethod:false isInstanceMethod:false]];
	[optional addObjectsFromArray:[self methodsForProtocol:protocol isRequiredMethod:false isInstanceMethod:true]];
	if (optional.count > 0) {
		[ary addObject:@"  @optional"];
		[ary addObjectsFromArray:optional];
	}
	NSMutableArray* required = [NSMutableArray array];
	[required addObjectsFromArray:[self methodsForProtocol:protocol isRequiredMethod:true isInstanceMethod:false]];
	[required addObjectsFromArray:[self methodsForProtocol:protocol isRequiredMethod:true isInstanceMethod:true]];
	if (required.count > 0) {
		[ary addObject:@"  @required"];
		[ary addObjectsFromArray:required];
	}
	return ary;
}

+(unsigned int) countMethodsForClass:(Class)targetClass {
	unsigned int count;
	Method* methods = class_copyMethodList(targetClass, &count);
	free(methods);
	return count;
}

+(NSArray*) methodsForClass:(Class)targetClass {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count;
	Method *methods = class_copyMethodList((Class)targetClass, &count);
	int retStrMax = 0;
	for (unsigned int idx = 0; idx < count; ++idx) {
		Method method = methods[idx];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
#define ARGUMENT_OFFSET 2
		unsigned int numberOfArguments = method_getNumberOfArguments(method) - ARGUMENT_OFFSET;
		NSString* selName;
		if (numberOfArguments > 0) {
			NSMutableArray* selArray = [NSMutableArray array];
			NSArray* selArgs = [selectorName split:COLON];
			for (unsigned int argIdx = 0; argIdx < numberOfArguments; argIdx++) {
				NSString* argString = [selArgs objectAtIndex:argIdx];
				char* argType = method_copyArgumentType(method, argIdx + ARGUMENT_OFFSET);
				NSString* argTypeString = TypeEncodingDescription(argType);
				free(argType);
				NSString* shortArgStr;
				NSRange range = [argString rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSBackwardsSearch];
				if (NSNotFound == range.location) {
					shortArgStr = argString;
				} else {
					shortArgStr = [[argString substringFromIndex:range.location] lowercaseString];
				}
				[selArray addObject:SWF(@"%@:(%@)%@", argString, argTypeString, shortArgStr)];
			}
			selName = [selArray join:SPACE];
		} else {
			selName = selectorName;
		}
		char* returnType = method_copyReturnType(method);
		NSString* returnTypeString = TypeEncodingDescription(returnType);
		free(returnType);		 
		NSString* retStr = SWF(@"%@(%@)", class_isMetaClass(targetClass) ? @"+" : @"-", returnTypeString);
		[ary addObject:PAIR(selName, retStr)];
		retStrMax = MAX(retStrMax, retStr.length);
	}
	free(methods);
	NSMutableArray* ret = [NSMutableArray array];
	for (NSArray* pair in [ary sortByFirstObject]) {
		[ret addObject:SWF(@"%@ %@ ;", [[pair objectAtSecond] ljust:retStrMax], [pair objectAtFirst])];
	}
	return ret;
}

+(NSArray*) protocolsForClass:(Class)targetClass {
	NSMutableArray* ary = [NSMutableArray array];
	unsigned int count = 0;
    Protocol** protocols = class_copyProtocolList((Class)targetClass, &count);
	if (nil != protocols) {
		for (int idx = 0 ; idx < count ; idx++) {
			Protocol* protocol = protocols[idx];
			const char* name = protocol_getName(protocol);
			NSString* protocolName = SWF(@"%s", name);
			[ary addObject:protocolName];
		}
	}
	free(protocols);
	return [ary sort];	
}


-(NSArray*) propertiesForClass:(Class)targetClass {
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

-(void) performSelectorAfterChalna:(SEL)selector {
	[self performSelector:selector afterDelay:TIMEINTERVAL_CHALNA];
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

		case _C_CLASS:
			return true;
			break;
			
		default:
			break;
	}		
	return false;
}


-(Class) classForProperty:(NSString*)propertyName {
	for (Class targetClass in [self classHierarchy]) {
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

-(id) getInstanceVariableValue:(NSString*)name failed:(BOOL*)failed {
	Ivar ivar = object_getInstanceVariable(self, [name UTF8String], NULL);
	if (ivar) {
		id outValue = (void *)((char *)self + ivar_getOffset(ivar));
		const char* aTypeDescription = ivar_getTypeEncoding(ivar);
		return [NSObject objectWithValue:outValue withObjCType:aTypeDescription];
	} else {
		*failed = true;
		return nil;
	}
}

-(BOOL) hasInstanceVariable:(NSString*)name {
	Ivar ivar = class_getInstanceVariable([self class], [name UTF8String]);
	return NULL != ivar;
}

-(BOOL) setInstanceVariable:(NSString*)name withString:(NSString*)strObj {
	Ivar ivar = object_getInstanceVariable(self, [name UTF8String], NULL);
	if (ivar) {
		id value = nil;
		const char* aTypeDescription = ivar_getTypeEncoding(ivar);
		switch (*aTypeDescription) {
			case _C_ID:
				return false;
				break;
			case _C_FLT:
				value = [[NSNumber numberWithFloat:[strObj floatValue]] pointerValue];
				break;
			case _C_INT:
				value = [[NSNumber numberWithInt:[strObj intValue]] pointerValue];
				break;				
			case _C_STRUCT_B:
			case _C_STRUCT_E: {
					NSString* attributeString = SWF(@"%s", aTypeDescription);
					if ([attributeString hasPrefix:@"{CGRect"]) {
						CGRect rect = CGRectForString(strObj);
						value = [[NSValue valueWithCGRect:rect] pointerValue];
					} else if ([attributeString hasPrefix:@"{CGAffineTransform"]) {
						CGAffineTransform t = CGAffineTransformFromString(strObj);
						value = [[NSValue valueWithCGAffineTransform:t] pointerValue];
					} else if ([attributeString hasPrefix:@"{CGSize"]) {
						CGSize size = CGSizeFromString(strObj);
						value = [[NSValue valueWithCGSize:size] pointerValue];
					} else if ([attributeString hasPrefix:@"{CGPoint"]) {
						CGPoint point = CGPointFromString(strObj);
						value = [[NSValue valueWithCGPoint:point] pointerValue];					
					} else if ([attributeString hasPrefix:@"{UIEdgeInsets"]) {					
						UIEdgeInsets edgeInsets = UIEdgeInsetsFromString(strObj);
						value = [[NSValue valueWithUIEdgeInsets:edgeInsets] pointerValue];
					} else if ([attributeString hasPrefix:@"{CATransform3D"]) {
						return false;
					} else {
						return false;
					}
				}
				break;
			default:
				return false;
				break;
		}
		return [self setInstanceVariable:name value:value];
	} else {
		return false;
	}
}

-(BOOL) setInstanceVariable:(NSString*)name value:(id)value {
	Ivar ivar = class_getInstanceVariable([self class], [name UTF8String]);
	if (ivar) {
		void** varIndex = (void **)((char *)self + ivar_getOffset(ivar));
		*varIndex = value;
		return true;
	} else {
		return false;
	}
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
			
		case _C_FLT: {
				NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
				[invocation setSelector:sel];
				[invocation setTarget:self];
				[invocation invoke];		
				CGFloat f;
				[invocation getReturnValue:&f];
				return [NSNumber numberWithFloat:f];
			}
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
					obj = [NSValue valueWithCGRect:rect];	
				} else if ([attributesString hasPrefix:@"{CGAffineTransform"]) {
					CGAffineTransform t;
					[invocation getReturnValue:&t];
					obj = [NSValue valueWithCGAffineTransform:t];	
				} else if ([attributesString hasPrefix:@"{CGSize"]) {
					CGSize size;
					[invocation getReturnValue:&size];
					obj = [NSValue valueWithCGSize:size];	
				} else if ([attributesString hasPrefix:@"{CGPoint"]) {
					CGPoint point;
					[invocation getReturnValue:&point];
					obj = [NSValue valueWithCGPoint:point];	
				} else if ([attributesString hasPrefix:@"{UIEdgeInsets"]) {					
					UIEdgeInsets edgeInsets;
					[invocation getReturnValue:&edgeInsets];
					obj = [NSValue valueWithUIEdgeInsets:edgeInsets];	
				} else if ([attributesString hasPrefix:@"{CATransform3D"]) {					
					CATransform3D transform3D;
					[invocation getReturnValue:&transform3D];
					obj = [NSValue valueWithCATransform3D:transform3D];	
				} else if ([attributesString hasPrefix:@"{_NSRange"]) {					
					NSRange range;
					[invocation getReturnValue:&range];
					obj = [NSValue valueWithRange:range];
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
	return STR_NIL;
}
+(NilClass*) nilClass {
	static NilClass* nilClass = nil;
	if (!nilClass) {
		nilClass = [NilClass new];
	}
	return nilClass;
}
@end




@implementation DisquotatedObject
@synthesize object;
@synthesize descript;
-(NSString*) description {
	return [NSString stringWithFormat:@"<%@: %p; object = %@ discript = %@>", [self class], self, object, descript];
}
+(id) disquotatedObjectWithObject:(id)object_ descript:(id)descript_ {
	DisquotatedObject* disq = [[[self alloc] init] autorelease];
	disq.object = object_;
	disq.descript = descript_;
	return disq;
}
-(id) init {
	self = [super init];
	if (self) {
		self.object = nil;
		self.descript = nil;
	}
	return self;
}
- (void)dealloc {
	[object release];
	[descript release];
	[super dealloc];
}

@end

@implementation ProtocolClass
@synthesize protocol;
-(NSArray*) protocolInfo {
	return [NSObject protocolInfoForProtocol:protocol];
}
//-(NSString*) description {
//	return [[NSObject protocolInfoForProtocol:protocol] join:LF];
//}
+(id) protocolWithProtocol:(Protocol*)protocol_ {
	ProtocolClass* protocolClass = [[[self alloc] init] autorelease];
	protocolClass.protocol = protocol_;
	return protocolClass;
}
-(id) init {
	self = [super init];
	if (self) {
		self.protocol = nil;
	}
	return self;
}
- (void)dealloc {
	[protocol release];
	[super dealloc];
}
@end