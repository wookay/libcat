//
//  NSMutableArrayExt.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSMutableArrayExt.h"
#import "Logger.h"

@implementation NSMutableArray (Stack)

-(void) addObjectIfNotContains:(id)obj {
	if ([self containsObject:obj]) {
	} else {
		[self addObject:obj];
	}
}

- (id) push:(id)obj {
	[self addObject:obj];
	return self;
}

- (id) pop {
	if ([self count] == 0) {
		return nil;
	}
	id obj = [[[self lastObject] retain] autorelease];
	[self removeLastObject];
	return obj;
}

- (id) dequeue {
    if ([self count] == 0) {
        return nil;
    }
    id obj = [[[self objectAtIndex:0] retain] autorelease];
    [self removeObjectAtIndex:0];
    return obj;
}

-(void) setObject:(id)obj atIndex:(int)idx {
	if (idx < self.count) {
		[self replaceObjectAtIndex:idx withObject:obj];
	}
}

@end
