//
//  NSArrayBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSArrayBlock.h"
#import "Logger.h"

@implementation NSArray (Block)

-(void) each:(EachBlock)block {
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block(obj);
	}];
}

-(void) each_with_index:(EachWithIndexBlock)block {
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block(obj, idx);
	}];	
}

-(NSArray*) map:(MapBlock)block {
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[ary addObject:block(obj)];
	}];
	return ary;
}

-(NSArray*) map_with_index:(MapWithIndexBlock)block {	
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[ary addObject:block(obj, idx)];
	}];
	return ary;	
}

-(NSArray*) select:(FilterBlock)block {
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (block(obj)) {
			[ary addObject:obj];
		}
	}];
	return ary;
}

-(NSArray*) reject:(FilterBlock)block {
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (! block(obj)) {
			[ary addObject:obj];
		}
	}];
	return ary;
}

@end