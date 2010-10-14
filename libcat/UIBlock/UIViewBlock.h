//
//  UIViewBlock.h
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger (^PassBlock)() ;
typedef void (^AnimationBlock)() ;
typedef void (^TraverseBlock)(int depth, UIView* subview) ;

@interface UIView (Block)

+(void) animate:(AnimationBlock)block ;
+(void) animate:(AnimationBlock)block afterDone:(AnimationBlock)doneBlock ;
-(void) traverseSubviews:(TraverseBlock)block ;
-(void) traverseSubviews:(TraverseBlock)block reverse:(BOOL)reverse ;
-(void) traverseSubviews:(TraverseBlock)block depth:(int)depth reverse:(BOOL)reverse ;	

@end