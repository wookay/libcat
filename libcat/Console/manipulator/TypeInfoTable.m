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
		@"NSLayoutAttribute", _w(@"NSLayoutAttributeLeft NSLayoutAttributeRight NSLayoutAttributeTop NSLayoutAttributeBottom NSLayoutAttributeLeading NSLayoutAttributeTrailing NSLayoutAttributeWidth NSLayoutAttributeHeight NSLayoutAttributeCenterX NSLayoutAttributeCenterY NSLayoutAttributeBaseline NSLayoutAttributeNotAnAttribute"),
		@"NSLayoutRelation", _w(@"NSLayoutRelationLessThanOrEqual NSLayoutRelationEqual NSLayoutRelationGreaterThanOrEqual"),
		@"UIAccessibilityScrollDirection", _w(@"UIAccessibilityScrollDirectionRight UIAccessibilityScrollDirectionLeft UIAccessibilityScrollDirectionUp UIAccessibilityScrollDirectionDown UIAccessibilityScrollDirectionNext UIAccessibilityScrollDirectionPrevious"),
		@"UIActionSheetStyle", _w(@"UIActionSheetStyleAutomatic UIActionSheetStyleDefault UIActionSheetStyleBlackTranslucent UIActionSheetStyleBlackOpaque"),
		@"UIActivityIndicatorViewStyle", _w(@"UIActivityIndicatorViewStyleWhiteLarge UIActivityIndicatorViewStyleWhite UIActivityIndicatorViewStyleGray"),
		@"UIAlertViewStyle", _w(@"UIAlertViewStyleDefault UIAlertViewStyleSecureTextInput UIAlertViewStylePlainTextInput UIAlertViewStyleLoginAndPasswordInput"),
		@"UIBarButtonItemStyle", _w(@"UIBarButtonItemStylePlain UIBarButtonItemStyleBordered UIBarButtonItemStyleDone"),
		@"UIBarButtonSystemItem", _w(@"UIBarButtonSystemItemDone UIBarButtonSystemItemCancel UIBarButtonSystemItemEdit UIBarButtonSystemItemSave UIBarButtonSystemItemAdd UIBarButtonSystemItemFlexibleSpace UIBarButtonSystemItemFixedSpace UIBarButtonSystemItemCompose UIBarButtonSystemItemReply UIBarButtonSystemItemAction UIBarButtonSystemItemOrganize UIBarButtonSystemItemBookmarks UIBarButtonSystemItemSearch UIBarButtonSystemItemRefresh UIBarButtonSystemItemStop UIBarButtonSystemItemCamera UIBarButtonSystemItemTrash UIBarButtonSystemItemPlay UIBarButtonSystemItemPause UIBarButtonSystemItemRewind UIBarButtonSystemItemFastForward UIBarButtonSystemItemUndo UIBarButtonSystemItemRedo UIBarButtonSystemItemPageCurl"),
		@"UIBarMetrics", _w(@"UIBarMetricsDefault UIBarMetricsLandscapePhone"),
		@"UIBarStyle", _w(@"UIBarStyleDefault UIBarStyleBlack UIBarStyleBlackOpaque UIBarStyleBlackTranslucent"),
		@"UIBaselineAdjustment", _w(@"UIBaselineAdjustmentAlignBaselines UIBaselineAdjustmentAlignCenters UIBaselineAdjustmentNone"),
		@"UIButtonType", _w(@"UIButtonTypeCustom UIButtonTypeRoundedRect UIButtonTypeDetailDisclosure UIButtonTypeInfoLight UIButtonTypeInfoDark UIButtonTypeContactAdd"),
		@"UICollectionUpdateAction", _w(@"UICollectionUpdateActionInsert UICollectionUpdateActionDelete UICollectionUpdateActionReload UICollectionUpdateActionMove UICollectionUpdateActionNone"),
		@"UICollectionViewScrollDirection", _w(@"UICollectionViewScrollDirectionVertical UICollectionViewScrollDirectionHorizontal"),
		@"UIControlContentHorizontalAlignment", _w(@"UIControlContentHorizontalAlignmentCenter UIControlContentHorizontalAlignmentLeft UIControlContentHorizontalAlignmentRight UIControlContentHorizontalAlignmentFill"),
		@"UIControlContentVerticalAlignment", _w(@"UIControlContentVerticalAlignmentCenter UIControlContentVerticalAlignmentTop UIControlContentVerticalAlignmentBottom UIControlContentVerticalAlignmentFill"),
		@"UIDatePickerMode", _w(@"UIDatePickerModeTime UIDatePickerModeDate UIDatePickerModeDateAndTime UIDatePickerModeCountDownTimer"),
		@"UIDeviceBatteryState", _w(@"UIDeviceBatteryStateUnknown UIDeviceBatteryStateUnplugged UIDeviceBatteryStateCharging UIDeviceBatteryStateFull"),
		@"UIDeviceOrientation", _w(@"UIDeviceOrientationUnknown UIDeviceOrientationPortrait UIDeviceOrientationPortraitUpsideDown UIDeviceOrientationLandscapeLeft UIDeviceOrientationLandscapeRight UIDeviceOrientationFaceUp UIDeviceOrientationFaceDown"),
		@"UIDocumentChangeKind", _w(@"UIDocumentChangeDone UIDocumentChangeUndone UIDocumentChangeRedone UIDocumentChangeCleared"),
		@"UIDocumentSaveOperation", _w(@"UIDocumentSaveForCreating UIDocumentSaveForOverwriting"),
		@"UIEventSubtype", _w(@"UIEventSubtypeNone UIEventSubtypeMotionShake UIEventSubtypeRemoteControlPlay UIEventSubtypeRemoteControlPause UIEventSubtypeRemoteControlStop UIEventSubtypeRemoteControlTogglePlayPause UIEventSubtypeRemoteControlNextTrack UIEventSubtypeRemoteControlPreviousTrack UIEventSubtypeRemoteControlBeginSeekingBackward UIEventSubtypeRemoteControlEndSeekingBackward UIEventSubtypeRemoteControlBeginSeekingForward UIEventSubtypeRemoteControlEndSeekingForward"),
		@"UIEventType", _w(@"UIEventTypeTouches UIEventTypeMotion UIEventTypeRemoteControl"),
		@"UIGestureRecognizerState", _w(@"UIGestureRecognizerStatePossible UIGestureRecognizerStateBegan UIGestureRecognizerStateChanged UIGestureRecognizerStateEnded UIGestureRecognizerStateCancelled UIGestureRecognizerStateFailed UIGestureRecognizerStateRecognized"),
		@"UIImageOrientation", _w(@"UIImageOrientationUp UIImageOrientationDown UIImageOrientationLeft UIImageOrientationRight UIImageOrientationUpMirrored UIImageOrientationDownMirrored UIImageOrientationLeftMirrored UIImageOrientationRightMirrored"),
		@"UIImagePickerControllerCameraCaptureMode", _w(@"UIImagePickerControllerCameraCaptureModePhoto UIImagePickerControllerCameraCaptureModeVideo"),
		@"UIImagePickerControllerCameraDevice", _w(@"UIImagePickerControllerCameraDeviceRear UIImagePickerControllerCameraDeviceFront"),
		@"UIImagePickerControllerCameraFlashMode", _w(@"UIImagePickerControllerCameraFlashModeOff UIImagePickerControllerCameraFlashModeAuto UIImagePickerControllerCameraFlashModeOn"),
		@"UIImagePickerControllerQualityType", _w(@"UIImagePickerControllerQualityTypeHigh UIImagePickerControllerQualityTypeMedium UIImagePickerControllerQualityTypeLow UIImagePickerControllerQualityType640x480 UIImagePickerControllerQualityTypeIFrame1280x720 UIImagePickerControllerQualityTypeIFrame960x540"),
		@"UIImagePickerControllerSourceType", _w(@"UIImagePickerControllerSourceTypePhotoLibrary UIImagePickerControllerSourceTypeCamera UIImagePickerControllerSourceTypeSavedPhotosAlbum"),
		@"UIImageResizingMode", _w(@"UIImageResizingModeTile UIImageResizingModeStretch"),
		@"UIInterfaceOrientation", _w(@"UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight"),
		@"UIKeyboardAppearance", _w(@"UIKeyboardAppearanceDefault UIKeyboardAppearanceAlert"),
		@"UIKeyboardType", _w(@"UIKeyboardTypeDefault UIKeyboardTypeASCIICapable UIKeyboardTypeNumbersAndPunctuation UIKeyboardTypeURL UIKeyboardTypeNumberPad UIKeyboardTypePhonePad UIKeyboardTypeNamePhonePad UIKeyboardTypeEmailAddress UIKeyboardTypeDecimalPad UIKeyboardTypeTwitter UIKeyboardTypeAlphabet"),
		@"UILayoutConstraintAxis", _w(@"UILayoutConstraintAxisHorizontal UILayoutConstraintAxisVertical"),
		@"UIMenuControllerArrowDirection", _w(@"UIMenuControllerArrowDefault UIMenuControllerArrowUp UIMenuControllerArrowDown UIMenuControllerArrowLeft UIMenuControllerArrowRight"),
		@"UIModalPresentationStyle", _w(@"UIModalPresentationFullScreen UIModalPresentationPageSheet UIModalPresentationFormSheet UIModalPresentationCurrentContext"),
		@"UIModalTransitionStyle", _w(@"UIModalTransitionStyleCoverVertical UIModalTransitionStyleFlipHorizontal UIModalTransitionStyleCrossDissolve UIModalTransitionStylePartialCurl"),
		@"UIPageViewControllerNavigationDirection", _w(@"UIPageViewControllerNavigationDirectionForward UIPageViewControllerNavigationDirectionReverse"),
		@"UIPageViewControllerNavigationOrientation", _w(@"UIPageViewControllerNavigationOrientationHorizontal UIPageViewControllerNavigationOrientationVertical"),
		@"UIPageViewControllerSpineLocation", _w(@"UIPageViewControllerSpineLocationNone UIPageViewControllerSpineLocationMin UIPageViewControllerSpineLocationMid UIPageViewControllerSpineLocationMax"),
		@"UIPageViewControllerTransitionStyle", _w(@"UIPageViewControllerTransitionStylePageCurl UIPageViewControllerTransitionStyleScroll"),
		@"UIPrintInfoDuplex", _w(@"UIPrintInfoDuplexNone UIPrintInfoDuplexLongEdge UIPrintInfoDuplexShortEdge"),
		@"UIPrintInfoOrientation", _w(@"UIPrintInfoOrientationPortrait UIPrintInfoOrientationLandscape"),
		@"UIPrintInfoOutputType", _w(@"UIPrintInfoOutputGeneral UIPrintInfoOutputPhoto UIPrintInfoOutputGrayscale"),
		@"UIProgressViewStyle", _w(@"UIProgressViewStyleDefault UIProgressViewStyleBar"),
		@"UIRemoteNotificationType", _w(@"UIRemoteNotificationTypeNone UIRemoteNotificationTypeBadge UIRemoteNotificationTypeSound UIRemoteNotificationTypeAlert UIRemoteNotificationTypeNewsstandContentAvailability"),
		@"UIReturnKeyType", _w(@"UIReturnKeyDefault UIReturnKeyGo UIReturnKeyGoogle UIReturnKeyJoin UIReturnKeyNext UIReturnKeyRoute UIReturnKeySearch UIReturnKeySend UIReturnKeyYahoo UIReturnKeyDone UIReturnKeyEmergencyCall"),
		@"UIScreenOverscanCompensation", _w(@"UIScreenOverscanCompensationScale UIScreenOverscanCompensationInsetBounds UIScreenOverscanCompensationInsetApplicationFrame"),
		@"UIScrollViewIndicatorStyle", _w(@"UIScrollViewIndicatorStyleDefault UIScrollViewIndicatorStyleBlack UIScrollViewIndicatorStyleWhite"),
		@"UISearchBarIcon", _w(@"UISearchBarIconSearch UISearchBarIconClear UISearchBarIconBookmark UISearchBarIconResultsList"),
		@"UISegmentedControlSegment", _w(@"UISegmentedControlSegmentAny UISegmentedControlSegmentLeft UISegmentedControlSegmentCenter UISegmentedControlSegmentRight UISegmentedControlSegmentAlone"),
		@"UISegmentedControlStyle", _w(@"UISegmentedControlStylePlain UISegmentedControlStyleBordered UISegmentedControlStyleBar UISegmentedControlStyleBezeled"),
		@"UIStatusBarAnimation", _w(@"UIStatusBarAnimationNone UIStatusBarAnimationFade UIStatusBarAnimationSlide"),
		@"UIStatusBarStyle", _w(@"UIStatusBarStyleDefault UIStatusBarStyleBlackTranslucent UIStatusBarStyleBlackOpaque"),
		@"UITabBarSystemItem", _w(@"UITabBarSystemItemMore UITabBarSystemItemFavorites UITabBarSystemItemFeatured UITabBarSystemItemTopRated UITabBarSystemItemRecents UITabBarSystemItemContacts UITabBarSystemItemHistory UITabBarSystemItemBookmarks UITabBarSystemItemSearch UITabBarSystemItemDownloads UITabBarSystemItemMostRecent UITabBarSystemItemMostViewed"),
		@"UITableViewCellAccessoryType", _w(@"UITableViewCellAccessoryNone UITableViewCellAccessoryDisclosureIndicator UITableViewCellAccessoryDetailDisclosureButton UITableViewCellAccessoryCheckmark"),
		@"UITableViewCellEditingStyle", _w(@"UITableViewCellEditingStyleNone UITableViewCellEditingStyleDelete UITableViewCellEditingStyleInsert"),
		@"UITableViewCellSelectionStyle", _w(@"UITableViewCellSelectionStyleNone UITableViewCellSelectionStyleBlue UITableViewCellSelectionStyleGray"),
		@"UITableViewCellSeparatorStyle", _w(@"UITableViewCellSeparatorStyleNone UITableViewCellSeparatorStyleSingleLine UITableViewCellSeparatorStyleSingleLineEtched"),
		@"UITableViewCellStyle", _w(@"UITableViewCellStyleDefault UITableViewCellStyleValue1 UITableViewCellStyleValue2 UITableViewCellStyleSubtitle"),
		@"UITableViewRowAnimation", _w(@"UITableViewRowAnimationFade UITableViewRowAnimationRight UITableViewRowAnimationLeft UITableViewRowAnimationTop UITableViewRowAnimationBottom UITableViewRowAnimationNone UITableViewRowAnimationMiddle UITableViewRowAnimationAutomatic"),
		@"UITableViewScrollPosition", _w(@"UITableViewScrollPositionNone UITableViewScrollPositionTop UITableViewScrollPositionMiddle UITableViewScrollPositionBottom"),
		@"UITableViewStyle", _w(@"UITableViewStylePlain UITableViewStyleGrouped"),
		@"UITextAutocapitalizationType", _w(@"UITextAutocapitalizationTypeNone UITextAutocapitalizationTypeWords UITextAutocapitalizationTypeSentences UITextAutocapitalizationTypeAllCharacters"),
		@"UITextAutocorrectionType", _w(@"UITextAutocorrectionTypeDefault UITextAutocorrectionTypeNo UITextAutocorrectionTypeYes"),
		@"UITextBorderStyle", _w(@"UITextBorderStyleNone UITextBorderStyleLine UITextBorderStyleBezel UITextBorderStyleRoundedRect"),
		@"UITextFieldViewMode", _w(@"UITextFieldViewModeNever UITextFieldViewModeWhileEditing UITextFieldViewModeUnlessEditing UITextFieldViewModeAlways"),
		@"UITextGranularity", _w(@"UITextGranularityCharacter UITextGranularityWord UITextGranularitySentence UITextGranularityParagraph UITextGranularityLine UITextGranularityDocument"),
		@"UITextLayoutDirection", _w(@"UITextLayoutDirectionRight UITextLayoutDirectionLeft UITextLayoutDirectionUp UITextLayoutDirectionDown"),
		@"UITextStorageDirection", _w(@"UITextStorageDirectionForward UITextStorageDirectionBackward"),
		@"UITextWritingDirection", _w(@"UITextWritingDirectionNatural UITextWritingDirectionLeftToRight UITextWritingDirectionRightToLeft"),
		@"UIToolbarPosition", _w(@"UIToolbarPositionAny UIToolbarPositionBottom UIToolbarPositionTop"),
		@"UITouchPhase", _w(@"UITouchPhaseBegan UITouchPhaseMoved UITouchPhaseStationary UITouchPhaseEnded UITouchPhaseCancelled"),
		@"UIUserInterfaceIdiom", _w(@"UIUserInterfaceIdiomPhone UIUserInterfaceIdiomPad"),
		@"UIViewAnimationCurve", _w(@"UIViewAnimationCurveEaseInOut UIViewAnimationCurveEaseIn UIViewAnimationCurveEaseOut UIViewAnimationCurveLinear"),
		@"UIViewAnimationOptions", _w(@"UIViewAnimationOptionLayoutSubviews UIViewAnimationOptionAllowUserInteraction UIViewAnimationOptionBeginFromCurrentState UIViewAnimationOptionRepeat UIViewAnimationOptionAutoreverse UIViewAnimationOptionOverrideInheritedDuration UIViewAnimationOptionOverrideInheritedCurve UIViewAnimationOptionAllowAnimatedContent UIViewAnimationOptionShowHideTransitionViews UIViewAnimationOptionCurveEaseInOut UIViewAnimationOptionCurveEaseIn UIViewAnimationOptionCurveEaseOut UIViewAnimationOptionCurveLinear UIViewAnimationOptionTransitionNone UIViewAnimationOptionTransitionFlipFromLeft UIViewAnimationOptionTransitionFlipFromRight UIViewAnimationOptionTransitionCurlUp UIViewAnimationOptionTransitionCurlDown UIViewAnimationOptionTransitionCrossDissolve UIViewAnimationOptionTransitionFlipFromTop UIViewAnimationOptionTransitionFlipFromBottom"),
		@"UIViewAnimationTransition", _w(@"UIViewAnimationTransitionNone UIViewAnimationTransitionFlipFromLeft UIViewAnimationTransitionFlipFromRight UIViewAnimationTransitionCurlUp UIViewAnimationTransitionCurlDown"),
		@"UIViewContentMode", _w(@"UIViewContentModeScaleToFill UIViewContentModeScaleAspectFit UIViewContentModeScaleAspectFill UIViewContentModeRedraw UIViewContentModeCenter UIViewContentModeTop UIViewContentModeBottom UIViewContentModeLeft UIViewContentModeRight UIViewContentModeTopLeft UIViewContentModeTopRight UIViewContentModeBottomLeft UIViewContentModeBottomRight"),
		@"UIWebViewNavigationType", _w(@"UIWebViewNavigationTypeLinkClicked UIWebViewNavigationTypeFormSubmitted UIWebViewNavigationTypeBackForward UIWebViewNavigationTypeReload UIWebViewNavigationTypeFormResubmitted UIWebViewNavigationTypeOther"),
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
		@"NSShadow shadowBlurRadius", @"CGFloat",
		@"NSShadow shadowOffset", @"CGSize",
		@"NSStringDrawingContext actualScaleFactor", @"CGFloat",
		@"NSStringDrawingContext actualTrackingAdjustment", @"CGFloat",
		@"NSStringDrawingContext minimumScaleFactor", @"CGFloat",
		@"NSStringDrawingContext minimumTrackingAdjustment", @"CGFloat",
		@"NSStringDrawingContext totalBounds", @"CGRect",
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
		@"UIActivityItemProvider activityType", @"NSString",
		@"UIActivityViewController completionHandler", @"UIActivityViewControllerCompletionHandler",
		@"UIActivityViewController excludedActivityTypes", @"NSArray",
		@"UIAlertView cancelButtonIndex", @"NSInteger",
		@"UIAlertView firstOtherButtonIndex", @"NSInteger",
		@"UIAlertView message", @"NSString",
		@"UIAlertView numberOfButtons", @"NSInteger",
		@"UIAlertView title", @"NSString",
		@"UIAlertView visible", @"BOOL",
		@"UIApplication applicationIconBadgeNumber", @"NSInteger",
		@"UIApplication idleTimerDisabled", @"BOOL",
		@"UIApplication keyWindow", @"UIWindow",
		@"UIApplication networkActivityIndicatorVisible", @"BOOL",
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
		@"UIButton imageEdgeInsets", @"UIEdgeInsets",
		@"UIButton reversesTitleShadowWhenHighlighted", @"BOOL",
		@"UIButton showsTouchWhenHighlighted", @"BOOL",
		@"UIButton titleEdgeInsets", @"UIEdgeInsets",
		@"UICollectionReusableView backgroundView", @"UIView",
		@"UICollectionReusableView contentView", @"UIView",
		@"UICollectionReusableView highlighted", @"BOOL",
		@"UICollectionReusableView reuseIdentifier", @"NSString",
		@"UICollectionReusableView selected", @"BOOL",
		@"UICollectionReusableView selectedBackgroundView", @"UIView",
		@"UICollectionView allowsMultipleSelection", @"BOOL",
		@"UICollectionView allowsSelection", @"BOOL",
		@"UICollectionView backgroundView", @"UIView",
		@"UICollectionView collectionViewLayout", @"UICollectionViewLayout",
		@"UICollectionView item", @"NSInteger",
		@"UICollectionViewController clearsSelectionOnViewWillAppear", @"BOOL",
		@"UICollectionViewController collectionView", @"UICollectionView",
		@"UICollectionViewFlowLayout footerReferenceSize", @"CGSize",
		@"UICollectionViewFlowLayout headerReferenceSize", @"CGSize",
		@"UICollectionViewFlowLayout itemSize", @"CGSize",
		@"UICollectionViewFlowLayout minimumInteritemSpacing", @"CGFloat",
		@"UICollectionViewFlowLayout minimumLineSpacing", @"CGFloat",
		@"UICollectionViewFlowLayout scrollDirection", @"UICollectionViewScrollDirection",
		@"UICollectionViewFlowLayout sectionInset", @"UIEdgeInsets",
		@"UICollectionViewLayoutAttributes alpha", @"CGFloat",
		@"UICollectionViewLayoutAttributes center", @"CGPoint",
		@"UICollectionViewLayoutAttributes collectionView", @"UICollectionView",
		@"UICollectionViewLayoutAttributes frame", @"CGRect",
		@"UICollectionViewLayoutAttributes hidden", @"BOOL",
		@"UICollectionViewLayoutAttributes indexPath", @"NSIndexPath",
		@"UICollectionViewLayoutAttributes indexPathAfterUpdate", @"NSIndexPath",
		@"UICollectionViewLayoutAttributes indexPathBeforeUpdate", @"NSIndexPath",
		@"UICollectionViewLayoutAttributes representedElementCategory", @"UICollectionElementCategory",
		@"UICollectionViewLayoutAttributes representedElementKind", @"NSString",
		@"UICollectionViewLayoutAttributes size", @"CGSize",
		@"UICollectionViewLayoutAttributes transform3D", @"CATransform3D",
		@"UICollectionViewLayoutAttributes updateAction", @"UICollectionUpdateAction",
		@"UICollectionViewLayoutAttributes zIndex", @"NSInteger",
		@"UIColor CGColor", @"CGColorRef",
		@"UIColor CIColor", @"CIColor",
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
		@"UIDevice enableInputClicksWhenVisible", @"BOOL",
		@"UIDevice generatesDeviceOrientationNotifications", @"BOOL",
		@"UIDevice localizedModel", @"NSString",
		@"UIDevice model", @"NSString",
		@"UIDevice name", @"NSString",
		@"UIDevice orientation", @"UIDeviceOrientation",
		@"UIDevice systemName", @"NSString",
		@"UIDevice systemVersion", @"NSString",
		@"UIDictationPhrase alternativeInterpretations", @"NSArray",
		@"UIDictationPhrase beginningOfDocument", @"UITextPosition",
		@"UIDictationPhrase containsEnd", @"BOOL",
		@"UIDictationPhrase containsStart", @"BOOL",
		@"UIDictationPhrase empty", @"BOOL",
		@"UIDictationPhrase end", @"UITextPosition",
		@"UIDictationPhrase endOfDocument", @"UITextPosition",
		@"UIDictationPhrase isVertical", @"BOOL",
		@"UIDictationPhrase markedTextRange", @"UITextRange",
		@"UIDictationPhrase markedTextStyle", @"NSDictionary",
		@"UIDictationPhrase primaryLanguage", @"NSString",
		@"UIDictationPhrase rect", @"CGRect",
		@"UIDictationPhrase selectionAffinity", @"UITextStorageDirection",
		@"UIDictationPhrase start", @"UITextPosition",
		@"UIDictationPhrase text", @"NSString",
		@"UIDictationPhrase textInputView", @"UIView",
		@"UIDictationPhrase writingDirection", @"UITextWritingDirection",
		@"UIDocumentInteractionController UTI", @"NSString",
		@"UIDocumentInteractionController gestureRecognizers", @"NSArray",
		@"UIDocumentInteractionController icons", @"NSArray",
		@"UIEvent timestamp", @"NSTimeInterval",
		@"UIFont ascender", @"CGFloat",
		@"UIFont capHeight", @"CGFloat",
		@"UIFont descender", @"CGFloat",
		@"UIFont familyName", @"NSString",
		@"UIFont fontName", @"NSString",
		@"UIFont leading", @"CGFloat",
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
		@"UIImage size", @"CGSize",
		@"UIImage topCapHeight", @"NSInteger",
		@"UIImagePickerController -allowsImageEditing", @"for",
		@"UIImagePickerController delegate", @"UIImagePickerControllerDelegate>",
		@"UIImagePickerController mediaTypes", @"NSArray",
		@"UIImagePickerController sourceType", @"UIImagePickerControllerSourceType",
		@"UIImageView animationDuration", @"NSTimeInterval",
		@"UIImageView animationImages", @"NSArray",
		@"UIImageView animationRepeatCount", @"NSInteger",
		@"UIImageView image", @"UIImage",
		@"UIImageView userInteractionEnabled", @"BOOL",
		@"UILabel adjustsFontSizeToFitWidth", @"BOOL",
		@"UILabel baselineAdjustment", @"UIBaselineAdjustment",
		@"UILabel enabled", @"BOOL",
		@"UILabel font", @"UIFont",
		@"UILabel highlighted", @"BOOL",
		@"UILabel highlightedTextColor", @"UIColor",
		@"UILabel lineBreakMode", @"NSLineBreakMode",
		@"UILabel numberOfLines", @"NSInteger",
		@"UILabel shadowColor", @"UIColor",
		@"UILabel shadowOffset", @"CGSize",
		@"UILabel text", @"NSString",
		@"UILabel textAlignment", @"NSTextAlignment",
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
		@"UILongPressGestureRecognizer numberOfTapsRequired", @"NSUInteger",
		@"UILongPressGestureRecognizer numberOfTouchesRequired", @"NSUInteger",
		@"UIManagedDocument managedObjectContext", @"NSManagedObjectContext",
		@"UIManagedDocument modelConfiguration", @"NSString",
		@"UIManagedDocument persistentStoreOptions", @"NSDictionary",
		@"UIMenuController action", @"SEL",
		@"UIMenuController menuFrame", @"CGRect",
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
		@"UINavigationBar title", @"NSString",
		@"UINavigationBar titleView", @"UIView",
		@"UINavigationBar topItem", @"UINavigationItem",
		@"UINavigationController hidesBottomBarWhenPushed", @"BOOL",
		@"UINavigationController navigationBar", @"UINavigationBar",
		@"UINavigationController navigationBarHidden", @"BOOL",
		@"UINavigationController navigationController", @"UINavigationController",
		@"UINavigationController navigationItem", @"UINavigationItem",
		@"UINavigationController topViewController", @"UIViewController",
		@"UINavigationController viewControllers", @"NSArray",
		@"UINavigationController visibleViewController", @"UIViewController",
		@"UIPageControl currentPage", @"NSInteger",
		@"UIPageControl defersCurrentPageDisplay", @"BOOL",
		@"UIPageControl hidesForSinglePage", @"BOOL",
		@"UIPageControl numberOfPages", @"NSInteger",
		@"UIPageViewController doubleSided", @"BOOL",
		@"UIPageViewController gestureRecognizers", @"NSArray",
		@"UIPageViewController navigationOrientation", @"UIPageViewControllerNavigationOrientation",
		@"UIPageViewController spineLocation", @"UIPageViewControllerSpineLocation",
		@"UIPageViewController transitionStyle", @"UIPageViewControllerTransitionStyle",
		@"UIPageViewController viewControllers", @"NSArray",
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
		@"UIPopoverBackgroundView arrowDirection", @"UIPopoverArrowDirection",
		@"UIPopoverBackgroundView arrowOffset", @"CGFloat",
		@"UIPopoverController contentViewController", @"UIViewController",
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
		@"UIPrintFormatter textAlignment", @"NSTextAlignment",
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
		@"UIRefreshControl refreshing", @"BOOL",
		@"UIRotationGestureRecognizer rotation", @"CGFloat",
		@"UIRotationGestureRecognizer velocity", @"CGFloat",
		@"UIScreen applicationFrame", @"CGRect",
		@"UIScreen bounds", @"CGRect",
		@"UIScrollView alwaysBounceHorizontal", @"BOOL",
		@"UIScrollView alwaysBounceVertical", @"BOOL",
		@"UIScrollView bounces", @"BOOL",
		@"UIScrollView bouncesZoom", @"BOOL",
		@"UIScrollView canCancelContentTouches", @"BOOL",
		@"UIScrollView contentInset", @"UIEdgeInsets",
		@"UIScrollView contentOffset", @"CGPoint",
		@"UIScrollView contentSize", @"CGSize",
		@"UIScrollView decelerating", @"BOOL",
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
		@"UIScrollView zooming", @"BOOL",
		@"UISearchBar autocapitalizationType", @"UITextAutocapitalizationType",
		@"UISearchBar autocorrectionType", @"UITextAutocorrectionType",
		@"UISearchBar barStyle", @"UIBarStyle",
		@"UISearchBar inputAccessoryView", @"UIView",
		@"UISearchBar keyboardType", @"UIKeyboardType",
		@"UISearchBar placeholder", @"NSString",
		@"UISearchBar prompt", @"NSString",
		@"UISearchBar showsBookmarkButton", @"BOOL",
		@"UISearchBar showsCancelButton", @"BOOL",
		@"UISearchBar spellCheckingType", @"UITextSpellCheckingType",
		@"UISearchBar text", @"NSString",
		@"UISearchBar tintColor", @"UIColor",
		@"UISearchDisplayController active", @"BOOL",
		@"UISearchDisplayController searchBar", @"UISearchBar",
		@"UISearchDisplayController searchContentsController", @"UIViewController",
		@"UISearchDisplayController searchResultsTableView", @"UITableView",
		@"UISegmentedControl momentary", @"BOOL",
		@"UISegmentedControl numberOfSegments", @"NSUInteger",
		@"UISegmentedControl segmentedControlStyle", @"UISegmentedControlStyle",
		@"UISegmentedControl selectedSegmentIndex", @"NSInteger",
		@"UISlider continuous", @"BOOL",
		@"UISlider maximumValue", @"float",
		@"UISlider maximumValueImage", @"UIImage",
		@"UISlider minimumValue", @"float",
		@"UISlider minimumValueImage", @"UIImage",
		@"UISlider value", @"float",
		@"UISplitViewController splitViewController", @"UISplitViewController",
		@"UISplitViewController viewControllers", @"NSArray",
		@"UIStepper autorepeat", @"BOOL",
		@"UIStepper continuous", @"BOOL",
		@"UIStepper maximumValue", @"double",
		@"UIStepper minimumValue", @"double",
		@"UIStepper stepValue", @"double",
		@"UIStepper value", @"double",
		@"UIStepper wraps", @"BOOL",
		@"UIStoryboardPopoverSegue popoverController", @"UIPopoverController",
		@"UIStoryboardSegue identifier", @"NSString",
		@"UISwipeGestureRecognizer direction", @"UISwipeGestureRecognizerDirection",
		@"UISwipeGestureRecognizer numberOfTouchesRequired", @"NSUInteger",
		@"UISwitch on", @"BOOL",
		@"UITabBar items", @"NSArray",
		@"UITabBar selectedItem", @"UITabBarItem",
		@"UITabBarController customizableViewControllers", @"NSArray",
		@"UITabBarController moreNavigationController", @"UINavigationController",
		@"UITabBarController selectedIndex", @"NSUInteger",
		@"UITabBarController selectedViewController", @"UIViewController",
		@"UITabBarController tabBarController", @"UITabBarController",
		@"UITabBarController tabBarItem", @"UITabBarItem",
		@"UITabBarController viewControllers", @"NSArray",
		@"UITabBarItem badgeValue", @"NSString",
		@"UITableView allowsSelectionDuringEditing", @"BOOL",
		@"UITableView editing", @"BOOL",
		@"UITableView row", @"NSInteger",
		@"UITableView rowHeight", @"CGFloat",
		@"UITableView section", @"NSInteger",
		@"UITableView sectionFooterHeight", @"CGFloat",
		@"UITableView sectionHeaderHeight", @"CGFloat",
		@"UITableView sectionIndexMinimumDisplayRowCount", @"NSInteger",
		@"UITableView separatorColor", @"UIColor",
		@"UITableView separatorStyle", @"UITableViewCellSeparatorStyle",
		@"UITableView style", @"UITableViewStyle",
		@"UITableView tableFooterView", @"UIView",
		@"UITableView tableHeaderView", @"UIView",
		@"UITableViewCell accessoryType", @"UITableViewCellAccessoryType",
		@"UITableViewCell accessoryView", @"UIView",
		@"UITableViewCell backgroundView", @"UIView",
		@"UITableViewCell contentView", @"UIView",
		@"UITableViewCell editing", @"BOOL",
		@"UITableViewCell editingAccessoryType", @"UITableViewCellAccessoryType",
		@"UITableViewCell editingAccessoryView", @"UIView",
		@"UITableViewCell editingStyle", @"UITableViewCellEditingStyle",
		@"UITableViewCell highlighted", @"BOOL",
		@"UITableViewCell indentationLevel", @"NSInteger",
		@"UITableViewCell indentationWidth", @"CGFloat",
		@"UITableViewCell reuseIdentifier", @"NSString",
		@"UITableViewCell selected", @"BOOL",
		@"UITableViewCell selectedBackgroundView", @"UIView",
		@"UITableViewCell selectionStyle", @"UITableViewCellSelectionStyle",
		@"UITableViewCell shouldIndentWhileEditing", @"BOOL",
		@"UITableViewCell showingDeleteConfirmation", @"BOOL",
		@"UITableViewCell showsReorderControl", @"BOOL",
		@"UITableViewController tableView", @"UITableView",
		@"UITableViewHeaderFooterView backgroundView", @"UIView",
		@"UITableViewHeaderFooterView contentView", @"UIView",
		@"UITableViewHeaderFooterView reuseIdentifier", @"NSString",
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
		@"UITextField textAlignment", @"NSTextAlignment",
		@"UITextField textColor", @"UIColor",
		@"UITextView editable", @"BOOL",
		@"UITextView font", @"UIFont",
		@"UITextView selectedRange", @"NSRange",
		@"UITextView text", @"NSString",
		@"UITextView textAlignment", @"NSTextAlignment",
		@"UITextView textColor", @"UIColor",
		@"UIToolbar barStyle", @"UIBarStyle",
		@"UIToolbar items", @"NSArray",
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
		@"UIView exclusiveTouch", @"BOOL",
		@"UIView frame", @"CGRect",
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
		@"UIViewController nibBundle", @"NSBundle",
		@"UIViewController nibName", @"NSString",
		@"UIViewController parentViewController", @"UIViewController",
		@"UIViewController searchDisplayController", @"UISearchDisplayController",
		@"UIViewController title", @"NSString",
		@"UIViewController view", @"UIView",
		@"UIWebView canGoBack", @"BOOL",
		@"UIWebView canGoForward", @"BOOL",
		@"UIWebView loading", @"BOOL",
		@"UIWebView request", @"NSURLRequest",
		@"UIWebView scalesPageToFit", @"BOOL",
		@"UIWindow keyWindow", @"BOOL",
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

