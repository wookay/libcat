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


@implementation TabBarAppDelegate

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	log_info(@"openURL %@ %@ %@", url, sourceApplication, annotation);
	[CONSOLEMAN start_up:8082];
	return true;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [window addSubview:tabBarController.view];
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
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

