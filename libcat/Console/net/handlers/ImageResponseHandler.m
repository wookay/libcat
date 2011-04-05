//
//  ImageResponseHandler.m
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ImageResponseHandler.h"
#import "Logger.h"
#import "NSStringExt.h"
#import "HTTPServer.h"
#import "ConsoleManager.h"
#import "CommandManager.h"
#import "NSStringExt.h"
#import "GeometryExt.h"
#import "NSArrayExt.h"
#import <QuartzCore/QuartzCore.h>
#import "iPadExt.h"

#if USE_COCOA
	#import "NSWindowExtMac.h"
	#import "NSViewExtMac.h"
	#import "UIKitHelper.h"
#endif

#if USE_OPENGL
	#import "UIViewOpenGLExt.h"
#endif

@implementation ImageResponseHandler


+(void) load {
	[HTTPResponseHandler registerHandler:self];
}

+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
				  method:(NSString *)requestMethod
					 url:(NSURL *)requestURL
			headerFields:(NSDictionary *)requestHeaderFields {
	if ([requestURL.path hasPrefix:@"/image"]) {
		return YES;
	}
	
	return NO;
}

-(UIImage*) url_to_image {
	NSString* urlPath = [url path];
#define SLASH_IMAGE_SLASH_LENGTH 7	//	/image/
	if (urlPath.length > SLASH_IMAGE_SLASH_LENGTH) {
		NSString* addressPng = [[url path] slice:[@"/image/" length] backward:-1];
		NSString* addressStr = [addressPng slice:0 backward:-[@".png" length]-1];
		if ([@"capture" isEqualToString:addressStr]) {
			return [self capture_image];
		} else {
			size_t address = [addressStr to_size_t];
			id obj = (id)address;
			
#if USE_COCOA
			if ([SWF(@"%x", obj) isEqualToString:@"ffffffff"]) {
				return nil;
			}
#endif
			
			return [self obj_to_image:obj];
		}
	}
	return nil;
}

-(UIImage*) capture_image {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;// [CONSOLEMAN navigationController].topViewController.view;
	if ([window respondsToSelector:@selector(hasOpenGLView)]) {
		if ([window performSelector:@selector(hasOpenGLView)]) {
			if ([window respondsToSelector:@selector(opengl_to_image)]) {
				return [window performSelector:@selector(opengl_to_image)];
			}
		}
	}
#if USE_COCOA
	return (UIImage*)[window.contentView to_image];
#else
	CGRect screenRect = [[UIScreen mainScreen] bounds];    
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext(); 
	[[UIColor blackColor] set]; 
	CGContextFillRect(ctx, screenRect);
	for (UIWindow* window in [UIApplication sharedApplication].windows) {
		[window.layer renderInContext:ctx];		
	}
	if (! CGRectIsEmpty([UIApplication sharedApplication].statusBarFrame)) {
		CALayer* statusbarLayer = [CALayer layer];
		statusbarLayer.frame = [UIApplication sharedApplication].statusBarFrame;		
		statusbarLayer.contents = (id) [[UIImage imageNamed:(IS_IPAD ? @"libcat_statusbar~ipad.png" : @"libcat_statusbar.png")] CGImage];
		[statusbarLayer renderInContext:ctx];
	}
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage; 	
#endif
}

-(UIImage*) obj_to_image:(id)obj {
	UIImage* image = nil;
	if ([obj isKindOfClass:[UIView class]]) {
		UIView* view = obj;
		if ([view respondsToSelector:@selector(isOpenGLView)]) {
			if ([view performSelector:@selector(isOpenGLView)]) {
				if ([view respondsToSelector:@selector(opengl_to_image)]) {
					return [view performSelector:@selector(opengl_to_image)];
				}
			}
		}
		UIGraphicsBeginImageContext(view.frame.size);
		[view.layer renderInContext: UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();	
	} else if ([obj isKindOfClass:[UIImage class]]) {
		image = obj;
	} else if ([obj isKindOfClass:[CALayer class]]) {
		CALayer* layer = obj;
		UIGraphicsBeginImageContext(layer.frame.size);
		[layer renderInContext: UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();						
#if USE_COCOA
	} else if ([obj isKindOfClass:[NSView class]]) {
		image = (UIImage*)[obj to_image];
#endif
	}
	return image;
}

- (void)startResponse {	
	UIImage* image = [self url_to_image];
	NSData* fileData;
	if (nil == image) {
		fileData = [NSData data];
	} else {
		fileData = UIImagePNGRepresentation(image);
	}
	
	CFHTTPMessageRef response =
	CFHTTPMessageCreateResponse(
								kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(
									 response, (CFStringRef)@"Content-Type", (CFStringRef)@"image/png");
	CFHTTPMessageSetHeaderFieldValue(
									 response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	CFHTTPMessageSetHeaderFieldValue(
									 response,
									 (CFStringRef)@"Content-Length",
									 (CFStringRef)[NSString stringWithFormat:@"%ld", [fileData length]]);
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


