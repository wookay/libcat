//
//  NSDictionaryBlock.h
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^KeyObjectBlock)(id key, id obj);

@interface NSDictionary (Block)

-(id) each:(KeyObjectBlock)block ;
-(NSArray*) map:(KeyObjectBlock)block ;

@end
