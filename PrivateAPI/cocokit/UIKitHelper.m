//
//  UIKitHelper.m
//  MacApp
//
//  Created by WooKyoung Noh on 06/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "UIKitHelper.h"
#import "Logger.h"
#import "NSArrayExt.h"

@implementation UIImage
@end

@implementation UIDevice
+ (UIDevice *)currentDevice {
	return nil;
}
@end

@implementation UIEvent
@end

@implementation UIColor
+(UIColor*) blueColor {
	return nil;
}
+(UIColor*) yellowColor {
	return nil;
}
+(UIColor*) darkGrayColor {
	return nil;
}
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
	return nil;
}
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b {
	return nil;
}
@end

@implementation CALayer (UIKit)
@end


@implementation UIView
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations {
}
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
}
- (void)removeFromSuperview {
}
- (void)addSubview:(UIView *)view {
}
@end


@implementation UIScreen
+ (UIScreen *)mainScreen {
	return (UIScreen*)[super mainScreen];
}
@end

@implementation UITabBar
@end

@implementation UIToolbar
@end

@implementation UINavigationItem
@end

@implementation UIScrollView
@end

@implementation NSIndexPath (UITableView)
+ (NSIndexPath *)indexPathForRow:(NSUInteger)row inSection:(NSUInteger)section {
	return nil;
}
@end

@implementation UIFont
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
	return nil;
}
@end

@implementation UILabel
@end

@implementation UIControl
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents {
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
}
@end

@implementation UIButton
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
}
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
}
@end

@implementation UITextView
@end

@implementation UITableViewCell
@end

@implementation UIActionSheet
@end

@implementation UIAlertView
@end

@implementation UITableView
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	return 0;
}
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}
- (NSArray *)indexPathsForVisibleRows {
	return nil;
}
- (NSInteger)numberOfSections {
	return 0;
}
@end

@implementation UIWindow
@end

@implementation UIApplication
@synthesize delegate;
+ (UIApplication *)sharedApplication {
	static UIApplication* application = nil;
	if (nil == application) {
		application = [UIApplication new];
		application.delegate = [NSApplication sharedApplication].delegate;
	}
	return application;
}
-(UIWindow*) keyWindow {
	return [[[NSApplication sharedApplication] windows] objectAtFirst];
}
@end

@implementation UIViewController
@synthesize modalViewController;
@synthesize parentViewController;
@synthesize view;
@synthesize navigationItem;
@synthesize navigationController;
-(void) dealloc {
	modalViewController = nil;
	parentViewController = nil;
	[view release];
	[navigationItem release];
	[navigationController release];
	[super dealloc];
}
@end

@implementation UINavigationController
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	return nil;
}
@end

@implementation UITabBarController
@end

@implementation UIBarButtonItem
@end



CGRect CGRectFromString(NSString *string) {
	NSRect rect = NSRectFromString(string);
	return NSRectToCGRect(rect);
}

CGPoint CGPointFromString(NSString *string) {
	NSPoint point = NSPointFromString(string);
	return NSPointToCGPoint(point);
}

CGSize CGSizeFromString(NSString *string) {
	NSSize size = NSSizeFromString(string);
	return NSSizeToCGSize(size);
}

NSString *NSStringFromCGRect(CGRect rect) {
	NSRect aRect = NSRectFromCGRect(rect);
	return NSStringFromRect(aRect);
}

NSString *NSStringFromCGPoint(CGPoint point) {
	NSPoint aPoint = NSPointFromCGPoint(point);
	return NSStringFromPoint(aPoint);
}

NSString *NSStringFromCGSize(CGSize size) {
	NSSize aSize = NSSizeFromCGSize(size);
	return NSStringFromSize(aSize);
}

void UIGraphicsBeginImageContext(CGSize size) {
}
CGContextRef UIGraphicsGetCurrentContext(void) {
	return [[NSGraphicsContext currentContext] graphicsPort];
}
UIImage* UIGraphicsGetImageFromCurrentImageContext(void) {
	return nil;
}
void UIGraphicsEndImageContext(void) {
}
NSData *UIImagePNGRepresentation(UIImage *image) {
	NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary* imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    NSData* pngData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
	return pngData;
}