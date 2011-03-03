//
//  NSMutableDictionaryExt.h
//  BigCalendar
//
//  Created by Woo-Kyoung Noh on 14/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryExt.h"

@interface NSMutableDictionary (UpdateArray)

-(void) setKey:(id)key withObject:(id)obj ;
-(void) updateArrayWithObject:(id)obj forKey:(id)key ;
-(void) updateArrayWithArray:(NSArray*)obj forKey:(id)key ;
-(void) updateDictionaryWithObject:(id)obj innerKey:(id)innerKey forKey:(id)key ;
-(void) updateDictionaryWithDictionary:(NSDictionary*)obj forKey:(id)key ;

@end
