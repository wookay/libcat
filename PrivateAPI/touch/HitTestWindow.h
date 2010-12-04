//
//  HitTestWindow.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HitTestDelegate;

@interface HitTestWindow : UIWindow {
	UIWindow* realWindow;
	id<HitTestDelegate> hitTestDelegate;
}
@property (nonatomic, retain)	UIWindow* realWindow;
@property (nonatomic, retain)	id<HitTestDelegate> hitTestDelegate;

+(HitTestWindow*) sharedWindow ;
@end
