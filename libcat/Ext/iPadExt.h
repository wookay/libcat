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
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// screen frame
#define SCREEN_WIDTH (IS_IPAD ? 768 : 320)
#define SCREEN_HEIGHT (IS_IPAD ? 1024 : 480)
#define SCREEN_FRAME CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
#define HALF_SCREEN_WIDTH (SCREEN_WIDTH/2)
#define HALF_SCREEN_HEIGHT (SCREEN_HEIGHT/2)



#ifdef BUILD_313
	#import "Build313Ext.h"
#endif