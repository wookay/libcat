//
//  HitTestWindow.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "HitTestWindow.h"
#import "GeometryExt.h"
#import "Logger.h"
#import "UITouchExt.h"
#import "UIEventExt.h"
#import "iPadExt.h"

@implementation HitTestWindow
@synthesize realWindow;
@synthesize hitTestDelegate;

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
		self.realWindow = nil;
		self.hitTestDelegate = nil;
		self.frame = SCREEN_FRAME;
	}
	return self;
}

- (void) dealloc {
	realWindow = nil;
	hitTestDelegate = nil;
	[super dealloc];
}

- (void) sendEvent:(UIEvent *)event {
	if (nil != realWindow) {
		NSMutableSet* realTouches = [NSMutableSet set];
		for (UITouch* touch in [event allTouches]) {
			CGPoint point = [touch locationInView:self];
			UIView* view = [realWindow hitTest:point withEvent:event];
			UITouch* realTouch = [[UITouch alloc] initWithTouch:touch view:view];
			[realTouches addObject:realTouch];
		}
		UIEvent* realEvent = [[UIEvent alloc] initWithTouches:realTouches];
		[realWindow sendEvent:realEvent];
		if (nil != hitTestDelegate) {
			[hitTestDelegate hitTestSentEvent:realEvent];
		}		
		[realEvent release];
	}
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	return self;
}

@end
