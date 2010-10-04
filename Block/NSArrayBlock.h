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

@interface NSArray (Block)

-(void) each:(EachBlock)block ;
-(void) each_with_index:(EachWithIndexBlock)block ;
-(NSArray*) map:(MapBlock)block ;
-(NSArray*) map_with_index:(MapWithIndexBlock)block ;
-(NSArray*) select:(FilterBlock)block ;
-(NSArray*) reject:(FilterBlock)block ;

@end
