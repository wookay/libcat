//
//  NSArrayExt.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 12/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSArrayExt.h"
#import "NSObjectExt.h"
#import "NSStringExt.h"
#import "NSMutableArrayExt.h"
#import "Logger.h"

NSArray* PAIR(id uno, id dos) {
	NSMutableArray* ary = [NSMutableArray array];
	[ary addObject:(nil == uno) ? [NilClass nilClass] : uno];
	[ary addObject:(nil == dos) ? [NilClass nilClass] : dos];
	return ary;
}

NSArray* TRIO(id uno, id dos, id tres) {
	NSMutableArray* ary = [NSMutableArray array];
	[ary addObject:(nil == uno) ? [NilClass nilClass] : uno];
	[ary addObject:(nil == dos) ? [NilClass nilClass] : dos];
	[ary addObject:(nil == tres) ? [NilClass nilClass] : tres];
	return ary;	
}

NSArray* CUAD(id uno, id dos, id tres, id cuatro) {
	NSMutableArray* ary = [NSMutableArray array];
	[ary addObject:(nil == uno) ? [NilClass nilClass] : uno];
	[ary addObject:(nil == dos) ? [NilClass nilClass] : dos];
	[ary addObject:(nil == tres) ? [NilClass nilClass] : tres];
	[ary addObject:(nil == cuatro) ? [NilClass nilClass] : cuatro];
	return ary;	
}

NSInteger sortByFirstObjectComparator(NSArray* uno, NSArray* dos, void* context) {
	return [[uno objectAtFirst] compare:[dos objectAtFirst]];
}

@implementation NSArray (Ext)

-(BOOL) isEmpty {
	return 0 == self.count;
}

-(NSArray*) slice:(int)loc :(int)length_ {
	NSRange range;
	if (self.count > loc + length_) {
		range = NSMakeRange(loc, length_);
	} else {
		range = NSMakeRange(loc, self.count - loc);
	}
	return [self subarrayWithRange:range];
}

-(NSArray*) slice:(int)loc backward:(int)backward {
	return [self slice:loc :self.count + backward + 1];
}

-(BOOL) hasObject:(id)obj {
	return [self containsObject:obj];
}

-(NSArray*) append:(NSArray*)ary {
	return [self arrayByAddingObjectsFromArray:ary];
}

-(NSString*) join:(NSString*)separator {
	return [self componentsJoinedByString:separator];
}

-(NSString*) join {
	return [self componentsJoinedByString:EMPTY_STRING];
}

-(NSArray*) rshift:(int)cnt {
	int rot = self.count - cnt;
	NSRange left  = NSMakeRange(cnt, rot);
	NSRange right = NSMakeRange(0, cnt);
	return [[self subarrayWithRange:left] arrayByAddingObjectsFromArray:[self subarrayWithRange:right]];
}

-(NSArray*) arrayAtFirst {
	return [self objectAtFirst];
}

-(NSArray*) arrayAtSecond {
	return [self objectAtSecond];
}

-(NSDictionary*) dictionaryAtFirst {
	return [self objectAtFirst];
}

-(NSDictionary*) dictionaryAtSecond {
	return [self objectAtSecond];
}

-(id) objectAtIndexPath:(NSIndexPath*)indexPath {
	return [[self at:indexPath.section] at:indexPath.row];
}

-(id) first {
	return [self objectAtFirst];
}

-(id) objectAtFirst {
	return [self at:0];
}

-(id) objectAtSecond {
	return [self at:1];		
}

-(id) objectAtThird {
	return [self at:2];		
}

-(id) objectAtFourth {
	return [self at:3];		
}

-(id) objectAtLast {
	return [self last];		
}

-(NSArray*) arrayAtIndex:(int)idx {
	return [self at:idx];
}

-(id) at:(int)idx {
	if ([self count] > idx) {
		id obj = [self objectAtIndex:idx];
		if (IS_NIL(obj)) {
			return nil;
		} else {
			return obj;
		}
	} else {
		return nil;
	}
}

-(id) last {
	if ([self count] > 0) {
		id obj = [self lastObject];
		if (IS_NIL(obj)) {
			return nil;
		} else {
			return obj;
		}		
	} else {
		return nil;
	}
}

-(int) index:(id)obj {
	return [self indexOfObject:obj];
}

-(NSArray*) reverse {
	return [[self reverseObjectEnumerator] allObjects];
}

-(NSArray*) transpose {
	NSMutableArray* transposedArray = [NSMutableArray array];		
	if (self.count > 0) {
		NSArray* firstArray = [self objectAtFirst];
		for (int idx = 0; idx < firstArray.count; idx++) {
			[transposedArray addObject:[NSMutableArray array]];
		}
		for (NSArray* subarray in self) {
			for (int idx = 0; idx < subarray.count; idx++) {
				NSMutableArray* ary = [transposedArray objectAtIndex:idx];
				[ary addObject:[subarray objectAtIndex:idx]];
			}
		}
	}
	return transposedArray;
}

-(NSArray*) diagonal:(id)padding {
	NSMutableArray* diagonalArray = [NSMutableArray array];		
	int cnt = self.count;
	for (int row = 0; row < cnt; row++) {
		NSMutableArray* ary = [NSMutableArray array];
		for (int col = 0; col < cnt; col++) {
			if (col == row) {
				[ary addObject:[self objectAtIndex:col]];
			} else {
				[ary addObject:padding];
			}
		}
		[diagonalArray addObject:ary];
	}
	return diagonalArray;
}

-(NSArray*) undiagonal {
	int idx = 0;
	NSMutableArray* ret = [NSMutableArray array];
	for (NSArray* ary in self) {
		[ret addObject:[ary objectAtIndex:idx]];
		idx ++;
	}
	return ret;
}

-(NSArray*) withoutObject:(id)obj {
	NSMutableArray* ary = [NSMutableArray arrayWithArray:self];
	[ary removeObject:obj];
	return ary;
}

-(NSArray*) sort {
	return [self sortedArrayUsingSelector:@selector(compare:)];
}
	
-(NSArray*) sortByFirstObject {
	return [self sortByFunction:sortByFirstObjectComparator];
}

-(NSArray*) sortByFunction:(NSInteger (*)(id, id, void *))comparator {
	return [self sortedArrayUsingFunction:comparator context:nil];
}

@end