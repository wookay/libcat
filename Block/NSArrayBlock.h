//
//  NSArrayBlock.h
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EachBlock)(id obj);
typedef void (^EachWithIndexBlock)(id obj, int idx);
typedef id (^MapBlock)(id obj);
typedef id (^MapWithIndexBlock)(id obj, int idx);
typedef BOOL (^FilterBlock)(id obj);
typedef id (^ReduceBlock)(id result, id item);
typedef NSComparisonResult (^SortBlock)(id uno, id dos);

@interface NSArray (Block)

-(id) each:(EachBlock)block ;
-(id) each_with_index:(EachWithIndexBlock)block ;
-(NSArray*) map:(MapBlock)block ;
-(NSArray*) map_with_index:(MapWithIndexBlock)block ;
-(NSArray*) select:(FilterBlock)block ;
-(NSArray*) reject:(FilterBlock)block ;
-(NSArray*) reduce:(id)init :(ReduceBlock)block ;
-(NSArray*) sort:(SortBlock)block ;

@end