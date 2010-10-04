//
//  NSNumberExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 08/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FIXNUM(num)		[NSNumber numberWithInt:num]
#define LONGNUM(num)	[NSNumber numberWithDouble:num]

int get_random(int div) ;
CGFloat int_to_float(int val) ;


@interface NSNumber (MathFunctions)
-(id) round_up ;
-(id) ceiling ;
-(id) floor_down ;
@end