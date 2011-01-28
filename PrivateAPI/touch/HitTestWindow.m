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


-(void) sendEventWithAllTouchesDict:(NSArray*)allTouches {
	for (NSDictionary* dict in allTouches) {
		[self sendEventWithTouchDict:dict];
	}
}

-(void) sendEventWithTouchDict:(NSDictionary*)dict {
	NSArray* phases = [@"UITouchPhaseBegan UITouchPhaseMoved UITouchPhaseStationary UITouchPhaseEnded UITouchPhaseCancelled" split];
	NSTimeInterval timestamp = [[dict objectForKey:@"timestamp"] doubleValue];
	UITouchPhase phase = [phases indexOfObject:[dict objectForKey:@"phase"]];
	NSUInteger tapCount = [[dict objectForKey:@"tapCount"] unsignedIntValue];
	CGPoint locationInWindow = CGPointFromString([dict objectForKey:@"locationInWindow"]);
	UIWindow* targetWindow;
	if (nil == realWindow) {
		targetWindow = [UIApplication sharedApplication].keyWindow;
	} else {
		targetWindow = realWindow;
	}
	if (nil != targetWindow) {
		UITouch* hitTouch = [[UITouch alloc] initWithPoint:locationInWindow view:targetWindow timestamp:timestamp phase:phase tapCount:tapCount];
		UIEvent* hitEvent = [[UIEvent alloc] initWithTouches:[NSSet setWithObject:hitTouch]];
		UIView* view = [targetWindow hitTest:locationInWindow withEvent:hitEvent];
		UITouch* touch = [[UITouch alloc] initWithPoint:locationInWindow view:view timestamp:timestamp phase:phase tapCount:tapCount];
		UIEvent* event = [[UIEvent alloc] initWithTouches:[NSSet setWithObject:touch]];
		[self sendEvent:event recordUserEvents:false];
		[event release];
		[hitEvent release];
	}
}

- (void) sendEvent:(UIEvent *)event {
	switch (hitTestMode) {
		case kHitTestModeRecordEvents:
			[self sendEvent:event recordUserEvents:true];
			break;
		
		case kHitTestModeHitTestView:
			break;
			
		default:
			break;
	}
}

-(void) sendEvent:(UIEvent *)event recordUserEvents:(BOOL)recordUserEvents {
	UIWindow* targetWindow;
	if (nil == realWindow) {
		targetWindow = [UIApplication sharedApplication].keyWindow;
	} else {
		targetWindow = realWindow;
	}	
	if (nil != targetWindow) {
		NSMutableSet* realTouches = [NSMutableSet set];
		for (UITouch* touch in [event allTouches]) {
			CGPoint point = [touch locationInView:targetWindow];
			UIView* view = [targetWindow hitTest:point withEvent:event];
			UITouch* realTouch = [[UITouch alloc] initWithTouch:touch view:view];
			[realTouches addObject:realTouch];
		}
		if (recordUserEvents) {
			[userEvents addObject:[event to_dict]];
		}		
		UIEvent* realEvent = [[UIEvent alloc] initWithTouches:realTouches];
		[targetWindow sendEvent:realEvent];
		[realEvent release];
	}
}

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
				}
				break;
		}
		return view;
	}
}


#pragma mark events
-(void) replayUserEvents:(NSArray*)events {
	NSTimeInterval currentTimestamp = CERO;
	for (NSDictionary* dict in [NSArray arrayWithArray:events]) {
		NSTimeInterval timestamp = [[dict objectForKey:@"timestamp"] doubleValue];
		NSArray* allTouches = [dict objectForKey:@"allTouches"];
		NSTimeInterval interval = CERO;
		if (CERO == currentTimestamp) {
			currentTimestamp = timestamp;
		} else {
			interval = timestamp - currentTimestamp;
		}
		[self performSelector:@selector(sendEventWithAllTouchesDict:) withObject:allTouches afterDelay:interval];
	}
}

-(NSData*) saveUserEvents {
	NSData* data = [NSPropertyListSerialization dataWithPropertyList:userEvents format: NSPropertyListBinaryFormat_v1_0 options:NSPropertyListImmutable error:nil];
	return data;
}

-(NSArray*) loadUserEvents:(NSData*)data {
	NSInputStream* inputStream = [NSInputStream inputStreamWithData:data];
	[inputStream open];
	NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
	NSArray* events = [NSPropertyListSerialization propertyListWithStream:inputStream options:NSPropertyListImmutable format:&format error:nil];
	[inputStream close];
	return events;
}

-(void) clearUserEvents {
	[userEvents removeAllObjects];
}

-(NSString*) reportUserEvents {
	NSMutableArray* ary = [NSMutableArray array];
	for (NSDictionary* eventDict in userEvents) {
		NSMutableArray* touches = [NSMutableArray array];
		for (NSDictionary* touchDict in [eventDict objectForKey:@"allTouches"]) {
			[touches addObject:SWF(@"{ %@\t%@\t%@ }",
											   [touchDict objectForKey:@"phase"], 
											   [touchDict objectForKey:@"locationInView"],
											   [touchDict objectForKey:@"viewClass"]
								   )];

		}
		[ary addObject:SWF(@"%g\t[%@]", [[eventDict objectForKey:@"timestamp"] doubleValue], [touches join:COMMA_SPACE])];	
	}
	return [ary join:LF];
}

-(NSString*) enterHitTestMode:(kHitTestMode)hitTestArg {
#if USE_PRIVATE_API
#else
	return NSLocalizedString(@"Add USE_PRIVATE_API=1 to Preprocessor Macros", nil);
#endif
	
	if (kHitTestModeRecordEvents == hitTestArg && kHitTestModeRecordEvents == hitTestMode) {
		hitTestMode = kHitTestModeNone;
		if (nil != self.realWindow) {
			[self.realWindow makeKeyAndVisible];
		}
		return NSLocalizedString(@"record off", nil);
	} else if (kHitTestModeHitTestView == hitTestArg && kHitTestModeHitTestView == hitTestMode) {
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
			case kHitTestModeRecordEvents:
				return NSLocalizedString(@"record on", nil);
				break;
			default:
				break;
		}
		return NSLocalizedString(@"None", nil);
	}
}

@end
