//
//  NSObjectValueToString.m
//  TestApp
//
//  Created by wookyoung noh on 08/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSObjectValueToString.h"
#import "NSStringExt.h"

@implementation UIView (ValueToString)

// BOOL
-(NSString*) clearsContextBeforeDrawingToString {
	return YES_NO(self.clearsContextBeforeDrawing);
}
-(NSString*) hiddenToString {
	return YES_NO(self.hidden);
}
-(NSString*) clipsToBoundsToString {
	return YES_NO(self.clipsToBounds);
}
-(NSString*) opaqueToString {
	return YES_NO(self.opaque);
}

// float
-(NSString*) alphaToString {
	return SWF(@"%g", self.alpha);
}

// CGRect
-(NSString*) frameToString {
	return NSStringFromCGRect(self.frame);
}

-(NSString*) contentStretchToString {
	return NSStringFromCGRect(self.contentStretch);
}

@end




@implementation UITableView (ValueToString)
// CGPoint
-(NSString*) contentOffsetToString {
	return NSStringFromCGPoint(self.contentOffset);
}
@end

