//
//  ConsoleResponseHandler.m
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ConsoleResponseHandler.h"
#import "Logger.h"
#import "NSStringExt.h"
#import "HTTPServer.h"
#import "ConsoleManager.h"
#import "NSStringExt.h"
#import "GeometryExt.h"
#import "NSArrayExt.h"
#import "NSObjectExt.h"
#import "Inspect.h"

@implementation ConsoleResponseHandler

+(void) load {
	[HTTPResponseHandler registerHandler:self];
}

+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
				  method:(NSString *)requestMethod
					 url:(NSURL *)requestURL
			headerFields:(NSDictionary *)requestHeaderFields {
	if ([requestURL.path hasPrefix:@"/console"]) {
		return YES;
	}
//	else if ([requestURL.path hasPrefix:@"/"])	{
//		return YES;
//	}
	
	return NO;
}

-(NSArray*) url_to_console_input {
	NSString* urlPath = [url path];
#define SLASH_CONSOLE_SLASH_LENGTH 9	//	/console/
	if (urlPath.length > SLASH_CONSOLE_SLASH_LENGTH) {
		NSString* command = [[url path] slice:[@"/console/" length] backward:-1];
		id arg = nil;
		NSString* query = [url query];
		if ([query isNotEmpty]) {
			NSString* argOne = [[query slice:[@"arg=" length] backward:-1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if (0 < [argOne length]) {
				arg = argOne;
			}
		}
		return PAIR(command, (nil == arg) ? [NilClass nilClass] : arg);		
	} else {
		return PAIR(nil, nil);
	}
}

- (void)startResponse {
	NSArray* pair = [self url_to_console_input];
	NSString* command = [pair objectAtFirst];
	id arg = [pair objectAtSecond];
	id output = [CONSOLEMAN input:command arg:arg];
	NSData* fileData = [output to_data];
	
	CFHTTPMessageRef response =
	CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%ld", [fileData length]]);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
	
	@try
	{
		[fileHandle writeData:(NSData *)headerData];
		[fileHandle writeData:fileData];
	}
	@catch (NSException *exception)
	{
		// Ignore the exception, it normally just means the client
		// closed the connection from the other end.
	}
	@finally
	{
		CFRelease(headerData);
		[server closeHandler:self];
	}
}

@end
