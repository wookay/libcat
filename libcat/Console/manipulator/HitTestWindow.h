//
//  HitTestWindow.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
	kDragModeOff,
    kDragModeOn,
    kDragModeHitTestOnce,
} kDragMode;

//@protocol HitTestDelegate;

@interface HitTestWindow : UIWindow {
	kDragMode dragMode;
	UIWindow* realWindow;
    UIView* selectedView;
    UIView* targetView;
//	id<HitTestDelegate> hitTestDelegate;
}
@property (nonatomic) kDragMode dragMode;
@property (nonatomic, retain)	UIWindow* realWindow;
@property (nonatomic, assign)	UIView* selectedView;
@property (nonatomic, assign)	UIView* targetView;
//@property (nonatomic, assign) 	id<HitTestDelegate> hitTestDelegate;

+(HitTestWindow*) sharedWindow ;
-(NSString*) dragView:(id)targetView ;

@end
