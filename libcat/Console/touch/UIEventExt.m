//
//  UIEventExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIEventExt.h"


@implementation UIEvent (Ext)

-(id) initWithTouches:(NSSet*)touches {
    Class UITouchesEventClass = objc_getClass("UITouchesEvent");
    if (! [self isKindOfClass:UITouchesEventClass]) {
        [self release];
        self = [UITouchesEventClass alloc];
    }
	
    return [self performSelector:@selector(_initWithEvent:touches:) withObject:[NSNull null] withObject:touches];
}

@end
