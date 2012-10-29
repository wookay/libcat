//
//  HitTestWindow.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "HitTestWindow.h"
#import "GeometryExt.h"
#import "NSStringExt.h"
#import "Logger.h"
#import "UIViewFlick.h"
#import "NSDictionaryExt.h"
#import "iPadExt.h"
#import "Numero.h"
#import "CommandManager.h"
#import "ConsoleManager.h"
#import "NSArrayExt.h"
#import "NSDataExt.h"
#import "PropertyManipulator.h"

@implementation HitTestWindow
@synthesize dragMode;
@synthesize realWindow;
@synthesize selectedView;
@synthesize targetView;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (nil == targetView) {
        [selectedView flick];
    } else {
        [targetView flick];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    if (nil == targetView) {
        CGRect rect = selectedView.frame;
        rect.origin = CGPointOffset(rect.origin, location.x - previousLocation.x, location.y - previousLocation.y);
        selectedView.frame = rect;
    } else {
        CGRect rect = targetView.frame;
        rect.origin = CGPointOffset(rect.origin, location.x - previousLocation.x, location.y - previousLocation.y);
        targetView.frame = rect;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (nil == targetView) {
        [selectedView flick];
    } else {
        [targetView flick];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(NSString*) dragView:(id)targetView_ {
    if (kDragModeOff == dragMode) {
        dragMode = kDragModeOn;
        realWindow = [UIApplication sharedApplication].keyWindow;
        selectedView = nil;
        targetView = targetView_;
        [self makeKeyAndVisible];
        if (nil == targetView) {
            [self flick];
        } else {
            [targetView flick];
        }
        return @"drag on";
    } else {
        if (nil == targetView_) {
            dragMode = kDragModeOff;
            [realWindow makeKeyAndVisible];
            realWindow = nil;
            selectedView = nil;
            targetView = nil;
            return @"drag off";
        } else {
            targetView = targetView_;
            [targetView flick];
        }
    }
    return SWF(@"drag %@", targetView);
}

-(void) hitTestOnce {
    dragMode = kDragModeHitTestOnce;
    realWindow = [UIApplication sharedApplication].keyWindow;
    selectedView = nil;
    targetView = nil;
    [self makeKeyAndVisible];
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([realWindow isEqual:self]) {
		return self;
	}
	UIView* view = [realWindow hitTest:point withEvent:event];
    if (nil == view) {
    } else {
        if (kDragModeHitTestOnce == dragMode) {
            CONSOLEMAN.currentTargetObject = view;
            [view flick];
            dragMode = kDragModeOff;
            [realWindow makeKeyAndVisible];
            realWindow = nil;
            selectedView = nil;
            targetView = nil;
            [PROPERTYMAN manipulate:view];
            return self;
        }
        selectedView = view;
    }
    return self;
}

+(HitTestWindow*) sharedWindow {
	static HitTestWindow*	manager = nil;
	if (!manager) {
		manager = [HitTestWindow new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
        self.userInteractionEnabled = true;
		self.frame = SCREEN_FRAME;
		self.dragMode = kDragModeOff;
		self.realWindow = nil;
        self.selectedView = nil;
        self.targetView = nil;
	}
	return self;
}

- (void) dealloc {
    selectedView = nil;
    targetView = nil;
    realWindow = nil;
	[super dealloc];
}

@end
