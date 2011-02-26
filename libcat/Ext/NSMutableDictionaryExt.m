//
//  NSMutableDictionaryExt.m
//  BigCalendar
//
//  Created by Woo-Kyoung Noh on 14/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSMutableDictionaryExt.h"



@implementation NSMutableDictionary (UpdateArray)

-(void) setKey:(id)key withObject:(id)obj {
	[self setObject:obj forKey:key];
}

-(void) updateArrayWithObject:(id)obj forKey:(id)key {
	NSArray* exist = [self objectForKey:key];
	NSMutableArray* ary;
	if (nil == exist) {
		ary = [NSMutableArray array];
	} else {
		ary = [NSMutableArray arrayWithArray:exist];
	}
	[ary addObject:obj];
	[self setObject:ary forKey:key];
}

-(void) updateArrayWithArray:(NSArray*)obj forKey:(id)key {
	NSArray* exist = [self objectForKey:key];
	NSMutableArray* ary;
	if (nil == exist) {
		ary = [NSMutableArray array];
	} else {
		ary = [NSMutableArray arrayWithArray:exist];
	}
	[ary addObjectsFromArray:obj];
	[self setObject:ary forKey:key];
}

-(void) updateDictionaryWithObject:(id)obj innerKey:(id)innerKey forKey:(id)key {
	NSDictionary* exist = [self objectForKey:key];
	NSMutableDictionary* dict;
	if (nil == exist) {
		dict = [NSMutableDictionary dictionary];
	} else {
		dict = [NSMutableDictionary dictionaryWithDictionary:exist];
	}
	[dict setObject:obj forKey:innerKey];
	[self setObject:dict forKey:key];
}

-(void) updateDictionaryWithDictionary:(NSDictionary*)obj forKey:(id)key {
	NSDictionary* exist = [self objectForKey:key];
	NSMutableDictionary* dict;
	if (nil == exist) {
		dict = [NSMutableDictionary dictionary];
	} else {
		dict = [NSMutableDictionary dictionaryWithDictionary:exist];
	}
	[dict addEntriesFromDictionary:obj];
	[self setObject:dict forKey:key];
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