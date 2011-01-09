//
//  NSNumberExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 08/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#define Enum(enum)		[NSNumber numberWithInt:enum]
#define FIXNUM(num)		[NSNumber numberWithInt:num]
#define FIXNUM_with_float(num) FIXNUM(float_to_int(num))
#define FLOAT(num)		[NSNumber numberWithFloat:num]
#define LONGNUM(num)	[NSNumber numberWithDouble:num]

#define FF 255.0

int get_random(int div) ;
CGFloat int_to_float(int val) ;
int float_to_int(float val) ;
BOOL is_odd(int n) ;
int enum_rshift(int greatest, int current) ;

@interface NSNumber (MathFunctions)
-(NSString*) chr ;
-(NSNumber*) next ;
-(NSNumber*) round_up ;
-(NSNumber*) ceiling ;
-(NSNumber*) floor_down ;
@end