//
//  TestAppAppDelegate.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "TestAppAppDelegate.h"

@implementation TestAppAppDelegate

@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [window addSubview:navigationController.view];
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)dealloc {	
	[navigationController release];
	[super dealloc];
}


@end

