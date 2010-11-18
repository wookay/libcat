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
#import "NSNumberExt.h"
#import "NSMutableDictionaryExt.h"

@implementation TestObserver
@synthesize name;
@synthesize products;
@synthesize days;
@synthesize book;

-(void) setup {
	self.name = nil;
	self.products = [NSMutableArray array];
	self.days = [NSMutableSet set];
	self.book = [NSMutableDictionary dictionary];
}

-(void) test_object_observer {
	NSMutableDictionary* counter = [NSMutableDictionary dictionary];

	[self addObserver:OBSERVERMAN forKeyPath:@"name" withObjectChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj) {
		[counter updateArrayWithObject:EMPTY_STRING forKey:Enum(kind)];
	}];
	self.name = @"suzy";
	self.name = nil;
	
	assert_equal(2, [counter arrayCountForKey:Enum(NSKeyValueChangeSetting)]);	
	assert_equal(0, [counter arrayCountForKey:Enum(NSKeyValueChangeInsertion)]);
	assert_equal(0, [counter arrayCountForKey:Enum(NSKeyValueChangeRemoval)]);
	assert_equal(0, [counter arrayCountForKey:Enum(NSKeyValueChangeReplacement)]);
	
	[self removeObserver:OBSERVERMAN forKeyPath:@"name"];
}

-(void) test_mutable_array_observer {
	NSMutableDictionary* counter = [NSMutableDictionary dictionary];

	[[self mutableArrayValueForKeyPath:@"products"] addObject:@"hello"];
	[self addObserver:OBSERVERMAN forKeyPath:@"products" withArrayChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj, int idx) {
		[counter updateArrayWithObject:EMPTY_STRING forKey:Enum(kind)];
	}];	
	NSMutableArray* products_ = [self mutableArrayValueForKeyPath:@"products"];
	[products_ addObject:@"world"];
	[products_ replaceObjectAtIndex:0 withObject:@"my"];
	[products_ removeObjectAtIndex:0];
	[products_ removeAllObjects];
	[products_ removeAllObjects];
	self.products = nil;
	self.products = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
	[products_ addObjectsFromArray:_w(@"3 4 5")];
	
	assert_equal(2, [counter arrayCountForKey:Enum(NSKeyValueChangeSetting)]);	
	assert_equal(4, [counter arrayCountForKey:Enum(NSKeyValueChangeInsertion)]);
	assert_equal(2, [counter arrayCountForKey:Enum(NSKeyValueChangeRemoval)]);
	assert_equal(1, [counter arrayCountForKey:Enum(NSKeyValueChangeReplacement)]);
	
	[self removeObserver:OBSERVERMAN forKeyPath:@"products"];
}
	
-(void) test_mutable_set_observer {
	NSMutableDictionary* counter = [NSMutableDictionary dictionary];
	[self addObserver:OBSERVERMAN forKeyPath:@"days" withSetChangedBlock:^(NSKeyValueChange kind, id obj, id oldObj) {
		[counter updateArrayWithObject:EMPTY_STRING forKey:Enum(kind)];
	}];
	self.days = [NSMutableSet set];
	NSMutableSet* days_ = [self mutableSetValueForKeyPath:@"days"];
	[days_ addObject:@"2010-10-03"];
	[days_ addObject:@"2010-10-03"];
	[days_ addObject:@"2010-10-05"];
	[days_ removeObject:@"2010-10-05"];
	self.days = nil;
	self.days = [NSMutableSet set];
	
	assert_equal(3, [counter arrayCountForKey:Enum(NSKeyValueChangeSetting)]);	
	assert_equal(2, [counter arrayCountForKey:Enum(NSKeyValueChangeInsertion)]);
	assert_equal(1, [counter arrayCountForKey:Enum(NSKeyValueChangeRemoval)]);
	assert_equal(0, [counter arrayCountForKey:Enum(NSKeyValueChangeReplacement)]);
	
}
	
-(void) test_mutable_dictionary_observer {
	NSMutableDictionary* counter = [NSMutableDictionary dictionary];
	DictionaryChangedBlock dictionaryChangedBlock = ^(NSKeyValueChange kind, id obj, id oldObj, id key) {		
		[counter updateArrayWithObject:EMPTY_STRING forKey:Enum(kind)];
	};	
	[OBSERVERMAN addDictionaryChangedBlock:dictionaryChangedBlock forKeyPath:@"book"];
	[self addObserver:OBSERVERMAN forKeyPath:@"book" withDictionarySetBlock:dictionaryChangedBlock];
	self.book = nil;
	self.book = [NSMutableDictionary dictionary];
	NSMutableDictionary* book_ = [self mutableDictionaryValueForKeyPath:@"book"];
	[book_ setObject:@"best book title" forKey:@"best"];
	[book_ setObject:@"best book title.." forKey:@"best"];
	[book_ removeObjectForKey:@"best"];
	[book_ setObject:@"test book title" forKey:@"test"];
	
	assert_equal(3, [counter arrayCountForKey:Enum(NSKeyValueChangeSetting)]);
	assert_equal(2, [counter arrayCountForKey:Enum(NSKeyValueChangeInsertion)]);
	assert_equal(1, [counter arrayCountForKey:Enum(NSKeyValueChangeRemoval)]);
	assert_equal(1, [counter arrayCountForKey:Enum(NSKeyValueChangeReplacement)]);
	
	[self removeObserver:OBSERVERMAN forKeyPath:@"book"];
	[OBSERVERMAN removeDictionaryChangedBlockForKeyPath:@"book"];
}

-(void) hello {
}

//-(void) test_before_invoke {
//	__block int cnt = 0;
//	[self before_invoke_any_selector:^(SEL sel) {
//		cnt += 1;
//	}];	
//	[self before_invoke_selector:@selector(hello) block:^{
//		cnt += 1;
//	}];
//	[self hello];
//	assert_equal(2, cnt);
//}

-(void) dealloc {
	[self removeObserver:OBSERVERMAN forKeyPath:@"days"];	

	[name release];
	[products release];
	[days release];
	[book release];
	[super dealloc];
}

@end