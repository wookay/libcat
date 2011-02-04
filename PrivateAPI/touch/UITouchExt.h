//
//  UITouchExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITouch (Ext)
-(NSDictionary*) to_dict:(UIView*)touchView ;
+(UITouch*) touchWithPoint:(CGPoint)point view:(UIView*)view_ ;
+(UITouch*) touchWithPoint:(CGPoint)point view:(UIView*)view_ phase:(UITouchPhase)phase_ ;
-(id) initWithTouch:(UITouch *)touch view:(UIView*)view_ ;
-(id) initWithPoint:(CGPoint)point view:(UIView*)view_ timestamp:(NSTimeInterval)timestamp_ phase:(UITouchPhase)phase_ tapCount:(NSUInteger)tapCount_ ;

#if USE_PRIVATE_API
-(UITouchPhase) savedPhase ;
-(unsigned int) firstTouchForView ;
-(unsigned int) isTap ;
-(unsigned int) isWarped ;
-(unsigned int) isDelayed ;
-(unsigned int) sentTouchesEnded ;
-(UInt8) pathIndex ;
-(UInt8) pathIdentity ;
-(float) pathMajorRadius ;
#endif

@end
