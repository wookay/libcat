//
//  LoggerServer.m
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "LoggerServer.h"
#import "Logger.h"
#import "NSStringExt.h"
#import <QuartzCore/QuartzCore.h>
#import "GeometryExt.h"
#import "iPadExt.h"
#import "NSNumberExt.h"
#import "UIButtonBlock.h"

#if USE_COCOA
	#import "NSWindowExtMac.h"
#endif


#define WELCOME_MSG  0
#define ECHO_MSG     1
#define WARNING_MSG  2

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

@implementation LoggerServer
@synthesize logTextView;

#pragma mark LoggerDelegate
-(void) removeLogTextView {
	[self.logTextView removeFromSuperview];
	self.logTextView = nil;
}

-(void) addLogTextView {
	if (nil == self.logTextView) {
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		CGRect rect = CGRectOffset(CGRectExpand(SCREEN_FRAME, 0, -60), 0, 60);
		self.logTextView = [[UITextView alloc] initWithFrame:rect];
		[window addSubview:logTextView];
		logTextView.backgroundColor = [UIColor colorWithRed:0.87 green:0.89 blue:0.60 alpha:0.9];
		logTextView.textColor = [UIColor blackColor];
		logTextView.editable = false;
		logTextView.hidden = true;
		[logTextView release];
	}
}

-(void) loggerTextOut:(NSString *)text {
	if (nil != connectedSockets) {
		NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
		for (AsyncSocket* sock in connectedSockets) {
			[sock writeData:data withTimeout:-1 tag:WELCOME_MSG];
		}
	}
	if (nil != logTextView) {
		if ([NSThread isMainThread]) {
			logTextView.text = SWF(@"%@%@", logTextView.text, text);
			if (! logTextView.hidden) {
				CGPoint bottomOffset = CGPointMake(0, [logTextView contentSize].height - logTextView.frame.size.height);
				if (bottomOffset.y > 0) {
					[logTextView setContentOffset:bottomOffset animated:YES];
				}
			}
			
		}
	}
}



+ (LoggerServer*) sharedServer {
	static LoggerServer*	manager = nil;
	if (!manager) {
		manager = [LoggerServer new];
	}
	return manager;
}


-(void) startWithPort:(int)port {
	if(! isRunning)
	{		
		if(port < 0 || port > 65535)
		{
			port = 0;
		}
		
		NSError *error = nil;
		if(![listenSocket acceptOnPort:port error:&error]) {
			log_info(@"Error starting server: %@", error);
			return;
		}
		
		//log_info(@"Logger server started on port %hu", [listenSocket localPort]);
		isRunning = YES;
	}	
}

- (void)dealloc {
	[logTextView release];
	[super dealloc];
}

- (id)init
{
	if((self = [super init]))
	{
		listenSocket = [[AsyncSocket alloc] initWithDelegate:self];
		connectedSockets = nil;
		
		isRunning = NO;
		self.logTextView = nil;
	}
	return self;
}



- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	if (nil == connectedSockets) {
		connectedSockets = [[NSMutableArray alloc] init];
	}
	[connectedSockets addObject:newSocket];
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	log_info(@"Accepted client %@:%hu", host, port);
}


- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	if(tag == ECHO_MSG)
	{
		[sock readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:0];
	}
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] autorelease];
	if(msg)
	{
		log_info(@"message %@", msg);
	}
	else
	{
		log_info(@"error %@", msg);
	}
	
	// Even if we were unable to write the incoming data to the log,
	// we're still going to echo it back to the client.
	[sock writeData:data withTimeout:-1 tag:ECHO_MSG];
}

/**
 * This method is called if a read has timed out.
 * It allows us to optionally extend the timeout.
 * We use this method to issue a warning to the user prior to disconnecting them.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
				   elapsed:(NSTimeInterval)elapsed
				 bytesDone:(CFIndex)length
{
	if(elapsed <= READ_TIMEOUT)
	{
		NSString *warningMsg = @"Are you still there?\r\n";
		NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];
		
		[sock writeData:warningData withTimeout:-1 tag:WARNING_MSG];
		
		return READ_TIMEOUT_EXTENSION;
	}
	
	return 0.0;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	log_info(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[connectedSockets removeObject:sock];
}


-(void) stop {
	// Stop accepting connections
	[listenSocket disconnect];
	
	// Stop any client connections
	int i;
	for(i = 0; i < [connectedSockets count]; i++)
	{
		// Call disconnect on the socket,
		// which will invoke the onSocketDidDisconnect: method,
		// which will remove the socket from the list.
		[[connectedSockets objectAtIndex:i] disconnect];
	}
	
	isRunning = false;
}

@end




