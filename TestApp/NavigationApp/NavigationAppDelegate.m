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

@implementation NavigationAppDelegate

@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	log_info(@"openURL %@ %@ %@", url, sourceApplication, annotation);
	[CONSOLEMAN start_up:8081];
	return true;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [window addSubview:navigationController.view];
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)dealloc {	
	[navigationController release];
	[super dealloc];
}


@end

