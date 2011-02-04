//
//  HitTestWindow.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
	kHitTestModeNone,
	kHitTestModeHitTestView,
} kHitTestMode;

@protocol HitTestDelegate;

@interface HitTestWindow : UIWindow {
	kHitTestMode hitTestMode;
	UIWindow* realWindow;
	id<HitTestDelegate> hitTestDelegate;
}
@property (nonatomic) kHitTestMode hitTestMode;
@property (nonatomic, retain)	UIWindow* realWindow;
@property (nonatomic, retain)	NSMutableArray* userEvents;
@property (nonatomic, assign) 	id<HitTestDelegate> hitTestDelegate;

+(HitTestWindow*) sharedWindow ;
-(NSString*) enterHitTestMode:(kHitTestMode)hitTestArg ;
@end
