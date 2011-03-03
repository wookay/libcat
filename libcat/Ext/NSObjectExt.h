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

-(NSArray*) class_properties ;
-(NSArray*) class_properties:(Class)targetClass ;
-(NSArray*) methods ;
-(NSArray*) class_methods ;
-(NSArray*) class_methods:(Class)targetClass ;
-(NSArray*) class_hierarchy ;
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