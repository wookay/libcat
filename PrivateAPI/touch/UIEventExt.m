//
//  UIEventExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIEventExt.h"
#import "UITouchExt.h"
#import "NSDictionaryExt.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Logger.h"
#import "Numero.h"

#if USE_PRIVATE_API
@interface UIApplication (Recoder)
-(void) _addRecorder:(id<UIEventRecorder>)recoder ;
-(void) _removeRecorder:(id<UIEventRecorder>)recoder ;
-(void) _playbackEvents:(NSArray*)events atPlaybackRate:(float)playbackRate messageWhenDone:(id)target withSelector:(SEL)action ;
@end
#endif

@implementation EventRecorder
@synthesize recorded;
@synthesize userEvents;
-(void) recordApplicationEvent:(NSDictionary*)event {
	[userEvents addObject:event];
}

-(NSString*) recordUserEvents {
	recorded = ! recorded;
	
	if (recorded) {
		[[UIApplication sharedApplication] _addRecorder:self];
	} else {
		[[UIApplication sharedApplication] _removeRecorder:self];
	}
	
	return recorded ? NSLocalizedString(@"record on", nil) : NSLocalizedString(@"record off", nil);
}

-(NSString*) playUserEvents {
	[self replayUserEvents:userEvents];
	return SWF(@"play %d events", userEvents.count);
}

-(NSString*) cutUserEvents:(NSArray*)frames {
	NSMutableIndexSet* indexes = [NSMutableIndexSet indexSet];
	for (NSNumber* num in frames) {
		[indexes addIndex:[num unsignedIntValue]];
	}
	[userEvents removeObjectsAtIndexes:indexes];
	return SWF(@"cut %d frames", frames.count);
}

-(void) doneReplayEvents:(NSDictionary*)detail {
	log_info(@"doneReplayEvents %@", detail);
}

-(NSString*) replayUserEvents:(NSArray*)events {
	float playbackRate = 1;
	[[UIApplication sharedApplication] _playbackEvents:events atPlaybackRate:playbackRate messageWhenDone:self withSelector:@selector(doneReplayEvents:)];
	return SWF(@"replay %d events", events.count);
}

-(NSData*) saveUserEvents {
	NSData* data = [NSPropertyListSerialization dataWithPropertyList:userEvents format: NSPropertyListBinaryFormat_v1_0 options:NSPropertyListImmutable error:nil];
	return data;
}

-(void) addUserEvents:(NSArray*)events {
	[userEvents addObjectsFromArray:events];
}

-(NSArray*) loadUserEvents:(NSData*)data {
	NSInputStream* inputStream = [NSInputStream inputStreamWithData:data];
	[inputStream open];
	NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
	NSArray* events = [NSPropertyListSerialization propertyListWithStream:inputStream options:NSPropertyListImmutable format:&format error:nil];
	[inputStream close];
	return events;
}

-(void) clearUserEvents {
	[userEvents removeAllObjects];
}

-(NSString*) reportUserEvents {
	NSMutableArray* ary = [NSMutableArray array];
	int idx = 0;
	for (NSDictionary* eventDict in userEvents) {
		log_info(@"eventDict %@", eventDict);
		NSDictionary* location = [eventDict objectForKey:@"Location"];
		[ary addObject:SWF(@"%d\t%@\t{%@, %@}",
						   idx,
						   [eventDict objectForKey:@"Time"],
						   [location objectForKey:@"X"],
						   [location objectForKey:@"Y"]
						   )];
		idx += 1;
	}
	if (0 == ary.count) {
		return NSLocalizedString(@"no events", nil);
	} else {
		return [ary join:LF];
	}
}

+(EventRecorder*) sharedRecorder {
	static EventRecorder* recorder = nil;
	if (! recorder) {
		recorder = [EventRecorder new];
	}
	return recorder;
}

-(id) init {
	self = [super init];
	if (self) {
		self.userEvents = [[NSMutableArray alloc] init];
		self.recorded = NO;
	}
	return self;
}

-(void)dealloc {
	[userEvents release];
	[super dealloc];
}
@end



@implementation UIEvent (Ext)

-(NSDictionary*) to_dict {
	NSMutableArray* allTouches = [NSMutableArray array];
	UIView* touchView = nil;
	for (UITouch* touch in [self allTouches]) {
		if (nil != touch.view) {
			touchView = touch.view;
			break;
		}
	}
	for (UITouch* touch in [self allTouches]) {
		[allTouches addObject:[touch to_dict:touchView]];
	}	
	NSDictionary* dict = [NSDictionary dictionaryWithKeysAndObjects:
						  @"timestamp", [NSNumber numberWithDouble:self.timestamp],
						  @"allTouches", [NSArray arrayWithArray:allTouches],
						  nil];
	return dict;
}

@end