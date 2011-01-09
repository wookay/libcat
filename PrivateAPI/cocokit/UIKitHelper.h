//
//  UIKitHelper.h
//  MacApp
//
//  Created by WooKyoung Noh on 06/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
    UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    UIControlEventTouchDragInside     = 1 <<  2,
    UIControlEventTouchDragOutside    = 1 <<  3,
    UIControlEventTouchDragEnter      = 1 <<  4,
    UIControlEventTouchDragExit       = 1 <<  5,
    UIControlEventTouchUpInside       = 1 <<  6,
    UIControlEventTouchUpOutside      = 1 <<  7,
    UIControlEventTouchCancel         = 1 <<  8,
	
    UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
	
    UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
    UIControlEventEditingChanged      = 1 << 17,
    UIControlEventEditingDidEnd       = 1 << 18,
    UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending editing
	
    UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
    UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
    UIControlEventApplicationReserved = 0x0F000000,  // range available for application use
    UIControlEventSystemReserved      = 0xF0000000,  // range reserved for internal framework use
    UIControlEventAllEvents           = 0xFFFFFFFF
};
typedef NSUInteger UIControlEvents;

typedef enum {
    UITextAlignmentLeft = 0,
    UITextAlignmentCenter,
    UITextAlignmentRight,                   // could add justified in future
} UITextAlignment;


typedef enum {
    UIBaselineAdjustmentAlignBaselines = 0, // default. used when shrinking text to position based on the original baseline
    UIBaselineAdjustmentAlignCenters,
    UIBaselineAdjustmentNone,
} UIBaselineAdjustment;


enum {
    UIControlStateNormal       = 0,                       
    UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
    UIControlStateDisabled     = 1 << 1,
    UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
    UIControlStateApplication  = 0x00FF0000,              // additional flags available for application use
    UIControlStateReserved     = 0xFF000000               // flags reserved for internal framework use
};
typedef NSUInteger UIControlState;




@interface UIImage : NSImage
@end


typedef enum {
#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    UIUserInterfaceIdiomPhone,           // iPhone and iPod touch style UI
    UIUserInterfaceIdiomPad,             // iPad style UI
#endif
} UIUserInterfaceIdiom;
@interface UIDevice : NSObject
+ (UIDevice *)currentDevice;
@property(nonatomic,readonly) UIUserInterfaceIdiom userInterfaceIdiom;
@end

@interface UIEvent : NSObject
@end

@interface UIColor : NSObject
@property(nonatomic,readonly) CGColorRef CGColor;
+(UIColor*) blueColor ;
+(UIColor*) yellowColor ;
+(UIColor*) darkGrayColor ;
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
@end

@interface CALayer (UIKit)
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGColorRef borderColor;
@end

@interface UIView : NSView
@property (nonatomic) CGFloat alpha;
@property (nonatomic, retain) CALayer* layer;
@property(nonatomic,copy)            UIColor          *backgroundColor;            // default is nil
@property(nonatomic,readonly) UIView       *superview;
@property(nonatomic,readonly,copy) NSArray *subviews;
@property(nonatomic)                 BOOL              clipsToBounds;              // When YES, content and subviews are clipped to the bounds of the view. Default is NO.
@property(nonatomic,getter=isOpaque) BOOL              opaque;                     // default is YES. opaque views must fill their entire bounds or the results are undefined. the active CGContext in drawRect: will not have been cleared and may have non-zeroed pixels
@property(nonatomic)                 BOOL              clearsContextBeforeDrawing; // default is YES. ignored for opaque views. for non-opaque views causes the active CGContext in drawRect: to be pre-filled with transparent pixels
@property(nonatomic,getter=isHidden) BOOL              hidden;                     // default is NO. doesn't check superviews
@property(nonatomic) CGRect            frame;
@property(nonatomic)                 CGRect            contentStretch; // animatable. default is unit rectangle {{0,0} {1,1}}
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations ;
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion; // delay = 0.0, options = 0
- (void)removeFromSuperview;
- (void)addSubview:(UIView *)view;
@end

@interface UIScreen : NSScreen
@property(nonatomic,readonly) CGRect  bounds;                // Bounds of entire screen in points
+ (UIScreen *)mainScreen;      // the device's internal screen
@end

@interface UITabBar : UIView
@end

@interface UIToolbar : UIView
@property(nonatomic,copy)   NSArray   *items;       // get/set visible UIBarButtonItem. default is nil. changes not animated. shown in order
@end

@interface UINavigationItem : UIView
@property(nonatomic,copy) NSString *title;  // Localized title for use by a parent controller.
@end

@interface UIScrollView : UIView
@property(nonatomic)         CGPoint                      contentOffset;                  // default CGPointZero
@property(nonatomic)         CGSize                       contentSize;                    // default CGSizeZero
@end

@protocol UIScrollViewDelegate<NSObject>
@end

@interface NSIndexPath (UITableView)
@property(nonatomic,readonly) NSUInteger section;
@property(nonatomic,readonly) NSUInteger row;
+ (NSIndexPath *)indexPathForRow:(NSUInteger)row inSection:(NSUInteger)section;
@end

@class UITableView;
@protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UIFont : NSObject
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;
@end


@interface UILabel : UIView
@property(nonatomic,copy)   NSString       *text;            // default is nil
@property(nonatomic,retain) UIColor        *textColor;       // default is nil (text draws black)
@property(nonatomic,retain) UIColor        *shadowColor;     // default is nil (no shadow)
@property(nonatomic,retain) UIFont         *font;            // default is nil (system font 17 plain)
@property(nonatomic)        UITextAlignment textAlignment;   // default is UITextAlignmentLeft
@property(nonatomic) UIBaselineAdjustment baselineAdjustment; // default is UIBaselineAdjustmentAlignBaselines
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;          // default is NO
@end

@interface UIControl : UIView
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;                        // send all actions associated with events
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

@interface UIButton : UIControl
@property(nonatomic,readonly,retain) UILabel     *titleLabel;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;            // default is nil. title is assumed to be single line
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;        // default if nil. use opaque white
@end


@interface UITextView : UIScrollView
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic,retain) UIColor        *textColor;       // default is nil (text draws black)
@property(nonatomic,copy)   NSString       *text;            // default is nil
@end


@interface UITableViewCell : UIView
@property(nonatomic,readonly,retain) UILabel      *textLabel;   // default is nil.  label will be created if necessary.
@property(nonatomic,readonly,retain) UILabel      *detailTextLabel;   // default is nil.  label will be created if necessary (and the current style supports a detail label).
@end

@protocol UIActionSheetDelegate <NSObject>
@end
@interface UIActionSheet : UIView
@property(nonatomic) NSInteger cancelButtonIndex;      // if the delegate does not implement -actionSheetCancel:, we pretend this button was clicked on. default is -1
@property(nonatomic) NSInteger destructiveButtonIndex;        // sets destructive (red) button. -1 means none set. default is -1. ignored if only one button
@property(nonatomic,assign) id<UIActionSheetDelegate> delegate;    // weak reference
@end

@protocol UIAlertViewDelegate <NSObject>
@end
@interface UIAlertView : UIView
@property(nonatomic,assign) id<UIAlertViewDelegate> delegate;    // weak reference
@end


@interface UITableView : UIScrollView
@property(nonatomic,assign)   id <UITableViewDelegate>   delegate;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;            // returns nil if cell is not visible or index path is out of range
- (NSArray *)indexPathsForVisibleRows;
- (NSInteger)numberOfSections;
@end


@interface UIWindow : NSWindow
@end

@protocol UIApplicationDelegate<NSObject>
@end

@interface UIApplication : NSObject {
	id<NSApplicationDelegate> delegate;
}
@property(nonatomic, assign) id<NSApplicationDelegate> delegate;
+ (UIApplication *)sharedApplication ;
-(UIWindow*) keyWindow ;
@end

@class UINavigationController;
@interface UIViewController : NSObject {
	UIViewController *modalViewController;
	UIViewController *parentViewController;
	UIView* view;
	UINavigationItem *navigationItem;
	UINavigationController *navigationController;
}
@property(nonatomic,readonly) UIViewController *modalViewController;
@property(nonatomic,readonly) UIViewController *parentViewController; // If this view controller is inside a navigation controller or tab bar controller, or has been presented modally by another view controller, return it.
@property(nonatomic,retain) UIView *view; // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.
@property(nonatomic,readonly,retain) UINavigationController *navigationController; // If this view controller has been pushed onto a navigation controller, return it.
@property(nonatomic,readonly,retain) UINavigationItem *navigationItem; // Created on-demand so that a view controller may customize its navigation appearance.
@property(nonatomic,copy) NSString *title;  // Localized title for use by a parent controller.
@end

@interface UINavigationController : UIViewController
@property(nonatomic,copy) NSArray *viewControllers; // The current view controller stack.
@property(nonatomic,getter=isToolbarHidden) BOOL toolbarHidden; // Defaults to YES, i.e. hidden.
@property(nonatomic,readonly) UIToolbar *toolbar; // For use when presenting an action sheet.
@property(nonatomic,readonly,retain) UIViewController *topViewController; // The top view controller on the stack.
- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
@end

@class UITabBar;
@interface UITabBarController : UIViewController
@property(nonatomic,readonly) UITabBar *tabBar; // Provided for -[UIActionSheet showFromTabBar:]. Attempting to modify the contents of the tab bar directly will throw an exception.
@property(nonatomic,copy) NSArray *viewControllers; // The current view controller stack.
@property(nonatomic,assign) UIViewController *selectedViewController; // This may return the "More" navigation controller if it exists.
@property(nonatomic) NSUInteger selectedIndex;
@end



typedef enum {
    UIBarButtonSystemItemDone,
    UIBarButtonSystemItemCancel,
    UIBarButtonSystemItemEdit,  
    UIBarButtonSystemItemSave,  
    UIBarButtonSystemItemAdd,
    UIBarButtonSystemItemFlexibleSpace,
    UIBarButtonSystemItemFixedSpace,
    UIBarButtonSystemItemCompose,
    UIBarButtonSystemItemReply,
    UIBarButtonSystemItemAction,
    UIBarButtonSystemItemOrganize,
    UIBarButtonSystemItemBookmarks,
    UIBarButtonSystemItemSearch,
    UIBarButtonSystemItemRefresh,
    UIBarButtonSystemItemStop,
    UIBarButtonSystemItemCamera,
    UIBarButtonSystemItemTrash,
    UIBarButtonSystemItemPlay,
    UIBarButtonSystemItemPause,
    UIBarButtonSystemItemRewind,
    UIBarButtonSystemItemFastForward,
#if __IPHONE_3_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    UIBarButtonSystemItemUndo,
    UIBarButtonSystemItemRedo,
#endif
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    UIBarButtonSystemItemPageCurl,
#endif
} UIBarButtonSystemItem;


typedef enum {
    UIBarButtonItemStylePlain,    // shows glow when pressed
    UIBarButtonItemStyleBordered,
    UIBarButtonItemStyleDone,
} UIBarButtonItemStyle;
@interface UIBarButtonItem : UIView
@property(nonatomic)         UIBarButtonItemStyle style;            // default is UIBarButtonItemStylePlain
@property(nonatomic)         SEL                  action;           // default is NULL
@property(nonatomic,assign)  id                   target;           // default is nil
@property(nonatomic)         CGFloat              width;            // default is 0.0
@property(nonatomic,copy) NSString *title;  // Localized title for use by a parent controller.
@end


CGRect CGRectFromString(NSString *string);
CGPoint CGPointFromString(NSString *string);
CGSize CGSizeFromString(NSString *string);
NSString *NSStringFromCGRect(CGRect rect);
NSString *NSStringFromCGPoint(CGPoint point);
NSString *NSStringFromCGSize(CGSize size) ;

void UIGraphicsBeginImageContext(CGSize size) ;
CGContextRef UIGraphicsGetCurrentContext(void) ;
UIImage* UIGraphicsGetImageFromCurrentImageContext(void);
void     UIGraphicsEndImageContext(void); 
NSData *UIImagePNGRepresentation(UIImage *image);