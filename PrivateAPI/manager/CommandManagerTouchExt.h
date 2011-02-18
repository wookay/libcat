//
//  CommandManagerTouchExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 04/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandManager.h"


typedef enum {
	kEventsArgNone,
	kEventsArgRecord,
	kEventsArgPlay,
	kEventsArgCut,
	kEventsArgClear,
	kEventsArgReplay,
	kEventsArgSave,
	kEventsArgLoad,
} kEventsArg;

@interface CommandManager (TouchExt)
-(NSString*) processEvents:(kEventsArg)eventsArg action:(NSString*)action events:(NSArray*)events ;
@end

@interface NSString (Base64Ext)
- (NSData *) decode_base64  ;
@end

@interface NSData (Base64Ext)
- (NSString*) encode_base64 ;
@end
