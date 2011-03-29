//
//  TypeInfoTable.m
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "TypeInfoTable.h"
#import "NSDictionaryExt.h"
#import "NSStringExt.h"
#import "NSObjectExt.h"
#import "NSArrayExt.h"
#import <objc/message.h>
#import "Inspect.h"
#import "ConsoleManager.h"
#import "Logger.h"

@implementation TypeInfoTable
@synthesize typedefTable;
@synthesize propertyTable;

 
-(NSNumber*) enumStringToNumber:(NSString*)str {
	for (NSArray* typeArray in [typedefTable allValues]) {
		int idx = [typeArray indexOfObject:str];
		if (idx == NSNotFound) {
		} else {
			return [NSNumber numberWithInt:idx];
		}
	}
	return nil;
}

-(id) objectStringToObject:(NSString*)str failed:(BOOL*)failed {
	if ([STR_NIL isEqualToString:str]) {
		return nil;
	} else if ([str hasPrefix:MEMORY_ADDRESS_PREFIX]) {
		size_t address = [str to_size_t];
		return (id)address;
	} else {
		*failed = true;
	}
	return nil;
}

-(NSString*) findEnumDefinitionByEnumString:(NSString*)str {
	NSString* foundType = nil;
	NSArray* foundTypes = nil;
	NSArray* value = [typedefTable objectForKey:str];
	if (nil == value) {
		for (NSString* key in [typedefTable allKeys]) {
			NSArray* types = [typedefTable objectForKey:key];
			if ([types containsObject:str]) {
				foundType = key;
				foundTypes = types;
				break;
			}
		}
	} else {
		foundType = str;
		foundTypes = value;
	}
	if (foundType) {
		NSMutableArray* ary = [NSMutableArray array];
		[ary addObject:SWF(@"%@", foundType)];		
		for (int idx = 0; idx < foundTypes.count; idx++) {
			NSString* typeStr = [foundTypes objectAtIndex:idx];
			[ary addObject:SWF(@"  %d %@ ", idx, typeStr)];
		}
		return [ary join:LF];
	} else {
		return nil;
	}
}

-(NSString*) objectDescriptionForProperty:(id)obj targetClass:(NSString*)targetClass propertyName:(NSString*)propertyName {
	return [self objectDescriptionInternal:obj targetClass:targetClass propertyName:propertyName removeLF:true];
}

-(NSString*) objectDescription:(id)obj targetClass:(NSString*)targetClass propertyName:(NSString*)propertyName {
	return [self objectDescriptionInternal:obj targetClass:targetClass propertyName:propertyName removeLF:false];
}

-(NSString*) objectDescriptionInternal:(id)obj targetClass:(NSString*)targetClass propertyName:(NSString*)propertyName removeLF:(BOOL)removeLF {
	if (nil == obj) {
		return STR_NIL;
	}
	NSString* typeKey = SWF(@"%@ %@", targetClass, propertyName);
	NSString* typeName = [propertyTable objectForKey:typeKey];
	if (nil != typeName) {
		if ([typedefTable hasKey:typeName]) {
			NSArray* enumValues = [typedefTable objectForKey:typeName];
			int idx = [obj intValue];
			if (enumValues.count > idx) {
				NSString* value = [enumValues objectAtIndex:idx];
				return SWF(@"%d [%@]", idx, value);
			} else {
				return SWF(@"%d", idx);
			}
		} else if ([@"BOOL" isEqualToString:typeName]) {
			BOOL value = [obj boolValue];
			return SWF(@"%@", value ? @"true" : @"false");
//		} else if ([@"CGRect" isEqualToString:typeName]) {
//		} else if ([@"CGSize" isEqualToString:typeName]) {
//		} else if ([@"CGPoint" isEqualToString:typeName]) {
//		} else if ([@"CGFloat" isEqualToString:typeName]) {
		}
	}
	if (removeLF) {
		if ([obj isKindOfClass:[NSObject class]]) {
			return [SWF(@"%@", [obj inspect]) gsub:LF to:EMPTY_STRING];
		} else {
			return EMPTY_STRING;
		}
	} else {
		return SWF(@"%@", obj);
	}
}




//GEN
-(void) load_typedef_table {
	self.typedefTable = [NSDictionary dictionaryWithKeysAndObjects: 
		@"UIAccessibilityScrollDirection", _w(@"UIAccessibilityScrollDirectionRight UIAccessibilityScrollDirectionLeft UIAccessibilityScrollDirectionUp UIAccessibilityScrollDirectionDown"),
		@"UIActionSheetStyle", _w(@"UIActionSheetStyleDefault UIActionSheetStyleBlackTranslucent UIActionSheetStyleBlackOpaque"),
		@"UIActivityIndicatorViewStyle", _w(@"UIActivityIndicatorViewStyleWhiteLarge UIActivityIndicatorViewStyleWhite UIActivityIndicatorViewStyleGray"),
		@"UIApplicationState", _w(@"UIApplicationStateActive UIApplicationStateInactive UIApplicationStateBackground"),
		@"UIBarButtonItemStyle", _w(@"UIBarButtonItemStylePlain UIBarButtonItemStyleBordered UIBarButtonItemStyleDone"),
		@"UIBarButtonSystemItem", _w(@"UIBarButtonSystemItemDone UIBarButtonSystemItemCancel UIBarButtonSystemItemEdit UIBarButtonSystemItemSave UIBarButtonSystemItemAdd UIBarButtonSystemItemFlexibleSpace UIBarButtonSystemItemFixedSpace UIBarButtonSystemItemCompose UIBarButtonSystemItemReply UIBarButtonSystemItemAction UIBarButtonSystemItemOrganize UIBarButtonSystemItemBookmarks UIBarButtonSystemItemSearch UIBarButtonSystemItemRefresh UIBarButtonSystemItemStop UIBarButtonSystemItemCamera UIBarButtonSystemItemTrash UIBarButtonSystemItemPlay UIBarButtonSystemItemPause UIBarButtonSystemItemRewind UIBarButtonSystemItemFastForward UIBarButtonSystemItemUndo UIBarButtonSystemItemRedo UIBarButtonSystemItemPageCurl"),
		@"UIBarStyle", _w(@"UIBarStyleDefault UIBarStyleBlack UIBarStyleBlackOpaque UIBarStyleBlackTranslucent"),
		@"UIBaselineAdjustment", _w(@"UIBaselineAdjustmentAlignBaselines UIBaselineAdjustmentAlignCenters UIBaselineAdjustmentNone"),
		@"UIButtonType", _w(@"UIButtonTypeCustom UIButtonTypeRoundedRect UIButtonTypeDetailDisclosure UIButtonTypeInfoLight UIButtonTypeInfoDark UIButtonTypeContactAdd"),
		@"UIControlContentHorizontalAlignment", _w(@"UIControlContentHorizontalAlignmentCenter UIControlContentHorizontalAlignmentLeft UIControlContentHorizontalAlignmentRight UIControlContentHorizontalAlignmentFill"),
		@"UIControlContentVerticalAlignment", _w(@"UIControlContentVerticalAlignmentCenter UIControlContentVerticalAlignmentTop UIControlContentVerticalAlignmentBottom UIControlContentVerticalAlignmentFill"),
		@"UIDatePickerMode", _w(@"UIDatePickerModeTime UIDatePickerModeDate UIDatePickerModeDateAndTime UIDatePickerModeCountDownTimer"),
		@"UIDeviceBatteryState", _w(@"UIDeviceBatteryStateUnknown UIDeviceBatteryStateUnplugged UIDeviceBatteryStateCharging UIDeviceBatteryStateFull"),
		@"UIDeviceOrientation", _w(@"UIDeviceOrientationUnknown UIDeviceOrientationPortrait UIDeviceOrientationPortraitUpsideDown UIDeviceOrientationLandscapeLeft UIDeviceOrientationLandscapeRight UIDeviceOrientationFaceUp UIDeviceOrientationFaceDown"),
		@"UIEventSubtype", _w(@"UIEventSubtypeNone UIEventSubtypeMotionShake UIEventSubtypeRemoteControlPlay UIEventSubtypeRemoteControlPause UIEventSubtypeRemoteControlStop UIEventSubtypeRemoteControlTogglePlayPause UIEventSubtypeRemoteControlNextTrack UIEventSubtypeRemoteControlPreviousTrack UIEventSubtypeRemoteControlBeginSeekingBackward UIEventSubtypeRemoteControlEndSeekingBackward UIEventSubtypeRemoteControlBeginSeekingForward UIEventSubtypeRemoteControlEndSeekingForward"),
		@"UIEventType", _w(@"UIEventTypeTouches UIEventTypeMotion UIEventTypeRemoteControl"),
		@"UIGestureRecognizerState", _w(@"UIGestureRecognizerStatePossible UIGestureRecognizerStateBegan UIGestureRecognizerStateChanged UIGestureRecognizerStateEnded UIGestureRecognizerStateCancelled UIGestureRecognizerStateFailed UIGestureRecognizerStateRecognized"),
		@"UIImageOrientation", _w(@"UIImageOrientationUp UIImageOrientationDown UIImageOrientationLeft UIImageOrientationRight UIImageOrientationUpMirrored UIImageOrientationDownMirrored UIImageOrientationLeftMirrored UIImageOrientationRightMirrored"),
		@"UIInterfaceOrientation", _w(@"UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight"),
		@"UIKeyboardAppearance", _w(@"UIKeyboardAppearanceDefault UIKeyboardAppearanceAlert"),
		@"UIKeyboardType", _w(@"UIKeyboardTypeDefault UIKeyboardTypeASCIICapable UIKeyboardTypeNumbersAndPunctuation UIKeyboardTypeURL UIKeyboardTypeNumberPad UIKeyboardTypePhonePad UIKeyboardTypeNamePhonePad UIKeyboardTypeEmailAddress UIKeyboardTypeDecimalPad UIKeyboardTypeAlphabet"),
		@"UILineBreakMode", _w(@"UILineBreakModeWordWrap UILineBreakModeCharacterWrap UILineBreakModeClip UILineBreakModeHeadTruncation UILineBreakModeTailTruncation UILineBreakModeMiddleTruncation"),
		@"UIMenuControllerArrowDirection", _w(@"UIMenuControllerArrowDefault UIMenuControllerArrowUp UIMenuControllerArrowDown UIMenuControllerArrowLeft UIMenuControllerArrowRight"),
		@"UIModalPresentationStyle", _w(@"UIModalPresentationFullScreen UIModalPresentationPageSheet UIModalPresentationFormSheet UIModalPresentationCurrentContext"),
		@"UIModalTransitionStyle", _w(@"UIModalTransitionStyleCoverVertical UIModalTransitionStyleFlipHorizontal UIModalTransitionStyleCrossDissolve UIModalTransitionStylePartialCurl"),
		@"UIPrintInfoDuplex", _w(@"UIPrintInfoDuplexNone UIPrintInfoDuplexLongEdge UIPrintInfoDuplexShortEdge"),
		@"UIPrintInfoOrientation", _w(@"UIPrintInfoOrientationPortrait UIPrintInfoOrientationLandscape"),
		@"UIPrintInfoOutputType", _w(@"UIPrintInfoOutputGeneral UIPrintInfoOutputPhoto UIPrintInfoOutputGrayscale"),
		@"UIProgressViewStyle", _w(@"UIProgressViewStyleDefault UIProgressViewStyleBar"),
		@"UIRemoteNotificationType", _w(@"UIRemoteNotificationTypeNone UIRemoteNotificationTypeBadge UIRemoteNotificationTypeSound UIRemoteNotificationTypeAlert"),
		@"UIReturnKeyType", _w(@"UIReturnKeyDefault UIReturnKeyGo UIReturnKeyGoogle UIReturnKeyJoin UIReturnKeyNext UIReturnKeyRoute UIReturnKeySearch UIReturnKeySend UIReturnKeyYahoo UIReturnKeyDone UIReturnKeyEmergencyCall"),
		@"UIScrollViewIndicatorStyle", _w(@"UIScrollViewIndicatorStyleDefault UIScrollViewIndicatorStyleBlack UIScrollViewIndicatorStyleWhite"),
		@"UISegmentedControlStyle", _w(@"UISegmentedControlStylePlain UISegmentedControlStyleBordered UISegmentedControlStyleBar UISegmentedControlStyleBezeled"),
		@"UIStatusBarAnimation", _w(@"UIStatusBarAnimationNone UIStatusBarAnimationFade UIStatusBarAnimationSlide"),
		@"UIStatusBarStyle", _w(@"UIStatusBarStyleDefault UIStatusBarStyleBlackTranslucent UIStatusBarStyleBlackOpaque"),
		@"UISwipeGestureRecognizerDirection", _w(@"UISwipeGestureRecognizerDirectionRight UISwipeGestureRecognizerDirectionLeft UISwipeGestureRecognizerDirectionUp UISwipeGestureRecognizerDirectionDown"),
		@"UITabBarSystemItem", _w(@"UITabBarSystemItemMore UITabBarSystemItemFavorites UITabBarSystemItemFeatured UITabBarSystemItemTopRated UITabBarSystemItemRecents UITabBarSystemItemContacts UITabBarSystemItemHistory UITabBarSystemItemBookmarks UITabBarSystemItemSearch UITabBarSystemItemDownloads UITabBarSystemItemMostRecent UITabBarSystemItemMostViewed"),
		@"UITableViewCellAccessoryType", _w(@"UITableViewCellAccessoryNone UITableViewCellAccessoryDisclosureIndicator UITableViewCellAccessoryDetailDisclosureButton UITableViewCellAccessoryCheckmark"),
		@"UITableViewCellEditingStyle", _w(@"UITableViewCellEditingStyleNone UITableViewCellEditingStyleDelete UITableViewCellEditingStyleInsert"),
		@"UITableViewCellSelectionStyle", _w(@"UITableViewCellSelectionStyleNone UITableViewCellSelectionStyleBlue UITableViewCellSelectionStyleGray"),
		@"UITableViewCellSeparatorStyle", _w(@"UITableViewCellSeparatorStyleNone UITableViewCellSeparatorStyleSingleLine UITableViewCellSeparatorStyleSingleLineEtched"),
		@"UITableViewCellStyle", _w(@"UITableViewCellStyleDefault UITableViewCellStyleValue1 UITableViewCellStyleValue2 UITableViewCellStyleSubtitle"),
		@"UITableViewRowAnimation", _w(@"UITableViewRowAnimationFade UITableViewRowAnimationRight UITableViewRowAnimationLeft UITableViewRowAnimationTop UITableViewRowAnimationBottom UITableViewRowAnimationNone UITableViewRowAnimationMiddle"),
		@"UITableViewScrollPosition", _w(@"UITableViewScrollPositionNone UITableViewScrollPositionTop UITableViewScrollPositionMiddle UITableViewScrollPositionBottom"),
		@"UITableViewStyle", _w(@"UITableViewStylePlain UITableViewStyleGrouped"),
		@"UITextAlignment", _w(@"UITextAlignmentLeft UITextAlignmentCenter UITextAlignmentRight"),
		@"UITextAutocapitalizationType", _w(@"UITextAutocapitalizationTypeNone UITextAutocapitalizationTypeWords UITextAutocapitalizationTypeSentences UITextAutocapitalizationTypeAllCharacters"),
		@"UITextAutocorrectionType", _w(@"UITextAutocorrectionTypeDefault UITextAutocorrectionTypeNo UITextAutocorrectionTypeYes"),
		@"UITextBorderStyle", _w(@"UITextBorderStyleNone UITextBorderStyleLine UITextBorderStyleBezel UITextBorderStyleRoundedRect"),
		@"UITextFieldViewMode", _w(@"UITextFieldViewModeNever UITextFieldViewModeWhileEditing UITextFieldViewModeUnlessEditing UITextFieldViewModeAlways"),
		@"UITextGranularity", _w(@"UITextGranularityCharacter UITextGranularityWord UITextGranularitySentence UITextGranularityParagraph UITextGranularityLine UITextGranularityDocument"),
		@"UITextLayoutDirection", _w(@"UITextLayoutDirectionRight UITextLayoutDirectionLeft UITextLayoutDirectionUp UITextLayoutDirectionDown"),
		@"UITextStorageDirection", _w(@"UITextStorageDirectionForward UITextStorageDirectionBackward"),
		@"UITextWritingDirection", _w(@"UITextWritingDirectionLeftToRight UITextWritingDirectionRightToLeft"),
		@"UITouchPhase", _w(@"UITouchPhaseBegan UITouchPhaseMoved UITouchPhaseStationary UITouchPhaseEnded UITouchPhaseCancelled"),
		@"UIUserInterfaceIdiom", _w(@"UIUserInterfaceIdiomPhone UIUserInterfaceIdiomPad"),
		@"UIViewAnimationCurve", _w(@"UIViewAnimationCurveEaseInOut UIViewAnimationCurveEaseIn UIViewAnimationCurveEaseOut UIViewAnimationCurveLinear"),
		@"UIViewAnimationTransition", _w(@"UIViewAnimationTransitionNone UIViewAnimationTransitionFlipFromLeft UIViewAnimationTransitionFlipFromRight UIViewAnimationTransitionCurlUp UIViewAnimationTransitionCurlDown"),
		@"UIViewContentMode", _w(@"UIViewContentModeScaleToFill UIViewContentModeScaleAspectFit UIViewContentModeScaleAspectFill UIViewContentModeRedraw UIViewContentModeCenter UIViewContentModeTop UIViewContentModeBottom UIViewContentModeLeft UIViewContentModeRight UIViewContentModeTopLeft UIViewContentModeTopRight UIViewContentModeBottomLeft UIViewContentModeBottomRight"),
	nil];
}

-(void) load_property_table {
	self.propertyTable = [NSDictionary dictionaryWithKeysAndObjects: 
		@"NSObject accessibilityFrame", @"CGRect",
		@"NSObject accessibilityHint", @"NSString",
		@"NSObject accessibilityLabel", @"NSString",
		@"NSObject accessibilityLanguage", @"NSString",
		@"NSObject accessibilityTraits", @"UIAccessibilityTraits",
		@"NSObject accessibilityValue", @"NSString",
		@"NSObject isAccessibilityElement", @"BOOL",
		@"UIAcceleration timestamp", @"NSTimeInterval",
		@"UIAcceleration updateInterval", @"NSTimeInterval",
		@"UIAcceleration x", @"UIAccelerationValue",
		@"UIAcceleration y", @"UIAccelerationValue",
		@"UIAcceleration z", @"UIAccelerationValue",
		@"UIAccessibilityElement accessibilityFrame", @"CGRect",
		@"UIAccessibilityElement accessibilityHint", @"NSString",
		@"UIAccessibilityElement accessibilityLabel", @"NSString",
		@"UIAccessibilityElement accessibilityTraits", @"UIAccessibilityTraits",
		@"UIAccessibilityElement accessibilityValue", @"NSString",
		@"UIAccessibilityElement isAccessibilityElement", @"BOOL",
		@"UIActionSheet actionSheetStyle", @"UIActionSheetStyle",
		@"UIActionSheet cancelButtonIndex", @"NSInteger",
		@"UIActionSheet destructiveButtonIndex", @"NSInteger",
		@"UIActionSheet firstOtherButtonIndex", @"NSInteger",
		@"UIActionSheet numberOfButtons", @"NSInteger",
		@"UIActionSheet title", @"NSString",
		@"UIActionSheet visible", @"BOOL",
		@"UIActivityIndicatorView activityIndicatorViewStyle", @"UIActivityIndicatorViewStyle",
		@"UIActivityIndicatorView hidesWhenStopped", @"BOOL",
		@"UIAlertView cancelButtonIndex", @"NSInteger",
		@"UIAlertView firstOtherButtonIndex", @"NSInteger",
		@"UIAlertView message", @"NSString",
		@"UIAlertView numberOfButtons", @"NSInteger",
		@"UIAlertView title", @"NSString",
		@"UIAlertView visible", @"BOOL",
		@"UIApplication applicationIconBadgeNumber", @"NSInteger",
		@"UIApplication applicationState", @"UIApplicationState",
		@"UIApplication applicationSupportsShakeToEdit", @"BOOL",
		@"UIApplication backgroundTimeRemaining", @"NSTimeInterval",
		@"UIApplication idleTimerDisabled", @"BOOL",
		@"UIApplication keyWindow", @"UIWindow",
		@"UIApplication networkActivityIndicatorVisible", @"BOOL",
		@"UIApplication protectedDataAvailable", @"BOOL",
		@"UIApplication proximitySensingEnabled", @"BOOL",
		@"UIApplication scheduledLocalNotifications", @"NSArray",
		@"UIApplication statusBarFrame", @"CGRect",
		@"UIApplication statusBarHidden", @"BOOL",
		@"UIApplication statusBarOrientation", @"UIInterfaceOrientation",
		@"UIApplication statusBarOrientationAnimationDuration", @"NSTimeInterval",
		@"UIApplication statusBarStyle", @"UIStatusBarStyle",
		@"UIApplication windows", @"NSArray",
		@"UIBarButtonItem action", @"SEL",
		@"UIBarButtonItem customView", @"UIView",
		@"UIBarButtonItem possibleTitles", @"NSSet",
		@"UIBarButtonItem style", @"UIBarButtonItemStyle",
		@"UIBarButtonItem width", @"CGFloat",
		@"UIBarItem enabled", @"BOOL",
		@"UIBarItem image", @"UIImage",
		@"UIBarItem imageInsets", @"UIEdgeInsets",
		@"UIBarItem tag", @"NSInteger",
		@"UIBarItem title", @"NSString",
		@"UIBezierPath CGPath", @"CGPathRef",
		@"UIBezierPath bounds", @"CGRect",
		@"UIBezierPath currentPoint", @"CGPoint",
		@"UIBezierPath flatness", @"CGFloat",
		@"UIBezierPath lineCapStyle", @"CGLineCap",
		@"UIBezierPath lineJoinStyle", @"CGLineJoin",
		@"UIBezierPath lineWidth", @"CGFloat",
		@"UIBezierPath miterLimit", @"CGFloat",
		@"UIBezierPath usesEvenOddFillRule", @"BOOL",
		@"UIButton adjustsImageWhenDisabled", @"BOOL",
		@"UIButton adjustsImageWhenHighlighted", @"BOOL",
		@"UIButton buttonType", @"UIButtonType",
		@"UIButton contentEdgeInsets", @"UIEdgeInsets",
		@"UIButton currentBackgroundImage", @"UIImage",
		@"UIButton currentImage", @"UIImage",
		@"UIButton currentTitle", @"NSString",
		@"UIButton currentTitleColor", @"UIColor",
		@"UIButton currentTitleShadowColor", @"UIColor",
		@"UIButton font", @"UIFont",
		@"UIButton imageEdgeInsets", @"UIEdgeInsets",
		@"UIButton imageView", @"UIImageView",
		@"UIButton lineBreakMode", @"UILineBreakMode",
		@"UIButton reversesTitleShadowWhenHighlighted", @"BOOL",
		@"UIButton showsTouchWhenHighlighted", @"BOOL",
		@"UIButton titleEdgeInsets", @"UIEdgeInsets",
		@"UIButton titleLabel", @"UILabel",
		@"UIButton titleShadowOffset", @"CGSize",
		@"UIColor CGColor", @"CGColorRef",
		@"UIControl contentHorizontalAlignment", @"UIControlContentHorizontalAlignment",
		@"UIControl contentVerticalAlignment", @"UIControlContentVerticalAlignment",
		@"UIControl enabled", @"BOOL",
		@"UIControl highlighted", @"BOOL",
		@"UIControl selected", @"BOOL",
		@"UIControl state", @"UIControlState",
		@"UIControl touchInside", @"BOOL",
		@"UIControl tracking", @"BOOL",
		@"UIDatePicker calendar", @"NSCalendar",
		@"UIDatePicker countDownDuration", @"NSTimeInterval",
		@"UIDatePicker date", @"NSDate",
		@"UIDatePicker datePickerMode", @"UIDatePickerMode",
		@"UIDatePicker locale", @"NSLocale",
		@"UIDatePicker maximumDate", @"NSDate",
		@"UIDatePicker minimumDate", @"NSDate",
		@"UIDatePicker minuteInterval", @"NSInteger",
		@"UIDatePicker timeZone", @"NSTimeZone",
		@"UIDevice batteryLevel", @"float",
		@"UIDevice batteryMonitoringEnabled", @"BOOL",
		@"UIDevice batteryState", @"UIDeviceBatteryState",
		@"UIDevice enableInputClicksWhenVisible", @"BOOL",
		@"UIDevice generatesDeviceOrientationNotifications", @"BOOL",
		@"UIDevice localizedModel", @"NSString",
		@"UIDevice model", @"NSString",
		@"UIDevice multitaskingSupported", @"BOOL",
		@"UIDevice name", @"NSString",
		@"UIDevice orientation", @"UIDeviceOrientation",
		@"UIDevice proximityMonitoringEnabled", @"BOOL",
		@"UIDevice proximityState", @"BOOL",
		@"UIDevice systemName", @"NSString",
		@"UIDevice systemVersion", @"NSString",
		@"UIDevice uniqueIdentifier", @"NSString",
		@"UIDevice userInterfaceIdiom", @"UIUserInterfaceIdiom",
		@"UIDocumentInteractionController UTI", @"NSString",
		@"UIDocumentInteractionController gestureRecognizers", @"NSArray",
		@"UIDocumentInteractionController icons", @"NSArray",
		@"UIEvent subtype", @"UIEventSubtype",
		@"UIEvent timestamp", @"NSTimeInterval",
		@"UIEvent type", @"UIEventType",
		@"UIFont ascender", @"CGFloat",
		@"UIFont capHeight", @"CGFloat",
		@"UIFont descender", @"CGFloat",
		@"UIFont familyName", @"NSString",
		@"UIFont fontName", @"NSString",
		@"UIFont leading", @"CGFloat",
		@"UIFont lineHeight", @"CGFloat",
		@"UIFont pointSize", @"CGFloat",
		@"UIFont xHeight", @"CGFloat",
		@"UIGestureRecognizer cancelsTouchesInView", @"BOOL",
		@"UIGestureRecognizer delaysTouchesBegan", @"BOOL",
		@"UIGestureRecognizer delaysTouchesEnded", @"BOOL",
		@"UIGestureRecognizer enabled", @"BOOL",
		@"UIGestureRecognizer state", @"UIGestureRecognizerState",
		@"UIGestureRecognizer view", @"UIView",
		@"UIImage CGImage", @"CGImageRef",
		@"UIImage imageOrientation", @"UIImageOrientation",
		@"UIImage leftCapWidth", @"NSInteger",
		@"UIImage scale", @"CGFloat",
		@"UIImage size", @"CGSize",
		@"UIImage topCapHeight", @"NSInteger",
		@"UIImagePickerController allowsEditing", @"BOOL",
		@"UIImagePickerController allowsImageEditing", @"BOOL",
		@"UIImagePickerController cameraCaptureMode", @"UIImagePickerControllerCameraCaptureMode",
		@"UIImagePickerController cameraDevice", @"UIImagePickerControllerCameraDevice",
		@"UIImagePickerController cameraFlashMode", @"UIImagePickerControllerCameraFlashMode",
		@"UIImagePickerController cameraOverlayView", @"UIView",
		@"UIImagePickerController cameraViewTransform", @"CGAffineTransform",
		@"UIImagePickerController delegate", @"UIImagePickerControllerDelegate>",
		@"UIImagePickerController mediaTypes", @"NSArray",
		@"UIImagePickerController showsCameraControls", @"BOOL",
		@"UIImagePickerController sourceType", @"UIImagePickerControllerSourceType",
		@"UIImagePickerController videoMaximumDuration", @"NSTimeInterval",
		@"UIImagePickerController videoQuality", @"UIImagePickerControllerQualityType",
		@"UIImageView animationDuration", @"NSTimeInterval",
		@"UIImageView animationImages", @"NSArray",
		@"UIImageView animationRepeatCount", @"NSInteger",
		@"UIImageView highlighted", @"BOOL",
		@"UIImageView highlightedAnimationImages", @"NSArray",
		@"UIImageView highlightedImage", @"UIImage",
		@"UIImageView image", @"UIImage",
		@"UIImageView userInteractionEnabled", @"BOOL",
		@"UILabel adjustsFontSizeToFitWidth", @"BOOL",
		@"UILabel baselineAdjustment", @"UIBaselineAdjustment",
		@"UILabel enabled", @"BOOL",
		@"UILabel font", @"UIFont",
		@"UILabel highlighted", @"BOOL",
		@"UILabel highlightedTextColor", @"UIColor",
		@"UILabel lineBreakMode", @"UILineBreakMode",
		@"UILabel minimumFontSize", @"CGFloat",
		@"UILabel numberOfLines", @"NSInteger",
		@"UILabel shadowColor", @"UIColor",
		@"UILabel shadowOffset", @"CGSize",
		@"UILabel text", @"NSString",
		@"UILabel textAlignment", @"UITextAlignment",
		@"UILabel textColor", @"UIColor",
		@"UILabel userInteractionEnabled", @"BOOL",
		@"UILocalNotification alertAction", @"NSString",
		@"UILocalNotification alertBody", @"NSString",
		@"UILocalNotification alertLaunchImage", @"NSString",
		@"UILocalNotification applicationIconBadgeNumber", @"NSInteger",
		@"UILocalNotification fireDate", @"NSDate",
		@"UILocalNotification hasAction", @"BOOL",
		@"UILocalNotification repeatCalendar", @"NSCalendar",
		@"UILocalNotification repeatInterval", @"NSCalendarUnit",
		@"UILocalNotification soundName", @"NSString",
		@"UILocalNotification timeZone", @"NSTimeZone",
		@"UILocalNotification userInfo", @"NSDictionary",
		@"UILocalizedIndexedCollation sectionIndexTitles", @"NSArray",
		@"UILocalizedIndexedCollation sectionTitles", @"NSArray",
		@"UILongPressGestureRecognizer allowableMovement", @"CGFloat",
		@"UILongPressGestureRecognizer minimumPressDuration", @"CFTimeInterval",
		@"UILongPressGestureRecognizer numberOfTapsRequired", @"NSInteger",
		@"UILongPressGestureRecognizer numberOfTouchesRequired", @"NSInteger",
		@"UIMenuController action", @"SEL",
		@"UIMenuController arrowDirection", @"UIMenuControllerArrowDirection",
		@"UIMenuController menuFrame", @"CGRect",
		@"UIMenuController menuItems", @"NSArray",
		@"UIMenuController menuVisible", @"BOOL",
		@"UIMenuController title", @"NSString",
		@"UINavigationBar backBarButtonItem", @"UIBarButtonItem",
		@"UINavigationBar backItem", @"UINavigationItem",
		@"UINavigationBar barStyle", @"UIBarStyle",
		@"UINavigationBar hidesBackButton", @"BOOL",
		@"UINavigationBar items", @"NSArray",
		@"UINavigationBar leftBarButtonItem", @"UIBarButtonItem",
		@"UINavigationBar prompt", @"NSString",
		@"UINavigationBar rightBarButtonItem", @"UIBarButtonItem",
		@"UINavigationBar tintColor", @"UIColor",
		@"UINavigationBar title", @"NSString",
		@"UINavigationBar titleView", @"UIView",
		@"UINavigationBar topItem", @"UINavigationItem",
		@"UINavigationBar translucent", @"BOOL",
		@"UINavigationController hidesBottomBarWhenPushed", @"BOOL",
		@"UINavigationController navigationBar", @"UINavigationBar",
		@"UINavigationController navigationBarHidden", @"BOOL",
		@"UINavigationController navigationController", @"UINavigationController",
		@"UINavigationController navigationItem", @"UINavigationItem",
		@"UINavigationController toolbar", @"UIToolbar",
		@"UINavigationController toolbarHidden", @"BOOL",
		@"UINavigationController toolbarItems", @"NSArray",
		@"UINavigationController topViewController", @"UIViewController",
		@"UINavigationController viewControllers", @"NSArray",
		@"UINavigationController visibleViewController", @"UIViewController",
		@"UIPageControl currentPage", @"NSInteger",
		@"UIPageControl defersCurrentPageDisplay", @"BOOL",
		@"UIPageControl hidesForSinglePage", @"BOOL",
		@"UIPageControl numberOfPages", @"NSInteger",
		@"UIPanGestureRecognizer maximumNumberOfTouches", @"NSUInteger",
		@"UIPanGestureRecognizer minimumNumberOfTouches", @"NSUInteger",
		@"UIPasteboard URL", @"NSURL",
		@"UIPasteboard URLs", @"NSArray",
		@"UIPasteboard color", @"UIColor",
		@"UIPasteboard colors", @"NSArray",
		@"UIPasteboard image", @"UIImage",
		@"UIPasteboard images", @"NSArray",
		@"UIPasteboard items", @"NSArray",
		@"UIPasteboard string", @"NSString",
		@"UIPasteboard strings", @"NSArray",
		@"UIPickerView numberOfComponents", @"NSInteger",
		@"UIPickerView showsSelectionIndicator", @"BOOL",
		@"UIPinchGestureRecognizer scale", @"CGFloat",
		@"UIPinchGestureRecognizer velocity", @"CGFloat",
		@"UIPopoverController contentSizeForViewInPopover", @"CGSize",
		@"UIPopoverController contentViewController", @"UIViewController",
		@"UIPopoverController modalInPopover", @"BOOL",
		@"UIPopoverController passthroughViews", @"NSArray",
		@"UIPopoverController popoverArrowDirection", @"UIPopoverArrowDirection",
		@"UIPopoverController popoverContentSize", @"CGSize",
		@"UIPopoverController popoverVisible", @"BOOL",
		@"UIPrintFormatter color", @"UIColor",
		@"UIPrintFormatter contentInsets", @"UIEdgeInsets",
		@"UIPrintFormatter font", @"UIFont",
		@"UIPrintFormatter markupText", @"NSString",
		@"UIPrintFormatter maximumContentHeight", @"CGFloat",
		@"UIPrintFormatter maximumContentWidth", @"CGFloat",
		@"UIPrintFormatter pageCount", @"NSInteger",
		@"UIPrintFormatter printPageRenderer", @"UIPrintPageRenderer",
		@"UIPrintFormatter startPage", @"NSInteger",
		@"UIPrintFormatter text", @"NSString",
		@"UIPrintFormatter textAlignment", @"UITextAlignment",
		@"UIPrintFormatter view", @"UIView",
		@"UIPrintInfo duplex", @"UIPrintInfoDuplex",
		@"UIPrintInfo jobName", @"NSString",
		@"UIPrintInfo orientation", @"UIPrintInfoOrientation",
		@"UIPrintInfo outputType", @"UIPrintInfoOutputType",
		@"UIPrintInfo printerID", @"NSString",
		@"UIPrintInteractionController printFormatter", @"UIPrintFormatter",
		@"UIPrintInteractionController printInfo", @"UIPrintInfo",
		@"UIPrintInteractionController printPageRenderer", @"UIPrintPageRenderer",
		@"UIPrintInteractionController printPaper", @"UIPrintPaper",
		@"UIPrintInteractionController printingItems", @"NSArray",
		@"UIPrintInteractionController showsPageRange", @"BOOL",
		@"UIPrintPageRenderer footerHeight", @"CGFloat",
		@"UIPrintPageRenderer headerHeight", @"CGFloat",
		@"UIPrintPageRenderer paperRect", @"CGRect",
		@"UIPrintPageRenderer printFormatters", @"NSArray",
		@"UIPrintPageRenderer printableRect", @"CGRect",
		@"UIProgressView progress", @"float",
		@"UIProgressView progressViewStyle", @"UIProgressViewStyle",
		@"UIResponder undoManager", @"NSUndoManager",
		@"UIRotationGestureRecognizer rotation", @"CGFloat",
		@"UIRotationGestureRecognizer velocity", @"CGFloat",
		@"UIScreen applicationFrame", @"CGRect",
		@"UIScreen availableModes", @"NSArray",
		@"UIScreen bounds", @"CGRect",
		@"UIScreen currentMode", @"UIScreenMode",
		@"UIScreen scale", @"CGFloat",
		@"UIScrollView alwaysBounceHorizontal", @"BOOL",
		@"UIScrollView alwaysBounceVertical", @"BOOL",
		@"UIScrollView bounces", @"BOOL",
		@"UIScrollView bouncesZoom", @"BOOL",
		@"UIScrollView canCancelContentTouches", @"BOOL",
		@"UIScrollView contentInset", @"UIEdgeInsets",
		@"UIScrollView contentOffset", @"CGPoint",
		@"UIScrollView contentSize", @"CGSize",
		@"UIScrollView decelerating", @"BOOL",
		@"UIScrollView decelerationRate", @"float",
		@"UIScrollView delaysContentTouches", @"BOOL",
		@"UIScrollView directionalLockEnabled", @"BOOL",
		@"UIScrollView dragging", @"BOOL",
		@"UIScrollView indicatorStyle", @"UIScrollViewIndicatorStyle",
		@"UIScrollView maximumZoomScale", @"float",
		@"UIScrollView minimumZoomScale", @"float",
		@"UIScrollView pagingEnabled", @"BOOL",
		@"UIScrollView scrollEnabled", @"BOOL",
		@"UIScrollView scrollIndicatorInsets", @"UIEdgeInsets",
		@"UIScrollView scrollsToTop", @"BOOL",
		@"UIScrollView showsHorizontalScrollIndicator", @"BOOL",
		@"UIScrollView showsVerticalScrollIndicator", @"BOOL",
		@"UIScrollView tracking", @"BOOL",
		@"UIScrollView zoomBouncing", @"BOOL",
		@"UIScrollView zoomScale", @"float",
		@"UIScrollView zooming", @"BOOL",
		@"UISearchBar autocapitalizationType", @"UITextAutocapitalizationType",
		@"UISearchBar autocorrectionType", @"UITextAutocorrectionType",
		@"UISearchBar barStyle", @"UIBarStyle",
		@"UISearchBar keyboardType", @"UIKeyboardType",
		@"UISearchBar placeholder", @"NSString",
		@"UISearchBar prompt", @"NSString",
		@"UISearchBar scopeButtonTitles", @"NSArray",
		@"UISearchBar searchResultsButtonSelected", @"BOOL",
		@"UISearchBar selectedScopeButtonIndex", @"NSInteger",
		@"UISearchBar showsBookmarkButton", @"BOOL",
		@"UISearchBar showsCancelButton", @"BOOL",
		@"UISearchBar showsScopeBar", @"BOOL",
		@"UISearchBar showsSearchResultsButton", @"BOOL",
		@"UISearchBar text", @"NSString",
		@"UISearchBar tintColor", @"UIColor",
		@"UISearchBar translucent", @"BOOL",
		@"UISearchDisplayController active", @"BOOL",
		@"UISearchDisplayController searchBar", @"UISearchBar",
		@"UISearchDisplayController searchContentsController", @"UIViewController",
		@"UISearchDisplayController searchResultsTableView", @"UITableView",
		@"UISegmentedControl momentary", @"BOOL",
		@"UISegmentedControl numberOfSegments", @"NSUInteger",
		@"UISegmentedControl segmentedControlStyle", @"UISegmentedControlStyle",
		@"UISegmentedControl selectedSegmentIndex", @"NSInteger",
		@"UISegmentedControl tintColor", @"UIColor",
		@"UISlider continuous", @"BOOL",
		@"UISlider maximumValue", @"float",
		@"UISlider maximumValueImage", @"UIImage",
		@"UISlider minimumValue", @"float",
		@"UISlider minimumValueImage", @"UIImage",
		@"UISlider value", @"float",
		@"UISplitViewController splitViewController", @"UISplitViewController",
		@"UISplitViewController viewControllers", @"NSArray",
		@"UISwipeGestureRecognizer direction", @"UISwipeGestureRecognizerDirection",
		@"UISwipeGestureRecognizer numberOfTouchesRequired", @"NSUInteger",
		@"UISwitch on", @"BOOL",
		@"UITabBar items", @"NSArray",
		@"UITabBar selectedItem", @"UITabBarItem",
		@"UITabBarController customizableViewControllers", @"NSArray",
		@"UITabBarController moreNavigationController", @"UINavigationController",
		@"UITabBarController selectedIndex", @"NSUInteger",
		@"UITabBarController selectedViewController", @"UIViewController",
		@"UITabBarController tabBar", @"UITabBar",
		@"UITabBarController tabBarController", @"UITabBarController",
		@"UITabBarController tabBarItem", @"UITabBarItem",
		@"UITabBarController viewControllers", @"NSArray",
		@"UITabBarItem badgeValue", @"NSString",
		@"UITableView allowsSelection", @"BOOL",
		@"UITableView allowsSelectionDuringEditing", @"BOOL",
		@"UITableView backgroundView", @"UIView",
		@"UITableView editing", @"BOOL",
		@"UITableView row", @"NSUInteger",
		@"UITableView rowHeight", @"CGFloat",
		@"UITableView section", @"NSUInteger",
		@"UITableView sectionFooterHeight", @"CGFloat",
		@"UITableView sectionHeaderHeight", @"CGFloat",
		@"UITableView sectionIndexMinimumDisplayRowCount", @"NSInteger",
		@"UITableView separatorColor", @"UIColor",
		@"UITableView separatorStyle", @"UITableViewCellSeparatorStyle",
		@"UITableView style", @"UITableViewStyle",
		@"UITableView tableFooterView", @"UIView",
		@"UITableView tableHeaderView", @"UIView",
		@"UITableViewCell accessoryAction", @"SEL",
		@"UITableViewCell accessoryType", @"UITableViewCellAccessoryType",
		@"UITableViewCell accessoryView", @"UIView",
		@"UITableViewCell backgroundView", @"UIView",
		@"UITableViewCell contentView", @"UIView",
		@"UITableViewCell detailTextLabel", @"UILabel",
		@"UITableViewCell editAction", @"SEL",
		@"UITableViewCell editing", @"BOOL",
		@"UITableViewCell editingAccessoryType", @"UITableViewCellAccessoryType",
		@"UITableViewCell editingAccessoryView", @"UIView",
		@"UITableViewCell editingStyle", @"UITableViewCellEditingStyle",
		@"UITableViewCell font", @"UIFont",
		@"UITableViewCell hidesAccessoryWhenEditing", @"BOOL",
		@"UITableViewCell highlighted", @"BOOL",
		@"UITableViewCell image", @"UIImage",
		@"UITableViewCell imageView", @"UIImageView",
		@"UITableViewCell indentationLevel", @"NSInteger",
		@"UITableViewCell indentationWidth", @"CGFloat",
		@"UITableViewCell lineBreakMode", @"UILineBreakMode",
		@"UITableViewCell reuseIdentifier", @"NSString",
		@"UITableViewCell selected", @"BOOL",
		@"UITableViewCell selectedBackgroundView", @"UIView",
		@"UITableViewCell selectedImage", @"UIImage",
		@"UITableViewCell selectedTextColor", @"UIColor",
		@"UITableViewCell selectionStyle", @"UITableViewCellSelectionStyle",
		@"UITableViewCell shouldIndentWhileEditing", @"BOOL",
		@"UITableViewCell showingDeleteConfirmation", @"BOOL",
		@"UITableViewCell showsReorderControl", @"BOOL",
		@"UITableViewCell text", @"NSString",
		@"UITableViewCell textAlignment", @"UITextAlignment",
		@"UITableViewCell textColor", @"UIColor",
		@"UITableViewCell textLabel", @"UILabel",
		@"UITableViewController clearsSelectionOnViewWillAppear", @"BOOL",
		@"UITableViewController tableView", @"UITableView",
		@"UITapGestureRecognizer numberOfTapsRequired", @"NSUInteger",
		@"UITapGestureRecognizer numberOfTouchesRequired", @"NSUInteger",
		@"UITextField adjustsFontSizeToFitWidth", @"BOOL",
		@"UITextField background", @"UIImage",
		@"UITextField borderStyle", @"UITextBorderStyle",
		@"UITextField clearButtonMode", @"UITextFieldViewMode",
		@"UITextField clearsOnBeginEditing", @"BOOL",
		@"UITextField disabledBackground", @"UIImage",
		@"UITextField editing", @"BOOL",
		@"UITextField font", @"UIFont",
		@"UITextField leftView", @"UIView",
		@"UITextField leftViewMode", @"UITextFieldViewMode",
		@"UITextField minimumFontSize", @"CGFloat",
		@"UITextField placeholder", @"NSString",
		@"UITextField rightView", @"UIView",
		@"UITextField rightViewMode", @"UITextFieldViewMode",
		@"UITextField text", @"NSString",
		@"UITextField textAlignment", @"UITextAlignment",
		@"UITextField textColor", @"UIColor",
		@"UITextPosition empty", @"BOOL",
		@"UITextPosition end", @"UITextPosition",
		@"UITextPosition primaryLanguage", @"NSString",
		@"UITextPosition start", @"UITextPosition",
		@"UITextView dataDetectorTypes", @"UIDataDetectorTypes",
		@"UITextView editable", @"BOOL",
		@"UITextView font", @"UIFont",
		@"UITextView selectedRange", @"NSRange",
		@"UITextView text", @"NSString",
		@"UITextView textAlignment", @"UITextAlignment",
		@"UITextView textColor", @"UIColor",
		@"UIToolbar barStyle", @"UIBarStyle",
		@"UIToolbar items", @"NSArray",
		@"UIToolbar tintColor", @"UIColor",
		@"UIToolbar translucent", @"BOOL",
		@"UITouch gestureRecognizers", @"NSArray",
		@"UITouch phase", @"UITouchPhase",
		@"UITouch tapCount", @"NSUInteger",
		@"UITouch timestamp", @"NSTimeInterval",
		@"UITouch view", @"UIView",
		@"UITouch window", @"UIWindow",
		@"UIVideoEditorController delegate", @"UIVideoEditorControllerDelegate>",
		@"UIVideoEditorController videoMaximumDuration", @"NSTimeInterval",
		@"UIVideoEditorController videoPath", @"NSString",
		@"UIVideoEditorController videoQuality", @"UIImagePickerControllerQualityType",
		@"UIView alpha", @"CGFloat",
		@"UIView autoresizesSubviews", @"BOOL",
		@"UIView autoresizingMask", @"UIViewAutoresizing",
		@"UIView backgroundColor", @"UIColor",
		@"UIView bounds", @"CGRect",
		@"UIView center", @"CGPoint",
		@"UIView clearsContextBeforeDrawing", @"BOOL",
		@"UIView clipsToBounds", @"BOOL",
		@"UIView contentMode", @"UIViewContentMode",
		@"UIView contentScaleFactor", @"CGFloat",
		@"UIView contentStretch", @"CGRect",
		@"UIView exclusiveTouch", @"BOOL",
		@"UIView frame", @"CGRect",
		@"UIView gestureRecognizers", @"NSArray",
		@"UIView hidden", @"BOOL",
		@"UIView layer", @"CALayer",
		@"UIView multipleTouchEnabled", @"BOOL",
		@"UIView opaque", @"BOOL",
		@"UIView subviews", @"NSArray",
		@"UIView superview", @"UIView",
		@"UIView tag", @"NSInteger",
		@"UIView transform", @"CGAffineTransform",
		@"UIView userInteractionEnabled", @"BOOL",
		@"UIView window", @"UIWindow",
		@"UIViewController editing", @"BOOL",
		@"UIViewController interfaceOrientation", @"UIInterfaceOrientation",
		@"UIViewController modalPresentationStyle", @"UIModalPresentationStyle",
		@"UIViewController modalTransitionStyle", @"UIModalTransitionStyle",
		@"UIViewController modalViewController", @"UIViewController",
		@"UIViewController nibBundle", @"NSBundle",
		@"UIViewController nibName", @"NSString",
		@"UIViewController parentViewController", @"UIViewController",
		@"UIViewController searchDisplayController", @"UISearchDisplayController",
		@"UIViewController title", @"NSString",
		@"UIViewController view", @"UIView",
		@"UIViewController wantsFullScreenLayout", @"BOOL",
		@"UIWebView allowsInlineMediaPlayback", @"BOOL",
		@"UIWebView canGoBack", @"BOOL",
		@"UIWebView canGoForward", @"BOOL",
		@"UIWebView dataDetectorTypes", @"UIDataDetectorTypes",
		@"UIWebView detectsPhoneNumbers", @"BOOL",
		@"UIWebView loading", @"BOOL",
		@"UIWebView mediaPlaybackRequiresUserAction", @"BOOL",
		@"UIWebView request", @"NSURLRequest",
		@"UIWebView scalesPageToFit", @"BOOL",
		@"UIWindow keyWindow", @"BOOL",
		@"UIWindow rootViewController", @"UIViewController",
		@"UIWindow screen", @"UIScreen",
		@"UIWindow windowLevel", @"UIWindowLevel",
	nil];
}

-(id) init {
	self = [super init];
	if (self) {
       [self load_typedef_table];
       [self load_property_table];
	}
	return self;
}

- (void)dealloc {
	[typedefTable release];
	[propertyTable release];
    [super dealloc];
}

@end

