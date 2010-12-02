//
//  UITouchExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITouch (Ext)
-(id) initWithTouch:(UITouch *)touch view:(UIView*)view_ ;
+(UITouch*) touchWithPoint:(CGPoint)point view:(UIView*)view_ phase:(UITouchPhase)phase_ ;
-(id) initWithPoint:(CGPoint)point view:(UIView*)view_ timestamp:(NSTimeInterval)timestamp_ phase:(UITouchPhase)phase_ tapCount:(NSUInteger)tapCount_ ;
@end
