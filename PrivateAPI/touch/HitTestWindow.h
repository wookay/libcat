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
	kHitTestModeRecordEvents,
} kHitTestMode;

@protocol HitTestDelegate;

@interface HitTestWindow : UIWindow {
	kHitTestMode hitTestMode;
	UIWindow* realWindow;
	NSMutableArray* userEvents;
	id<HitTestDelegate> hitTestDelegate;
}
@property (nonatomic) kHitTestMode hitTestMode;
@property (nonatomic, retain)	UIWindow* realWindow;
@property (nonatomic, retain)	NSMutableArray* userEvents;
@property (nonatomic, assign) 	id<HitTestDelegate> hitTestDelegate;

+(HitTestWindow*) sharedWindow ;
-(void) sendEventWithTouchDict:(NSDictionary*)dict ;
-(void) sendEventWithAllTouchesDict:(NSArray*)allTouches ;
-(void) sendEvent:(UIEvent *)event recordUserEvents:(BOOL)recordUserEvents ;
-(void) replayUserEvents:(NSArray*)events ;
-(NSData*) saveUserEvents ;
-(NSArray*) loadUserEvents:(NSData*)data ;
-(void) clearUserEvents ;
-(NSString*) reportUserEvents ;
-(NSString*) enterHitTestMode:(kHitTestMode)hitTestArg ;
@end
