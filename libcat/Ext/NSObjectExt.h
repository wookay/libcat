//
//  NSObjectExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_NULL(obj)	(nil == obj || [obj isNull])
#define ARGUMENT_INDEX_ONE 2

@interface NSObject (Ext)

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti ;
-(BOOL) isNull ;
-(BOOL) isNotNull ;
-(NSArray*) class_properties ;
-(NSArray*) class_properties:(Class)targetClass ;
-(NSArray*) methods ;
-(NSArray*) class_methods ;
-(NSString*) downcasedClassName ;
-(NSArray*) class_hierarchy ;
-(NSArray*) superclasses ;
+(id) objectWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription ;
-(id) getPropertyValue:(SEL)sel failed:(BOOL*)failed ;
-(BOOL) setProperty:(NSString*)propertyName value:(id)value attributeString:(NSString*)attributeString ;
-(BOOL) propertyHasObjectType:(SEL)sel ;

@end