//
//  NSMutableDictionaryExt.h
//  BigCalendar
//
//  Created by Woo-Kyoung Noh on 14/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (UpdateArray)

-(void) updateArray:(id)obj forKey:(id)key ;
-(void) updateArrayWithArray:(NSArray*)obj forKey:(id)key ;
-(NSArray*) arrayForKey:(id)key ;

@end
