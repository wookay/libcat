//
//  NSDictionaryExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 05/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _hash0() [NSDictionary dictionary]
#define _hash1(k1, v1) [NSDictionary dictionaryWithObjectsAndKeys:v1, k1, nil]
#define _hash2(k1, v1, k2, v2) [NSDictionary dictionaryWithObjectsAndKeys:v1, k1, v2, k2, nil]
#define _hash3(k1, v1, k2, v2, k3, v3) [NSDictionary dictionaryWithObjectsAndKeys:v1, k1, v2, k2, v3, k3, nil]

NSDictionary* HashSTAR(NSArray* ary) ;

@interface NSDictionary (Ext)

-(int) intForKey:(id)key ;
-(NSDictionary*) append:(NSDictionary*)dict ;
+ (id)dictionaryWithKeysAndObjects:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION ;
-(BOOL) valuesHaveObject:(id)obj ;
-(id) keyForObject:(id)obj ;
-(BOOL) hasKey:(id)key ;
-(BOOL) hasNotKey:(id)key ;
-(NSArray*) sortedKeys ;
-(NSArray*) sortedKeys:(SEL)selector ;
-(NSArray*) sortedKeysByCountOfObjects ;
-(BOOL) isEmpty ;
-(NSArray*) keyValuePairs ;
-(NSArray*) arrayForKey:(id)key ;
-(int) arrayCountForKey:(id)key ;
-(id) objectAtIndexSortedKeys:(int)idx ;

@end
