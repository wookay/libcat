//
//  OpenGLAppDelegate.h
//  OpenGL
//
//  Created by WooKyoung Noh on 03/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class OpenGLViewController;

@interface OpenGLAppDelegate : AppDelegate <UIApplicationDelegate> {
    OpenGLViewController *viewController;
}

@property (nonatomic, retain) IBOutlet OpenGLViewController *viewController;

@end