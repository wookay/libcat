//
//  MacAppAppDelegate.m
//  MacApp
//
//  Created by WooKyoung Noh on 06/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "MacAppAppDelegate.h"
#import "ConsoleManager.h"

@implementation MacAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	[CONSOLEMAN start_servers];
	
}

@end
