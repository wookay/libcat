//
//  LoggerServer.h
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "Logger.h"

@interface LoggerServer : NSObject <LoggerDelegate> {
	AsyncSocket *listenSocket;
	NSMutableArray *connectedSockets;

	UITextView* logTextView;
	BOOL isRunning;	
}
@property (nonatomic, retain) UITextView* logTextView;

+ (LoggerServer*) sharedServer ;

-(void) startWithPort:(int)port ;
-(void) stop ;

@end