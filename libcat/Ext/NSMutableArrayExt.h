//
//  NSMutableArrayExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (id) push:(id)obj ;
- (id) pop ;
- (void) setObject:(id)obj atIndex:(int)idx ;
-(void) addObjectIfNotContains:(id)obj ;

@end
