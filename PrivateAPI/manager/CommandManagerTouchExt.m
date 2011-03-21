//
//  CommandManagerTouchExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 04/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "CommandManagerTouchExt.h"
#import "Logger.h"
#import "NSNumberExt.h"
#import "NSDictionaryExt.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Inspect.h"
#import "UIEventExt.h"

@implementation CommandManager (TouchExt)






-(NSString*) processEvents:(kEventsArg)eventsArg action:(NSString*)action events:(NSArray*)events {	
	switch (eventsArg) {
		case kEventsArgRecord:
			return [EVENTRECORDER toggleRecordUserEvents];
			break;
			
		case kEventsArgPlay:
			return [EVENTRECORDER playUserEvents];
			break;
			
		case kEventsArgCut:
			return [EVENTRECORDER cutUserEvents:events];
			break;
			
		case kEventsArgReplay: {
				return [EVENTRECORDER replayUserEvents:events];
			}
			break;
			
		case kEventsArgSave: {
				NSData* data = [EVENTRECORDER saveUserEvents];
				return [data encode_base64];
			}
			break;
			
		case kEventsArgLoad: {
				[EVENTRECORDER clearUserEvents];
				[EVENTRECORDER addUserEvents:events];
				return [EVENTRECORDER reportUserEvents];
			}
			break;
			
		case kEventsArgClear:
			[EVENTRECORDER clearUserEvents];
			break;
			
		case kEventsArgNone:
		default:
			return [EVENTRECORDER reportUserEvents];
			break;
	}
	
	return action;
}

-(NSString*) command_events:(id)currentObject arg:(id)arg {
#if USE_PRIVATE_API
#else
	return NSLocalizedString(@"Add USE_PRIVATE_API=1 to Preprocessor Macros", nil);
#endif
	
	kEventsArg eventsArg = kEventsArgNone;		
	NSDictionary* eventsArgTable = [NSDictionary dictionaryWithKeysAndObjects:
									@"record", Enum(kEventsArgRecord),
									@"play", Enum(kEventsArgPlay),
									@"cut", Enum(kEventsArgCut),
									@"clear", Enum(kEventsArgClear),
									@"replay", Enum(kEventsArgReplay),
									@"save", Enum(kEventsArgSave),
									@"load", Enum(kEventsArgLoad),
									nil];
	NSString* action = NSLocalizedString(@"None", nil);
	for (NSString* key in [eventsArgTable allKeys]) {
		if ([arg hasPrefix:key]) {
			eventsArg = [[eventsArgTable objectForKey:key] intValue];
			action = key;
		}
	}

	NSArray* events = nil;
	switch (eventsArg) {
		case kEventsArgCut: {
				if ([arg length] > [@"cut " length]) {
					NSArray* dummy = [[arg slice:[@"cut " length] backward:-1] split:SPACE];
					NSMutableArray* ary = [NSMutableArray array];
					for (NSString* num in dummy) {
						[ary addObject:FIXNUM([num intValue])];
					}
					events = [NSArray arrayWithArray:ary];
				}
			}
			break;
			
		case kEventsArgReplay: {
				NSString* base64string = [arg slice:[@"replay" length] backward:-1];
				if ([base64string isEmpty]) {
					return NSLocalizedString(@"events replay NAME", nil);
				}
				NSData* frames = [base64string decode_base64];
				events = [EVENTRECORDER loadUserEvents:frames];
			}
			break;
			
		case kEventsArgLoad: {
				NSString* base64string = [arg slice:[@"load" length] backward:-1];
				NSData* frames = [base64string decode_base64];
				events = [EVENTRECORDER loadUserEvents:frames];
			}			
			break;
			
		case kEventsArgNone:
		default:
			break;
	}
				
	return [self processEvents:eventsArg action:action events:events];
}


@end




				 


static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (Base64Ext)
				 
-(NSData*) decode_base64 {
	
	if ([self length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([self length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}
@end
				 
@implementation NSData (Base64Ext)

- (NSString*) encode_base64 {
	 if ([self length] == 0)
		 return EMPTY_STRING;
	 
	 char *characters = malloc((([self length] + 2) / 3) * 4);
	 if (NULL == characters) {
		 return nil;
	 }
	 NSUInteger length = 0;
	 
	 NSUInteger i = 0;
	 while (i < [self length]) {
		 char buffer[3] = {0,0,0};
		 short bufferLength = 0;
		 while (bufferLength < 3 && i < [self length])
			 buffer[bufferLength++] = ((char *)[self bytes])[i++];
		 
		 //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		 characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		 characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		 if (bufferLength > 1)
			 characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		 else characters[length++] = '=';
		 if (bufferLength > 2)
			 characters[length++] = encodingTable[buffer[2] & 0x3F];
		 else characters[length++] = '=';
	 }
	 
	 return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

@end