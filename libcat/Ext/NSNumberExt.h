//
//  NSNumberExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 08/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Enum(enum)		[NSNumber numberWithInt:enum]
#define FIXNUM(num)		[NSNumber numberWithInt:num]
#define LONGNUM(num)	[NSNumber numberWithDouble:num]

int get_random(int div) ;
CGFloat int_to_float(int val) ;
BOOL is_odd(int n) ;
int enum_rshift(int greatest, int current) ;

@interface NSNumber (MathFunctions)
-(NSString*) chr ;
-(NSNumber*) next ;
-(NSNumber*) round_up ;
-(NSNumber*) ceiling ;
-(NSNumber*) floor_down ;
@end