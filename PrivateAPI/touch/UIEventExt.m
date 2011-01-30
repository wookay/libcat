//
//  UIEventExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIEventExt.h"
#import "UITouchExt.h"
#import "NSDictionaryExt.h"
#import "NSStringExt.h"

@implementation UIEvent (Ext)

-(NSDictionary*) to_dict {
	NSMutableArray* allTouches = [NSMutableArray array];
	UIView* touchView = nil;
	for (UITouch* touch in [self allTouches]) {
		if (nil != touch.view) {
			touchView = touch.view;
			break;
		}
	}
	for (UITouch* touch in [self allTouches]) {
		[allTouches addObject:[touch to_dict:touchView]];
	}	
	NSDictionary* dict = [NSDictionary dictionaryWithKeysAndObjects:
						  @"timestamp", [NSNumber numberWithDouble:self.timestamp],
						  @"allTouches", [NSArray arrayWithArray:allTouches],
						  nil];
	return dict;
}

-(id) initWithTouches:(NSSet*)touches {
#if USE_PRIVATE_API
    Class UITouchesEventClass = objc_getClass("UITouchesEvent");
    if (! [self isKindOfClass:UITouchesEventClass]) {
        [self release];
        self = [UITouchesEventClass alloc];
    }
	
    return [self performSelector:@selector(_initWithEvent:touches:) withObject:[NSNull null] withObject:touches];
#else
	return nil;
#endif
}

@end
