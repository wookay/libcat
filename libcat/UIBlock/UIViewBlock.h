//
//  UIViewBlock.h
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger (^PassBlock)() ;
typedef void (^AnimationBlock)() ;
typedef void (^TraverseViewBlock)(int depth, UIView* view) ;

@interface UIView (Block)

+(void) animate:(AnimationBlock)block ;
+(void) animate:(AnimationBlock)block afterDone:(AnimationBlock)doneBlock ;
-(void) traverseSubviews:(TraverseViewBlock)block ;
-(void) traverseSubviews:(TraverseViewBlock)block reverse:(BOOL)reverse ;
-(void) traverseSubviews:(TraverseViewBlock)block depth:(int)depth reverse:(BOOL)reverse ;	
-(void) traverseSuperviews:(TraverseViewBlock)block ;
-(void) traverseSuperviews:(TraverseViewBlock)block depth:(int)depth ;

@end