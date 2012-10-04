//
//  TabBarAppDelegate.m
//  TabBarApp
//
//  Created by wookyoung noh on 10/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TabBarAppDelegate.h"
#import "ConsoleManager.h"
#import "Logger.h"
#import "UnitTest.h"

@implementation TabBarAppDelegate

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSString* password = [url resourceSpecifier];
	log_info(@"openURL url:%@ password:%@ sourceApplication:%@ annotation:%@", url, password, sourceApplication, annotation);
	
#define STR_PASSWORD @"8082"
	if ([password isEqualToString:STR_PASSWORD]) {
		[ConsoleManager run:8082];
		return true;
	}
	return false;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL didFinishLaunchingWithOptions = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    //#if TARGET_IPHONE_SIMULATOR
    [UnitTest run];
    //#endif
    
    [window setRootViewController:tabBarController];
    
    //#if TARGET_IPHONE_SIMULATOR
    [ConsoleManager run];
    //#endif
    
    return didFinishLaunchingWithOptions;
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */




- (void)dealloc {
    [tabBarController release];
    [super dealloc];
}

@end

