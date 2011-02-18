//
//  NSArrayBlock.m
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSArrayBlock.h"
#import "Logger.h"
#import "NSObjectExt.h"

@implementation NSArray (Block)

-(id) each:(EachBlock)block {
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block(obj);
	}];
	return self;
}

-(id) each_with_index:(EachWithIndexBlock)block {
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block(obj, idx);
	}];	
	return self;
}

-(NSArray*) map:(MapBlock)block {
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id result = block(obj);
		[ary addObject:result ? result : [NilClass nilClass]];
	}];
	return ary;
}

-(NSArray*) map_with_index:(MapWithIndexBlock)block {	
	NSMutableArray* ary = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id result = block(obj, idx);
		[ary addObject:result ? result : [NilClass nilClass]];
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

-(NSArray*) reduce:(id)init :(ReduceBlock)block {
	__block id result = init;
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		result = block(result, obj);
	}];
	return result;
}

- (NSArray *) sort:(SortBlock)block {
	return [self sortedArrayUsingComparator:block];
}

@end