//
//  UIViewOpenGLExt.m
//  TestApp
//
//  Created by WooKyoung Noh on 04/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//


#if USE_OPENGL

#import "UIViewOpenGLExt.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import "objc/runtime.h"
#import "Logger.h"



@implementation UIView (OpenGLExt)
-(BOOL) isOpenGLView {
	Class targetClass = [self class]->isa;
	if (class_respondsToSelector(targetClass, @selector(layerClass))) {
		IMP imp = class_getMethodImplementation(targetClass, @selector(layerClass));
		Class layerClass = ((id (*)(id, SEL))imp)(targetClass, @selector(layerClass));
		if ([CAEAGLLayer class] == layerClass) {
			return true;
		}
	}	
	return false;
}
@end



@implementation UIWindow (OpenGLExt)
-(BOOL) hasOpenGLView {
	for (UIView* view in self.subviews) {
		if ([view isOpenGLView]) {
			return true;
		}
	}
	return false;
}
@end





// source from Andrew Pouliot
// http://www.bit-101.com/blog/?p=1861#comment-10723

@implementation UIView (OpenGLToUIImageExt)

void releaseDataCallback(void *info, const void *data, size_t size) {
	free((void *)data);
};

-(UIImage *) opengl_to_image {
	NSInteger backingWidth = self.frame.size.width;
	NSInteger backingHeight = self.frame.size.height;
	NSInteger myDataLength = backingWidth * backingHeight * 4;
	
	// allocate array and read pixels into it.
	GLuint *buffer = (GLuint *) malloc(myDataLength);
	glReadPixels(0, 0, backingWidth, backingHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	
	// gl renders “upside down” so swap top to bottom into new array.
	for(int y = 0; y < backingHeight / 2; y++) {
		for(int x = 0; x < backingWidth; x++) {
			//Swap top and bottom bytes
			GLuint top = buffer[y * backingWidth + x];
			GLuint bottom = buffer[(backingHeight - 1 - y) * backingWidth + x];
			buffer[(backingHeight - 1 - y) * backingWidth + x] = top;
			buffer[y * backingWidth + x] = bottom;
		}
	}
	
	// make data provider with data.
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, releaseDataCallback);
	
	// prep the ingredients
	const int bitsPerComponent = 8;
	const int bitsPerPixel = 4 * bitsPerComponent;
	const int bytesPerRow = 4 * backingWidth;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(backingWidth, backingHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	
	// then make the UIImage from that
	UIImage *myImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	return myImage;
}

@end

#endif