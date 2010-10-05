//
//  NSNumberBlock.h
//  BlockTest
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArrayBlock.h"

typedef void (^IndexBlock)(int idx);


@interface NSNumber (Block)

-(id) times:(id)block ;
-(id) upto:(int)limit :(id)block ;
-(id) downto:(int)limit :(id)block ;

@end
