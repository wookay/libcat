//
//  TabBarAppAppDelegate.m
//  TabBarApp
//
//  Created by wookyoung noh on 10/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TabBarAppAppDelegate.h"


@implementation TabBarAppAppDelegate

@synthesize tabBarController;

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

