//
//  NSObjectExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_NULL(obj)	(nil == obj || [obj isNull])

@interface NSObject (Ext)

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti ;
-(BOOL) isNull ;
-(BOOL) isNotNull ;
-(NSArray*) class_properties ;
-(NSArray*) class_properties:(Class)targetClass ;
-(NSArray*) methods ;
-(NSArray*) class_methods ;
-(NSString*) downcasedClassName ;
//+(id) objectByAddress:(const void *)aValue withObjCType:(const char *)aTypeDescription ;
+(id) objectWithValue:(const void *)aValue withObjCType:(const char *)aTypeDescription ;
-(NSArray*) class_hierarchy ;
-(NSArray*) superclasses ;
@end