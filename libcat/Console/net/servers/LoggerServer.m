//
//  LoggerServer.m
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "LoggerServer.h"
#import "Logger.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#import "NSStringExt.h"
#include <ifaddrs.h>
#import <QuartzCore/QuartzCore.h>
#import "GeometryExt.h"
#import "iPadExt.h"
#import "NSNumberExt.h"
#import "UIButtonBlock.h"

#define WELCOME_MSG  0
#define ECHO_MSG     1
#define WARNING_MSG  2

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

@implementation LoggerServer
@synthesize logTextView;

-(void) show_ip_address {
	NSString* ip_address = [self get_local_ip_address];
	if (nil == ip_address) {
		ip_address = NSLocalizedString(@"Unknown IP", nil);
	} else {
		print_log_info(@"~/libcat/script$ ruby console.rb %@\n", ip_address);
	}
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	CGRect windowFrame = window.frame;
	CGRect ipRect = CGRectBottomLeft(windowFrame, 90, 20);
	UIButton* ipButton = [[UIButton alloc] initWithFrame:ipRect];
	[ipButton addTarget:self action:@selector(touchedIpButton:) forControlEvents:UIControlEventTouchUpInside];
	ipButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:ipRect.size.height/1.5];
	ipButton.titleLabel.textAlignment = UITextAlignmentCenter;
	ipButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	ipButton.titleLabel.adjustsFontSizeToFitWidth = true;
	ipButton.layer.cornerRadius = 3;
	ipButton.backgroundColor = [UIColor yellowColor];
	[ipButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[ipButton setTitle:ip_address forState:UIControlStateNormal];
	[window addSubview:ipButton];
	[ipButton release];
	
	if (nil == logTextView) {
		CGRect rect = CGRectOffset(SCREEN_FRAME, 0, 20);
		self.logTextView = [[UITextView alloc] initWithFrame:rect];
		[window addSubview:logTextView];
		logTextView.backgroundColor = [UIColor colorWithRed:230/FF green:230/FF blue:177/FF alpha:0.81];
		logTextView.textColor = [UIColor blackColor];
		logTextView.editable = false;
		logTextView.hidden = true;
		[logTextView release];
	}		
	
	CGRect logRect = CGRectOffset(CGRectBottomLeft(windowFrame, 39, 20), ipRect.size.width + 18, 0);
	UIButton* showLogsButton = [[UIButton alloc] initWithFrame:logRect];
	[showLogsButton addTarget:self action:@selector(touchedToggleLogsButton:) forControlEvents:UIControlEventTouchUpInside];
	showLogsButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:logRect.size.height/1.5];
	showLogsButton.titleLabel.textAlignment = UITextAlignmentCenter;
	showLogsButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	showLogsButton.titleLabel.adjustsFontSizeToFitWidth = true;
	showLogsButton.layer.cornerRadius = 3;
	showLogsButton.backgroundColor = [UIColor orangeColor];
	[showLogsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[showLogsButton setTitle:@"log" forState:UIControlStateNormal];	
	[window addSubview:showLogsButton];
	[showLogsButton release];
	
}

-(IBAction) touchedIpButton:(id)sender {
	for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			[view removeFromSuperview];
		}
	}
	[logTextView removeFromSuperview];
}

-(IBAction) touchedToggleLogsButton:(id)sender {
	BOOL hidden = logTextView.hidden;
	logTextView.hidden = ! hidden;
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
		}
	}
}



- (NSString *) get_local_ip_address
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
	
}

+ (LoggerServer*) sharedServer {
	static LoggerServer*	manager = nil;
	if (!manager) {
		manager = [LoggerServer new];
	}
	return manager;
}


-(void) startWithPort:(int)port {
	if(!isRunning)
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
	
//	NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
//	NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
//	[sock writeData:welcomeData withTimeout:-1 tag:WELCOME_MSG];
	
//	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:0];
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
