//
//  UITouchExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UITouchExt.h"


@implementation UITouch (Ext)

+(UITouch*) touchWithPoint:(CGPoint)point view:(UIView*)view_ phase:(UITouchPhase)phase_ {
	NSTimeInterval timestamp_ = [NSDate timeIntervalSinceReferenceDate];
	NSUInteger tapCount_ = 1;
	UITouch* touch = [[UITouch alloc] initWithPoint:point view:view_ timestamp:timestamp_ phase:phase_ tapCount:tapCount_];
	return touch;
}

-(id) initWithPoint:(CGPoint)point view:(UIView*)view_ timestamp:(NSTimeInterval)timestamp_ phase:(UITouchPhase)phase_ tapCount:(NSUInteger)tapCount_ {
    self = [super init];
    if (nil != self) {
        _timestamp = timestamp_;
        _phase = phase_;
        _tapCount = tapCount_;
        _window = view_.window;
        _view = view_;
        _gestureRecognizers = [NSMutableArray array];
        _locationInWindow = point;
        _previousLocationInWindow = point;
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _touchFlags._isWarped = 0;
        _touchFlags._isDelayed = 0;
        _touchFlags._sentTouchesEnded = 0;
    }
    return self;
}

-(id) initWithTouch:(UITouch *)touch view:(UIView*)view_ {
    self = [super init];
    if (nil != self) {
        _timestamp = [touch timestamp];
        _phase = [touch phase];
        _tapCount = [touch tapCount];
        _window = view_.window;
        _view = view_;
        _gestureRecognizers = [NSMutableArray arrayWithArray:[touch gestureRecognizers]];
        _locationInWindow = [touch locationInView:view_.window];
        _previousLocationInWindow = [touch previousLocationInView:view_.window];
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _touchFlags._isWarped = 0;
        _touchFlags._isDelayed = 0;
        _touchFlags._sentTouchesEnded = 0;
    }
    return self;
}

@end
