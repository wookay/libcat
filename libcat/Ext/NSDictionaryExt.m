//
//  NSDictionaryExt.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 05/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDictionaryExt.h"
#import "Inspect.h"
#import "NSArrayExt.h"

NSDictionary* HashSTAR(NSArray* ary) {
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	for (int idx=0; idx<=ary.count/2; idx+=2) {
		[dict addEntriesFromDictionary:
		 [NSDictionary dictionaryWithKeysAndObjects:
			[ary objectAtIndex:idx], [ary objectAtIndex:idx+1],
			nil]];
	}
	return dict;
}

@implementation NSDictionary (Ext)

-(int) intForKey:(id)key {
	return [[self objectForKey:key] intValue];
}

-(id) objectAtIndexSortedKeys:(int)idx {
	id key = [[self sortedKeys] objectAtIndex:idx];
	id obj = [self objectForKey:key];
	return obj;
}

-(NSArray*) sortedKeys {
	return [[self allKeys] sort];
}

-(NSArray*) sortedKeys:(SEL)selector {
	return [[self allKeys] sortedArrayUsingSelector:selector];
}

-(NSDictionary*) append:(NSDictionary*)dict {
	NSMutableDictionary* mut = [NSMutableDictionary dictionaryWithDictionary:self];
	[mut addEntriesFromDictionary:dict];
	return mut;
}

-(BOOL) valuesHaveObject:(id)obj {
	return [[self allValues] containsObject:obj];
}

-(BOOL) hasKey:(id)key {
	return [[self allKeys] containsObject:key];	
}

-(BOOL) hasNotKey:(id)key {
	return ! [[self allKeys] containsObject:key];	
}

-(id) keyForObject:(id)obj {
	NSArray* ary = [self allKeysForObject:obj];
	if (ary.count > 0) {
		return [ary objectAtFirst];
	} else {
		return nil;
	}
}

-(BOOL) isEmpty {
	return 0 ==[self allKeys].count;
}

-(NSArray*) keyValuePairs {
	NSMutableArray* ary = [NSMutableArray array];
	for (id key in [self allKeys]) {
		id value = [self objectForKey:key];
		[ary addObject:PAIR(key,value)];
	}
	return ary;
}

+ (id)dictionaryWithKeysAndObjects:(id)firstKey, ... {
	NSMutableArray* keys = [NSMutableArray array];
	NSMutableArray* objects = [NSMutableArray array];	
	id obj = firstKey;
	va_list args;
	va_start(args, firstKey);	
	int idx = 0;
	while (nil != obj) {
		if (0 == idx%2) {
			[keys addObject:obj];
		} else {
			[objects addObject:obj];
		}
		obj = va_arg(args, id);
		idx += 1;
	}
	va_end(args);
	return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

-(NSArray*) arrayForKey:(id)key {
	NSArray* exist = [self objectForKey:key];
	if (nil == exist) {
		return [NSArray array];
	}
	return exist;
}

-(int) arrayCountForKey:(id)key {
	return [[self arrayForKey:key] count];
}

@end