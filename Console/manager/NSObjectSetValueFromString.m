//
//  NSObjectSetValueFromString.m
//  TestApp
//
//  Created by wookyoung noh on 08/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSObjectSetValueFromString.h"
#import "NSStringExt.h"

BOOL boolFromString(NSString* str) {
	return [_w(@"YES TRUE true 1") containsObject:str];
}

CGRect rectFromString(NSString* str) {
	if ([str isSurrounded:OPENING_PARENTHESE :CLOSING_PARENTHESE]) { // (10 11; 45 21)
			NSArray* cuatro = [[[[str gsub:OPENING_PARENTHESE to:EMPTY_STRING] // ]1
									  gsub:CLOSING_PARENTHESE to:EMPTY_STRING] // ]2
									  gsub:SEMICOLON to:EMPTY_STRING] split:SPACE]; // ]3 ]4
		NSString* rectStr = [NSString stringFormat:@"{{%@, %@}, {%@, %@}}" withArray:cuatro];
		return CGRectFromString(rectStr);
	} else {
		return CGRectFromString(str);
	}
}
	

	
@implementation UIColor (ColorFromString)
+(UIColor*) colorFromString:(NSString*)str {
	SEL someColor = NSSelectorFromString(SWF(@"%@Color", str));
	if ([UIColor respondsToSelector:someColor]) {
		return [UIColor performSelector:someColor];
	}
	return nil;
}
@end


@implementation UIView (SetValueFromString)

// BOOL
-(void) setClearsContextBeforeDrawingFromString:(NSString*)str {
	self.clearsContextBeforeDrawing = boolFromString(str);
}
-(void) setHiddenFromString:(NSString*)str {
	self.hidden = boolFromString(str);
}
-(void) setClipsToBoundsFromString:(NSString*)str {
	self.clipsToBounds = boolFromString(str);
}
-(void) setOpaqueFromString:(NSString*)str {
	self.opaque = boolFromString(str);
}

// CGRect
-(void) setFrameFromString:(NSString*)str {
	self.frame = rectFromString(str);
}
-(void) setContentStretchFromString:(NSString*)str {
	self.contentStretch = rectFromString(str);
}

// float
-(void) setAlphaFromString:(NSString*)str {
	self.alpha = [str floatValue];
}

// NSString*
-(void) setTextFromString:(NSString*)str {
	SEL selector = @selector(setText:);
	if ([self respondsToSelector:selector]) {
		[self performSelector:selector withObject:str];
	}
}

// UIColor*
-(void) setBackgroundColorFromString:(NSString*)str {
	UIColor* color = [UIColor colorFromString:str];
	if (nil != color) {
		self.backgroundColor = color;
	}
}
@end


@implementation UILabel (SetValueFromString)
-(void) setTextColorFromString:(NSString*)str {
	UIColor* color = [UIColor colorFromString:str];
	if (nil != color) {
		self.textColor = color;
	}
}
-(void) setShadowColorFromString:(NSString*)str {
	UIColor* color = [UIColor colorFromString:str];
	if (nil != color) {
		self.shadowColor = color;
	}
}
@end


@implementation UITableView (SetValueFromString)

// CGPoint
-(void) setContentOffsetFromString:(NSString*)str {
	self.contentOffset = CGPointFromString(str);
}
@end

@implementation UIViewController (SetValueFromString)
-(void) setTitleFromString:(NSString*)str {
	self.title = str;
}
@end



@implementation UINavigationItem (SetValueFromString)
-(void) setTitleFromString:(NSString*)str {
	self.title = str;
}
@end