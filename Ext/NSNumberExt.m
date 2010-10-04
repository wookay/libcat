//
//  NSNumberExt.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 08/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSNumberExt.h"
#import "Logger.h"


int get_random(int div) {
	return (arc4random() % div);
}

CGFloat int_to_float(int val) {
	return val + 0.0f;
}





@implementation NSNumber (MathFunctions)
-(id) round_up {
	double value = round([self doubleValue]);
	return [NSNumber numberWithDouble:value];
}
-(id) ceiling {
	double value = ceil([self doubleValue]);
	return [NSNumber numberWithDouble:value];
}
-(id) floor_down {
	double value = floor([self doubleValue]);
	return [NSNumber numberWithFloat:value];
}
@end
