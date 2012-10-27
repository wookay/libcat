//
//  UITouchExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UITouchExt.h"
#import "NSDictionaryExt.h"
#import "NSStringExt.h"
#import "GeometryExt.h"
#import "Logger.h"

@implementation UITouch (Ext)

-(NSDictionary*) to_dict:(UIView*)touchView {
	NSArray* phases = [@"UITouchPhaseBegan UITouchPhaseMoved UITouchPhaseStationary UITouchPhaseEnded UITouchPhaseCancelled" split];
	NSDictionary* dict = [NSDictionary dictionaryWithKeysAndObjects:
						  @"timestamp", [NSNumber numberWithDouble:self.timestamp],
						  @"phase", [phases objectAtIndex:self.phase],
						  @"tapCount", [NSNumber numberWithUnsignedInt:self.tapCount],
						  @"locationInView", SFPoint([self locationInView:touchView]),
						  @"previousLocationInView", SFPoint([self previousLocationInView:touchView]),
						  @"locationInWindow", SFPoint([self locationInView:self.window]),
						  @"viewClass", NSStringFromClass([touchView class]),
						  nil];
	return dict;
}

+(UITouch*) touchWithPoint:(CGPoint)point view:(UIView*)view_ {
	return [self touchWithPoint:point view:view_ phase:UITouchPhaseBegan];
}

+(UITouch*) touchWithPoint:(CGPoint)point view:(UIView*)view_ phase:(UITouchPhase)phase_ {
	NSTimeInterval timestamp_ = [NSDate timeIntervalSinceReferenceDate];
	NSUInteger tapCount_ = 1;	
	UITouch* touch = [[[UITouch alloc] initWithPoint:point view:view_ timestamp:timestamp_ phase:phase_ tapCount:tapCount_] autorelease];
	return touch;
}

-(id) initWithPoint:(CGPoint)point view:(UIView*)view_ timestamp:(NSTimeInterval)timestamp_ phase:(UITouchPhase)phase_ tapCount:(NSUInteger)tapCount_ {
    self = [super init];
    if (nil != self) {
#if USE_PRIVATE_API
    #ifndef __IPHONE_6_0
        _timestamp = timestamp_;
        _phase = phase_;
        _tapCount = tapCount_;
        _window = view_.window;
        _view = view_;
		_gestureView = view_;
        _gestureRecognizers = [NSMutableArray array];
        _locationInWindow = point;
        _previousLocationInWindow = point;
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _touchFlags._isDelayed = 0;
        _touchFlags._sentTouchesEnded = 0;
    #endif
#endif
    }
    return self;
}

-(id) initWithTouch:(UITouch *)touch view:(UIView*)view_ {
    self = [super init];
    if (nil != self) {
#if USE_PRIVATE_API
    #ifndef __IPHONE_6_0
        _timestamp = [touch timestamp];
        _phase = [touch phase];
		_savedPhase = [touch savedPhase];
        _tapCount = [touch tapCount];
        _window = view_.window;
        _view = view_;
		_gestureView = view_;
        _gestureRecognizers = [NSMutableArray arrayWithArray:[touch gestureRecognizers]];
        _locationInWindow = [touch locationInView:view_.window];
        _previousLocationInWindow = [touch previousLocationInView:view_.window];
		_pathIndex = touch.pathIndex;
		_pathIdentity = touch.pathIdentity;
		_pathMajorRadius = touch.pathMajorRadius;
        _touchFlags._firstTouchForView = touch.firstTouchForView;
        _touchFlags._isTap = touch.isTap;
        _touchFlags._isDelayed = touch.isDelayed;
        _touchFlags._sentTouchesEnded = touch.sentTouchesEnded;
    #endif
#endif
    }
    return self;
}

#if USE_PRIVATE_API
    #ifndef __IPHONE_6_0
-(UITouchPhase) savedPhase {
	return _savedPhase;
}
-(unsigned int) firstTouchForView {
	return _touchFlags._firstTouchForView;
}
-(unsigned int) isTap {
	return _touchFlags._isTap;
}
-(unsigned int) isDelayed {
	return _touchFlags._isDelayed;
}
-(unsigned int) sentTouchesEnded {
	return _touchFlags._sentTouchesEnded;
}
-(UInt8) pathIndex {
	return _pathIndex;
}
-(UInt8) pathIdentity {
	return _pathIdentity;
}
-(float) pathMajorRadius {
	return _pathMajorRadius;
}
    #endif
#endif


@end
