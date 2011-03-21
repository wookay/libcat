//
//  NSObjectExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_NIL(obj)	(nil == obj || [obj isNil])
#define ARGUMENT_INDEX_ONE 2

@interface NSObject (Ext)

+(NSArray*) methodsForProtocol:(Protocol*)protocol isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod ;
+(NSArray*) methodsForProtocol:(Protocol*)protocol ;
+(NSArray*) methodsForClass:(Class)targetClass ;
+(NSArray*) ivarsForClass:(Class)targetClass ;
+(NSArray*) interfaceForClass:(Class)targetClass ;
+(NSArray*) protocolsForClass:(Class)targetClass ;
+(NSArray*) protocolsForProtocol:(Protocol*)protocol ;
+(NSArray*) methodNamesForClass:(Class)targetClass ;
-(NSArray*) propertiesForClass:(Class)targetClass ;
-(NSArray*) classMethods ;
-(NSArray*) ivars ;
-(NSArray*) methodNames ;
-(NSArray*) protocols ;
-(NSArray*) properties ;
-(NSArray*) classMethodNames ;
-(NSArray*) classHierarchy ;
-(NSArray*) superclasses ;

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti ;
-(void) performSelectorAfterChalna:(SEL)selector ;
-(BOOL) isNil ;
-(BOOL) isNotNil ;
-(NSString*) className ;
-(NSString*) downcasedClassName ;

+(id) objectWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription ;
-(id) getPropertyValue:(SEL)sel failed:(BOOL*)failed ;
-(BOOL) setProperty:(NSString*)propertyName value:(id)value attributeString:(NSString*)attributeString ;
-(BOOL) propertyHasObjectType:(SEL)sel ;
-(Class) classForProperty:(NSString*)propertyName ;

@end


@interface NilClass : NSObject
+(NilClass*) nilClass ;
-(BOOL) isNil ;
@end



@interface DisquotatedObject : NSObject {
	id object;
}
@property (nonatomic, retain)	id object;
+(id) disquotatedObjectWithObject:(id)object_ ;
@end