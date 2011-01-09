//
//  MacAppAppDelegate.h
//  MacApp
//
//  Created by WooKyoung Noh on 06/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MacAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
