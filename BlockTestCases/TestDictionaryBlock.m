//
//  TestDictionaryBlock.m
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSDictionaryBlock.h"
#import "NSStringExt.h"
#import "UnitTest.h"
#import "NSDictionaryExt.h"
#import "NSArrayExt.h"

@interface TestDictionaryBlock : NSObject
@end

@implementation TestDictionaryBlock

-(void) test_dictionary_block {
	assert_equal(_hash2(@"a", @"b", @"c", @"d"), HashSTAR(_w(@"a b c d")));
	
	assert_equal(_w(@"ab cd"), [HashSTAR(_w(@"a b c d")) map:^id(id k, id v) {
		return [PAIR(k,v) join];
	}]);	
}

@end
