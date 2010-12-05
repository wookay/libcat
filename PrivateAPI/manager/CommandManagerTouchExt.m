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
#if USE_PRIVATE_API
		if (! [keyWindow isEqual:hitTestWindow]) {
			hitTestWindow.hitTestDelegate = self;
			hitTestWindow.realWindow = keyWindow;
			[hitTestWindow makeKeyAndVisible];
			[self flickTargetView:hitTestWindow];
		}
		return NSLocalizedString(@"true", nil);
#else
		return NSLocalizedString(@"Add USE_PRIVATE_API=1 to Preprocessor Macros", nil);
#endif
	}
}

@end
