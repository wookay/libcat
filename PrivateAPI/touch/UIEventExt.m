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
#import "UIViewFlick.h"
#import "NSArrayExt.h"
#import "Logger.h"
#import "Numero.h"
#import "GeometryExt.h"

#if USE_PRIVATE_API
@interface UIApplication (Recoder)
-(void) _addRecorder:(id<UIEventRecorder>)recoder ;
-(void) _removeRecorder:(id<UIEventRecorder>)recoder ;
-(void) _playbackEvents:(NSArray*)events atPlaybackRate:(float)playbackRate messageWhenDone:(id)target withSelector:(SEL)action ;
@end
@interface UIEvent (Synthesize)
-(id) _initWithEvent:(id)event touches:(NSSet*)touches;
@end
#endif

@implementation EventRecorder
@synthesize recorded;
@synthesize userEvents;

-(void) recordApplicationEvent:(NSDictionary*)eventDict {
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:eventDict];	
	NSDictionary* location = [eventDict objectForKey:@"Location"];
	CGPoint point = CGPointMake([[location objectForKey:@"X"] floatValue], [[location objectForKey:@"Y"] floatValue]);	
	UITouch* touch = [UITouch touchWithPoint:point view:[UIApplication sharedApplication].keyWindow];
	UIEvent* event = [[UIEvent alloc] initWithTouch:touch];
	UIView* view = [[UIApplication sharedApplication].keyWindow hitTest:point withEvent:event];
	[dict setObject:NSStringFromClass([view class]) forKey:@"viewClass"];
	[userEvents addObject:dict];
}

-(NSString*) toggleRecordUserEvents {
	recorded = ! recorded;
	
#if USE_PRIVATE_API
	if (recorded) {
		[[UIApplication sharedApplication] _addRecorder:self];
		[[UIApplication sharedApplication].keyWindow flick];
	} else {
		[[UIApplication sharedApplication] _removeRecorder:self];
	}
#endif
	
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
	// log_info(@"doneReplayEvents %@", detail);
}

-(NSString*) replayUserEvents:(NSArray*)events {
#if USE_PRIVATE_API
	float playbackRate = 1;
	[[UIApplication sharedApplication] _playbackEvents:events atPlaybackRate:playbackRate messageWhenDone:self withSelector:@selector(doneReplayEvents:)];
#endif
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
//		NSData* data = [eventDict objectForKey:@"Data"];
//		switch (data.length) {
//			case 60:
//				break;
//			case 84:
//				break;
//			default:
//				break;
//		}

		NSDictionary* location = [eventDict objectForKey:@"Location"];
		[ary addObject:SWF(@"%d\t%@\t{%@, %@}\t%@",
						   idx,
						   [eventDict objectForKey:@"Time"],
						   [location objectForKey:@"X"],
						   [location objectForKey:@"Y"],
						   [eventDict objectForKey:@"viewClass"]
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

-(id) initWithTouch:(UITouch*)touch {
#if USE_PRIVATE_API
    Class touchesEventClass = objc_getClass("UITouchesEvent");
    if (touchesEventClass && ![[self class] isEqual:touchesEventClass]) {
        [self release];
        self = [touchesEventClass alloc];
    }
    
    self = [self _initWithEvent:[NSNull null] touches:[NSSet setWithObject:touch]];
    if (nil != self) {
    }
#else
	self = [super init];
#endif
    return self;
}

@end