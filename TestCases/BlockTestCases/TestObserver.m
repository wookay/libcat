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

	[self addObserver:OBSERVERMAN forKeyPath:@"name" changed:^(NSString* keyPath, id object, NSDictionary* change) {
        NSKeyValueChange kind = [[change valueForKey:@"kind"] intValue];
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

    [self.products addObject:@"hello"];
    assert_equal(_w(@"hello"), self.products);

    [[self mutableArrayValueForKeyPath:@"products"] addObject:@"object"];
    assert_equal(_w(@"hello object"), self.products);

    [self addObserver:OBSERVERMAN forKeyPath:@"products" changed:^(NSString* keyPath, id object, NSDictionary* change) {
        NSKeyValueChange kind = [[change valueForKey:@"kind"] intValue];
		[counter updateArrayWithObject:EMPTY_STRING forKey:Enum(kind)];
	}];
    

    NSMutableArray* ary = [self mutableArrayValueForKeyPath:@"products"];
    [ary addObject:@"world"];
	[ary replaceObjectAtIndex:0 withObject:@"my"];
	[ary removeObjectAtIndex:0];
	[ary removeAllObjects];
	[ary removeAllObjects];
    
	self.products = nil;
	self.products = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
	[ary addObjectsFromArray:_w(@"3 4 5")];
	
	assert_equal(2, [counter arrayCountForKey:Enum(NSKeyValueChangeSetting)]);
	assert_equal(4, [counter arrayCountForKey:Enum(NSKeyValueChangeInsertion)]);
	assert_equal(3, [counter arrayCountForKey:Enum(NSKeyValueChangeRemoval)]);
	assert_equal(1, [counter arrayCountForKey:Enum(NSKeyValueChangeReplacement)]);

	[self removeObserver:OBSERVERMAN forKeyPath:@"products"];
}

-(void) test_mutable_set_observer {
	NSMutableDictionary* counter = [NSMutableDictionary dictionary];
	[self addObserver:OBSERVERMAN forKeyPath:@"days" changed:^(NSString* keyPath, id object, NSDictionary* change) {
        NSKeyValueChange kind = [[change valueForKey:@"kind"] intValue];
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
	assert_equal(3, [counter arrayCountForKey:Enum(NSKeyValueChangeInsertion)]);
	assert_equal(1, [counter arrayCountForKey:Enum(NSKeyValueChangeRemoval)]);
	assert_equal(0, [counter arrayCountForKey:Enum(NSKeyValueChangeReplacement)]);

    [self removeObserver:OBSERVERMAN forKeyPath:@"days"];
}

-(void) test_mutable_dictionary_observer {
	NSMutableDictionary* counter = [NSMutableDictionary dictionary];
    
    ObjectChangedBlock dictionaryChangedBlock = ^(NSString* keyPath, id object, NSDictionary* change) {
        NSKeyValueChange kind = [[change valueForKey:@"kind"] intValue];
		[counter updateArrayWithObject:EMPTY_STRING forKey:Enum(kind)];
	};
	[self addObserver:OBSERVERMAN forKeyPath:@"book" changed:dictionaryChangedBlock];
    [OBSERVERMAN addDictionaryChangedBlock:dictionaryChangedBlock forKeyPath:@"book"];

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

-(void) dealloc {
	[name release];
	[products release];
	[days release];
	[book release];
	[super dealloc];
}

@end