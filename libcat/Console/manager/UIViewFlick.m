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


@implementation UINavigationItem (Inspect)
-(NSString*) inspect {
	return SWF(@"<UINavigationItem: %p; title = '%@'>", self, self.title);
}
@end

@implementation UIBarButtonItem (Inspect)
-(NSString*) inspect {	
	return SWF(@"<UIBarButtonItem: %p; title = '%@'; target = %@; action=%@>", self, self.title, self.target, NSStringFromSelector(self.action));
}

@end



@implementation UIView (Flick)

-(void) flick {	
	NSTimeInterval ti = 0.35;		
	CALayer* flickLayer = [CALayer layer];
	flickLayer.frame = CGRectWithSize(self.layer.frame.size);
	flickLayer.borderWidth = 3;
	flickLayer.borderColor = [[UIColor orangeColor] CGColor];
	flickLayer.backgroundColor = [[UIColor colorWithRed:0.85 green:0.88 blue:0.13 alpha:0.12] CGColor];
	[self.layer addSublayer:flickLayer];
	[flickLayer performSelector:@selector(removeFromSuperlayer) afterDelay:ti];
}

@end