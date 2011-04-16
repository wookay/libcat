//
//  NSObjectExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_NIL(obj)	(nil == obj || [obj isKindOfClass:[NilClass class]])
#define IS_NOT_NIL(obj)	(! IS_NIL(obj))
#define ARGUMENT_INDEX_ONE 2

@interface NSObject (Ext)

+(unsigned int) countMethodsForClass:(Class)targetClass ;
+(NSArray*) methodsForProtocol:(Protocol*)protocol isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod ;
+(NSArray*) protocolInfoForProtocol:(Protocol*)protocol ;
+(NSArray*) methodsForClass:(Class)targetClass ;
+(NSArray*) ivarsForClass:(Class)targetClass withObject:(id)object ;
+(NSArray*) interfaceForClass:(Class)targetClass withObject:(id)object ;
+(NSArray*) protocolsForClass:(Class)targetClass ;
+(NSArray*) protocolsForProtocol:(Protocol*)protocol ;
+(NSArray*) methodNamesForClass:(Class)targetClass ;
-(NSArray*) classInfo ;
-(NSArray*) propertiesForClass:(Class)targetClass ;
-(NSArray*) classMethods ;
-(NSArray*) methods ;
-(NSArray*) ivars ;
-(NSArray*) protocols ;
-(NSArray*) properties ;
-(NSArray*) classHierarchy ;
-(NSArray*) superclasses ;
-(NSArray*) classMethodNames ;
-(NSArray*) methodNames ;
+(NSArray*) ivarNamesForClass:(Class)targetClass ;
-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti ;
-(void) performSelectorAfterChalna:(SEL)selector ;
-(NSString*) className ;
-(NSString*) downcasedClassName ;

+(id) objectWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription ;
-(id) getPropertyValue:(SEL)sel failed:(BOOL*)failed ;
-(BOOL) setProperty:(NSString*)propertyName value:(id)value attributeString:(NSString*)attributeString ;
-(BOOL) propertyHasObjectType:(SEL)sel ;
-(Class) classForProperty:(NSString*)propertyName ;

-(BOOL) hasInstanceVariable:(NSString*)name ;
-(id) getInstanceVariableValue:(NSString*)name failed:(BOOL*)failed ;
-(BOOL) setInstanceVariable:(NSString*)name value:(id)value ;
-(BOOL) setInstanceVariable:(NSString*)name withString:(NSString*)strObj ;


@end


@interface NilClass : NSObject
+(NilClass*) nilClass ;
@end



@interface DisquotatedObject : NSObject {
	id object;
	id descript;
}
@property (nonatomic, retain)	id object;
@property (nonatomic, retain)	id descript;
+(id) disquotatedObjectWithObject:(id)object_ descript:(id)descript_ ;
@end


@interface ProtocolClass : NSObject {
	Protocol* protocol;
}
@property (nonatomic, retain)	Protocol* protocol;
-(NSArray*) protocolInfo ;
+(id) protocolWithProtocol:(Protocol*)protocol_ ;
@end