//
//  NSMutableDictionaryExt.m
//  BigCalendar
//
//  Created by Woo-Kyoung Noh on 14/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSMutableDictionaryExt.h"



@implementation NSMutableDictionary (UpdateArray)

-(void) updateArray:(id)obj forKey:(id)key {
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

-(NSArray*) arrayForKey:(id)key {
	NSArray* exist = [self objectForKey:key];
	if (nil == exist) {
		return [NSArray array];
	}
	return exist;
}

@end