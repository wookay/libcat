//
//  TabBarAppDelegate.h
//  TabBarApp
//
//  Created by wookyoung noh on 10/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TabBarAppDelegate : AppDelegate <UITabBarControllerDelegate> {
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
