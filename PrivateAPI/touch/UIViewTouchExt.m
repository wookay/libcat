//
//  UIViewTouchExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIViewTouchExt.h"
#import "UITouchExt.h"
#import "UIEventExt.h"

@implementation UIView (TouchExt)

-(UIEvent*) tapEventAtPoint:(CGPoint)point {
	UITouch* began = [UITouch touchWithPoint:point view:self phase:UITouchPhaseBegan];
	UITouch* ended = [UITouch touchWithPoint:point view:self phase:UITouchPhaseEnded];
	UIEvent* event = [[[UIEvent alloc] performSelector:@selector(initWithTouches:) withObject:[NSSet setWithObjects:began, ended, nil]] autorelease];
	return event;
}

@end