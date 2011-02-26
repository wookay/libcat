//
//  TestConsole.m
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ConsoleManager.h"
#import "Logger.h"
#import "UnitTest.h"
#import "NSObjectExt.h"
#import <objc/runtime.h>

@interface TestConsole : NSObject 
@end


@implementation TestConsole

-(void) test_openURL {
	NSURL* scheme = [NSURL URLWithString:@"libcat.TabBarApp:console:password"];
	log_info(@"absoluteString %@", [scheme absoluteString]);
	log_info(@"relativeString %@", [scheme relativeString]);
	log_info(@"scheme %@", [scheme scheme]);
	log_info(@"resourceSpecifier %@", [scheme resourceSpecifier]);
	log_info(@"host %@", [scheme host]);
	log_info(@"port %@", [scheme port]);
	log_info(@"user %@", [scheme user]);
	log_info(@"password %@", [scheme password]);
	log_info(@"path %@", [scheme path]);
	log_info(@"fragment %@", [scheme fragment]);
	log_info(@"parameterString %@", [scheme parameterString]);
	log_info(@"query %@", [scheme query]);
	log_info(@"relativePath %@", [scheme relativePath]);
}

-(void) test_unescape {
	assert_equal(@"\"test\"", [@"%22test%22" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}	

-(void) test_NSURL {
	NSURL* url = [NSURL URLWithString:@"/ls?arg=test"];
	assert_equal(@"/ls", [url path]);
	assert_equal(@"arg=test", [url query]);
}

-(void) test_UIColor {
	assert_equal([UIColor redColor], objc_msgSend([UIColor class], @selector(redColor)));
}

@end
