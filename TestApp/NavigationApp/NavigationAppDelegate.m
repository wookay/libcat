//
//  NavigationAppDelegate.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NavigationAppDelegate.h"
#import "ConsoleManager.h"
#import "Logger.h"
#import "UnitTest.h"

@implementation NavigationAppDelegate

@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSString* password = [url resourceSpecifier];
	log_info(@"openURL url:%@ password:%@ sourceApplication:%@ annotation:%@", url, password, sourceApplication, annotation);

#define STR_PASSWORD @"8081"
	if ([password isEqualToString:STR_PASSWORD]) {
		[ConsoleManager run:8081];
		return true;
	}
	return false;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL didFinishLaunchingWithOptions = [super application:application didFinishLaunchingWithOptions:launchOptions];

    //#if TARGET_IPHONE_SIMULATOR
    [UnitTest run];
    //#endif

    [window setRootViewController:navigationController];

    //#if TARGET_IPHONE_SIMULATOR
    [ConsoleManager run];
    //#endif

    return didFinishLaunchingWithOptions;
}

- (void)dealloc {	
	[navigationController release];
	[super dealloc];
}


@end

