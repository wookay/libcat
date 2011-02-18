//
//  UIEventExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EVENTRECORDER [EventRecorder sharedRecorder]

@protocol UIEventRecorder
-(void)recordApplicationEvent:(NSDictionary*)event ;
@end

@interface EventRecorder : NSObject <UIEventRecorder> {
	NSMutableArray* userEvents;
	BOOL recorded;
}
@property (nonatomic) 	BOOL recorded;
@property (nonatomic, retain)	NSMutableArray* userEvents;

+(EventRecorder*) sharedRecorder ;
-(NSString*) toggleRecordUserEvents ;
-(NSString*) playUserEvents ;
-(NSString*) replayUserEvents:(NSArray*)events ;
-(NSString*) cutUserEvents:(NSArray*)frames ;
-(NSData*) saveUserEvents ;
-(NSArray*) loadUserEvents:(NSData*)data ;
-(void) addUserEvents:(NSArray*)events ;
-(void) clearUserEvents ;
-(NSString*) reportUserEvents ;
@end




@interface UIEvent (Ext)

-(NSDictionary*) to_dict ;
-(id) initWithTouch:(UITouch*)touch ;

@end