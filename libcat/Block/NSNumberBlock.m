//
//  NSNumberBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSNumberBlock.h"


@implementation NSNumber (Block)

-(id) times:(id)block {
	for (int idx = 0; idx < [self intValue]; idx++) {
		((IndexBlock)block)(idx);
	}
	return self;
}

-(id) upto:(int)limit :(id)block {
	for (int idx = [self intValue]; idx <= limit; idx++) {
		((IndexBlock)block)(idx);
	}
	return self;
}

-(id) downto:(int)limit :(id)block {
	for (int idx = [self intValue]; idx >= limit; idx--) {
		((IndexBlock)block)(idx);
	}
	return self;
}

@end