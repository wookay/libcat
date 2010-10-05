//
//  UIViewBlock.h
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AnimationBlock)() ;

@interface UIView (Block)

+(void) animate:(AnimationBlock)block ;
+(void) animate:(AnimationBlock)block afterDone:(AnimationBlock)doneBlock ;

@end
