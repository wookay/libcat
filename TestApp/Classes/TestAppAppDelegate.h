//
//  TestAppAppDelegate.h
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TestAppAppDelegate : AppDelegate {
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

