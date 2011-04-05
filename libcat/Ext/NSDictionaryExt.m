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
#import "Logger.h"
#import "NSNumberExt.h"

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

-(NSArray*) sortedKeysByCountOfObjects {
	NSMutableArray* ary = [NSMutableArray array];
	NSArray* unsortedKeys = [self allKeys];
	for (id key in unsortedKeys) {
		id obj = [self objectForKey:key];
		if ([obj isKindOfClass:[NSArray class]]) {
			NSArray* items = obj;
			[ary addObject:PAIR(FIXNUM(items.count), key)];
		} else {
			return unsortedKeys;
		}
	}
	NSMutableArray* ret = [NSMutableArray array];
	for (NSArray* pair in [ary sortByFirstObject]) {
		[ret addObject:[pair objectAtSecond]];
	}
	return ret;
}

-(NSDictionary*) append:(NSDictionary*)dict {
	NSMutableDictionary* mut = [NSMutableDictionary dictionaryWithDictionary:self];
	[mut addEntriesFromDictionary:dict];
	return mut;
}

-(BOOL) valuesHaveObject:(id)obj {
	NSEnumerator* enumerator = [self objectEnumerator];
	id objectForKey;
	while ((objectForKey = [enumerator nextObject])) {
		if ([objectForKey isEqual:obj]) {
			return true;
		}
	}		
	return false;
	
}

-(BOOL) hasKey:(id)key {
	NSEnumerator* enumerator = [self keyEnumerator];
	id k;
	while ((k = [enumerator nextObject])) {
		if ([k isEqual:key]) {
			return true;
		}
	}		
	return false;
}

-(BOOL) hasNotKey:(id)key {
	return ! [self hasKey:key];
}

-(id) keyForObject:(id)obj {
	NSEnumerator* enumerator = [self keyEnumerator];
	id key;
	while ((key = [enumerator nextObject])) {
		id objectForKey = [self objectForKey:key];
		if ([objectForKey isEqual:obj]) {
			return key;
		}
	}
	return nil;
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