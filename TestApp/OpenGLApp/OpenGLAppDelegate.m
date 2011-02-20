//
//  OpenGLAppDelegate.m
//  OpenGL
//
//  Created by WooKyoung Noh on 03/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "OpenGLAppDelegate.h"
#import "OpenGLViewController.h"
#import "ConsoleManager.h"
#import "Logger.h"

@implementation OpenGLAppDelegate

@synthesize viewController;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	log_info(@"openURL %@ %@ %@", url, sourceApplication, annotation);
	[CONSOLEMAN start_up:8083];
	return true;
}

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.viewController.view.backgroundColor = [UIColor colorWithRed:0.470588235294118f green:0.364705882352941f blue:0.862745098039216f alpha:1];
    [self.window addSubview:self.viewController.view];
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void) applicationWillResignActive:(UIApplication *)application {
    [self.viewController stopAnimation];
}

-(void) applicationDidBecomeActive:(UIApplication *)application {
    [self.viewController startAnimation];
}

-(void) applicationWillTerminate:(UIApplication *)application {
    [self.viewController stopAnimation];
}

-(void) applicationDidEnterBackground:(UIApplication *)application {
    // Handle any background procedures not related to animation here.
}

-(void) applicationWillEnterForeground:(UIApplication *)application {
    // Handle any foreground procedures not related to animation here.
}

-(void) dealloc {
    [viewController release];    
    [super dealloc];
}

@end