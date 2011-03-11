//
//  LibcatPresentationAppDelegate.h
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 09/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibcatPresentationAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

