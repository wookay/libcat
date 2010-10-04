//
//  TestObserver.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TestObserver.h"
#import "NSMutableArrayExt.h"
#import "ObserverManager.h"
#import "UnitTest.h"
#import "Logger.h"
#import "NSStringExt.h"

@implementation TestObserver
@synthesize name;
@synthesize products;
@synthesize days;

-(void) setup {
	self.products = [NSMutableArray array];
	self.days = [NSMutableSet set];
}

-(void) test_observer {
	[self addObserver:OBSERVERMAN forKeyPath:@"name" withObjectChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj) {
//		log_info(@"obj %@ %@ %@", keyValueChangeToString(kind), obj, oldObj);
	}];
	self.name = @"suzy";
	self.name = nil;
	
	[[self mutableArrayValueForKey:@"products"] addObject:@"hello"];
	[self addObserver:OBSERVERMAN forKeyPath:@"products" withArrayChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj, int idx) {
		if (NSKeyValueChangeSetting == kind) {
//			log_info(@"array %@ %@ %@", keyValueChangeToString(kind), obj, oldObj);
		} else {
//			log_info(@"array %@ %@ %@ %d", keyValueChangeToString(kind), obj, oldObj, idx);
		}
	}];	
	[[self mutableArrayValueForKey:@"products"] addObject:@"world"];
	[[self mutableArrayValueForKey:@"products"] replaceObjectAtIndex:0 withObject:@"my"];
	[[self mutableArrayValueForKey:@"products"] removeObjectAtIndex:0];
	[[self mutableArrayValueForKey:@"products"] removeAllObjects];
	[[self mutableArrayValueForKey:@"products"] removeAllObjects];
	self.products = nil;
	self.products = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
	[[self mutableArrayValueForKey:@"products"] addObjectsFromArray:_w(@"3 4 5")];
	
	[self addObserver:OBSERVERMAN forKeyPath:@"days" withSetChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj) {
		if (NSKeyValueChangeSetting == kind) {
//			log_info(@"set %@ %@", keyValueChangeToString(kind), obj);
		} else {
//			log_info(@"set %@ %@ %@", keyValueChangeToString(kind), obj, oldObj);
		}
	}];
	self.days = [NSMutableSet set];
	[[self mutableSetValueForKey:@"days"] addObject:@"2010-10-03"];
	[[self mutableSetValueForKey:@"days"] addObject:@"2010-10-03"];
	[[self mutableSetValueForKey:@"days"] addObject:@"2010-10-05"];
	self.days = nil;
	self.days = [NSMutableSet set];
	
}


-(void) dealloc {
	[name release];
	[products release];
	[days release];
	[self removeObserver:OBSERVERMAN forKeyPath:@"name"];
	[self removeObserver:OBSERVERMAN forKeyPath:@"products"];
	[self removeObserver:OBSERVERMAN forKeyPath:@"days"];
	[super dealloc];
}


@end
