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
#import "UITouchExt.h"
#import "UIEventExt.h"
#import "UIViewExt.h"
#import "NSDictionaryExt.h"
#import "iPadExt.h"
#import "Numero.h"
#import "UITouchExt.h"
#import "CommandManager.h"
#import "ConsoleManager.h"
#import "NSArrayExt.h"
#import "NSDataExt.h"


@implementation HitTestWindow
@synthesize hitTestMode;
@synthesize realWindow;
@synthesize userEvents;
@synthesize hitTestDelegate;

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([realWindow isEqual:self]) {
		return self;
	} else {
		UIView* view = [realWindow hitTest:point withEvent:event];
		switch (hitTestMode) {
			case kHitTestModeHitTestView: {
					if ([view isEqual:CONSOLEMAN.currentTargetObject]) {
					} else {
						if (nil != hitTestDelegate) {
							[hitTestDelegate touchedHitTestView:view];
						}					
						CONSOLEMAN.currentTargetObject = view;	
					}
					[view flick];
					return self;
				}
				break;
		}
		return view;
	}
}

-(NSString*) enterHitTestMode:(kHitTestMode)hitTestArg {	
	if (kHitTestModeHitTestView == hitTestArg && kHitTestModeHitTestView == hitTestMode) {
		hitTestMode = kHitTestModeNone;
		if (nil != self.realWindow) {
			[self.realWindow makeKeyAndVisible];
		}
		return NSLocalizedString(@"hitTest off", nil);		
	} else {
		hitTestMode = hitTestArg;
		if (kHitTestModeNone == hitTestMode) {
			if (nil != self.realWindow) {
				[self.realWindow makeKeyAndVisible];
			}			
		} else {
			UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
			if ([self isEqual:keyWindow]) {
			} else {
				self.realWindow = keyWindow;
				self.hitTestDelegate = COMMANDMAN;
			}
			[self makeKeyAndVisible];
			[self flick];			
		}
		switch (hitTestMode) {
			case kHitTestModeHitTestView:
				return NSLocalizedString(@"hitTest on", nil);
				break;
			default:
				break;
		}
		return NSLocalizedString(@"None", nil);
	}
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
		self.frame = SCREEN_FRAME;
		self.hitTestMode = kHitTestModeNone;
		self.realWindow = nil;
		self.userEvents = [NSMutableArray array];
		self.hitTestDelegate = nil;
	}
	return self;
}

- (void) dealloc {
	hitTestDelegate = nil;
	realWindow = nil;
	[userEvents release];
	[super dealloc];
}

@end
