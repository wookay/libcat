//
//  NSNumberBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSNumberBlock.h"


@implementation NSNumber (Block)

-(id) times:(IndexBlock)block {
	for (int idx = 0; idx < [self intValue]; idx++) {
		block(idx);
	}
	return self;
}

@end