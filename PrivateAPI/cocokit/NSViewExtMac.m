//
//  NSViewExtMac.m
//  MacApp
//
//  Created by WooKyoung Noh on 09/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "NSViewExtMac.h"
#import "NSNumberExt.h"

@implementation NSView (ExtMac)
-(NSImage*) to_image {
	NSBitmapImageRep *imageRep = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
	unsigned char *bitmapData = [imageRep bitmapData];
	if (bitmapData != NULL) {
		bzero(bitmapData, [imageRep bytesPerRow] * [imageRep pixelsHigh]);
	}
	[self cacheDisplayInRect:[self bounds] toBitmapImageRep:imageRep];
	NSImage* image = [[[NSImage alloc] init] autorelease];
	[image addRepresentation: imageRep];
	return image;
}
-(void) flick {
	CGFloat viewAlpha = self.alphaValue;
	[self performSelector:@selector(flickBack:) withObject:FLOAT(viewAlpha) afterDelay:0.45];
	[self.animator setAlphaValue:(1 == viewAlpha) ? 0.1 : 1];
}
-(void) flickBack:(NSNumber*)viewAlpha {
	[self.animator setAlphaValue:[viewAlpha floatValue]];	
}
@end
