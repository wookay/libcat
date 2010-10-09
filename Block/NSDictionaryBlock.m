//
//  NSDictionaryBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDictionaryBlock.h"


@implementation NSDictionary (Block)

-(id) each:(KeyObjectBlock)block {
	[self enumerateKeysAndObjectsUsingBlock:^void(id key, id obj, BOOL *stop) {
		block(key, obj);
	}];
	return self;
}

-(NSArray*) map:(KeyObjectBlock)block {
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateKeysAndObjectsUsingBlock:^void(id key, id obj, BOOL *stop) {
		[ary addObject:block(key, obj)];
	}];
	return ary;
}

@end
