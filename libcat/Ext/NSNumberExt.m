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

BOOL is_odd(int n) {
	return 1 == n%2;
}


@implementation NSNumber (MathFunctions)
-(NSString*) chr {
	return [NSString stringWithFormat:@"%C", [self charValue]];
}
-(NSNumber*) next {
	return [NSNumber numberWithInt:[self intValue] + 1];
}
-(NSNumber*) round_up {
	double value = round([self doubleValue]);
	return [NSNumber numberWithDouble:value];
}
-(NSNumber*) ceiling {
	double value = ceil([self doubleValue]);
	return [NSNumber numberWithDouble:value];
}
-(NSNumber*) floor_down {
	double value = floor([self doubleValue]);
	return [NSNumber numberWithDouble:value];
}
@end