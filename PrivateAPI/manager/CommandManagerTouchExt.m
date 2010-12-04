//
//  CommandManagerTouchExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 04/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "CommandManagerTouchExt.h"
#import "HitTestWindow.h"
#import "Logger.h"

@implementation CommandManager (TouchExt)

#define HIT_TEST_OFF	@"off"

-(NSString*) command_hitTest:(id)currentObject arg:(id)arg {
	UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
	HitTestWindow* hitTestWindow = [HitTestWindow sharedWindow];
	if ([HIT_TEST_OFF isEqualToString:arg]) {
		if ([keyWindow isEqual:hitTestWindow]) {
			[hitTestWindow.realWindow makeKeyAndVisible];
			return NSLocalizedString(@"off", nil);
		} else {
			return NSLocalizedString(@"Not Found", nil);
		}
	} else {	
		if (! [keyWindow isEqual:hitTestWindow]) {
#if USE_PRIVATE_API
			hitTestWindow.hitTestDelegate = self;
#endif
			hitTestWindow.realWindow = keyWindow;
			[hitTestWindow makeKeyAndVisible];
			[self flickTargetView:hitTestWindow];
		}
		return NSLocalizedString(@"true", nil);
	}
}

@end
