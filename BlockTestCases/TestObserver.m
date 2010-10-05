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
@synthesize book;

-(void) setup {
	self.products = [NSMutableArray array];
	self.days = [NSMutableSet set];
	self.book = [NSMutableDictionary dictionary];
}

-(void) test_observer {
	[self addObserver:OBSERVERMAN forKeyPath:@"name" withObjectChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj) {
//		log_info(@"obj %@ %@ %@", keyValueChangeToString(kind), obj, oldObj);
	}];
	self.name = @"suzy";
	self.name = nil;
	
	[[self mutableArrayValueForKeyPath:@"products"] addObject:@"hello"];
	[self addObserver:OBSERVERMAN forKeyPath:@"products" withArrayChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj, int idx) {
		if (NSKeyValueChangeSetting == kind) {
//			log_info(@"array %@ %@ %@", keyValueChangeToString(kind), obj, oldObj);
		} else {
//			log_info(@"array %@ %@ %@ %d", keyValueChangeToString(kind), obj, oldObj, idx);
		}
	}];	
	[[self mutableArrayValueForKeyPath:@"products"] addObject:@"world"];
	[[self mutableArrayValueForKeyPath:@"products"] replaceObjectAtIndex:0 withObject:@"my"];
	[[self mutableArrayValueForKeyPath:@"products"] removeObjectAtIndex:0];
	[[self mutableArrayValueForKeyPath:@"products"] removeAllObjects];
	[[self mutableArrayValueForKeyPath:@"products"] removeAllObjects];
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
	[[self mutableSetValueForKeyPath:@"days"] addObject:@"2010-10-03"];
	[[self mutableSetValueForKeyPath:@"days"] addObject:@"2010-10-03"];
	[[self mutableSetValueForKeyPath:@"days"] addObject:@"2010-10-05"];
	self.days = nil;
	self.days = [NSMutableSet set];

	id dictionaryChangedBlock = ^(NSKeyValueChange kind, id obj, id oldObj, id key) {
		if (NSKeyValueChangeSetting == kind) {
//			log_info(@"dict %@  obj:%@  oldObj:%@", keyValueChangeToString(kind), obj, oldObj);
		} else {
//			log_info(@"dict %@  obj:%@  oldObj:%@  key:%@", keyValueChangeToString(kind), obj, oldObj, key);
		}
	};
	[OBSERVERMAN addDictionaryChangedBlock:dictionaryChangedBlock forKeyPath:@"book"];
	[self addObserver:OBSERVERMAN forKeyPath:@"book" withDictionarySetBlock:dictionaryChangedBlock];
	self.book = nil;
	self.book = [NSMutableDictionary dictionary];
	[[self mutableDictionaryValueForKeyPath:@"book"] setObject:@"best book title" forKey:@"best"];
	[[self mutableDictionaryValueForKeyPath:@"book"] setObject:@"best book title.." forKey:@"best"];
	[[self mutableDictionaryValueForKeyPath:@"book"] removeObjectForKey:@"best"];
	[[self mutableDictionaryValueForKeyPath:@"book"] setObject:@"test book title" forKey:@"test"];
}


-(void) dealloc {
	[name release];
	[products release];
	[days release];
	[book release];
	[self removeObserver:OBSERVERMAN forKeyPath:@"name"];
	[self removeObserver:OBSERVERMAN forKeyPath:@"products"];
	[self removeObserver:OBSERVERMAN forKeyPath:@"days"];
	[self removeObserver:OBSERVERMAN forKeyPath:@"book"];
	[OBSERVERMAN removeDictionaryChangedBlockForKeyPath:@"book"];
	[super dealloc];
}


@end