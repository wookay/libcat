//
//  iPadExt.h
//  BigCalendar
//
//  Created by Woo-Kyoung Noh on 30/07/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#if USE_COCOA
#else
	#import <UIKit/UIDevice.h>
#endif

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_RETINA ( \
    [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && \
    [UIScreen mainScreen].scale == 2.0 \
)
#define IS_IPHONE5 (568 == SCREEN_HEIGHT)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// screen frame
#define SCREEN_FRAME [UIScreen mainScreen].bounds
#define SCREEN_WIDTH (SCREEN_FRAME.size.width)
#define SCREEN_HEIGHT (SCREEN_FRAME.size.height)
#define HALF_SCREEN_WIDTH (SCREEN_WIDTH/2)
#define HALF_SCREEN_HEIGHT (SCREEN_HEIGHT/2)



#ifdef BUILD_313
	#import "Build313Ext.h"
#endif