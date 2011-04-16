//
//  UIViewFlick.m
//  TestApp
//
//  Created by WooKyoung Noh on 17/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "UIViewFlick.h"
#import <QuartzCore/QuartzCore.h>
#import "NSStringExt.h"
#import "GeometryExt.h"
#import "NSObjectExt.h"
#import "NSArrayExt.h"


@implementation UINavigationItem (ObjectInspect)
-(NSString*) inspect {
	return SWF(@"<UINavigationItem: %p; title = '%@'>", self, self.title);
}
@end

@implementation UIBarButtonItem (ObjectInspect)
-(NSString*) inspect {	
	return SWF(@"<UIBarButtonItem: %p; title = '%@'; target = %@; action=%@>", self, self.title, self.target, NSStringFromSelector(self.action));
}

@end



@implementation UIView (Flick)

-(void) flick {	
	[self.layer flick];
}

@end

@implementation CALayer (Flick)

-(void) flick {	
	NSTimeInterval ti = 0.35;		
	CALayer* flickLayer = [CALayer layer];
	flickLayer.frame = CGRectWithSize(self.frame.size);
	flickLayer.borderWidth = 3;
	flickLayer.borderColor = [[UIColor orangeColor] CGColor];
	flickLayer.backgroundColor = [[UIColor colorWithRed:0.85 green:0.88 blue:0.13 alpha:0.12] CGColor];
	[self addSublayer:flickLayer];
	[flickLayer performSelector:@selector(removeFromSuperlayer) afterDelay:ti];
}

@end

@implementation NSValue (CGExt)
-(NSValue*) origin {
	return [NSValue valueWithCGPoint:[self CGRectValue].origin];
}
-(NSValue*) size {
	return [NSValue valueWithCGSize:[self CGRectValue].size];
}
-(CGFloat) x {
	return [self CGPointValue].x;
}
-(CGFloat) y {
	return [self CGPointValue].y;
}
-(CGFloat) width {
	return [self CGSizeValue].width;
}
-(CGFloat) height {
	return [self CGSizeValue].height;
}
@end


@implementation NSArray (Description)
-(NSString*) arrayDescription {
	if (self.count > 0) {
		return SWF(@"[\n%@\n]", [self join:COMMA_LF]);
	} else {
		return @"[]";
	}
}
@end