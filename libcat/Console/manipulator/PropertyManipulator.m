//
//  PropertyManipulator.m
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "PropertyManipulator.h"
#import "PropertyRootViewController.h"
#import "Logger.h"
#import "NSStringExt.h"
#import "iPadExt.h"
#import "NSObjectExt.h"
#import "NSArrayExt.h"
#import "Inspect.h"
#import <objc/message.h>
#import <UIKit/UIColor.h>

@implementation PropertyManipulator
@synthesize navigationController;
@synthesize typeInfoTable;

-(NSString*) list_properties:(id)targetObject {
	NSArray* hierarchyData = [targetObject class_hierarchy];
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 0; idx < hierarchyData.count - 1; idx++) {
		Class targetClass = [hierarchyData objectAtIndex:idx];
		[ary addObject:SWF(@"== %@ ==", NSStringFromClass(targetClass))];
		NSArray* propertiesData = [targetObject class_properties:targetClass];
		for (NSArray* trio in propertiesData) {
			NSString* propertyName = [trio objectAtFirst];
			id obj = [trio objectAtSecond];
			NSArray* attributes = [trio objectAtThird];
			NSString* attributeString = [attributes objectAtFirst];
			NSString* attributeStringAndReadonly = nil;
#define STR_ATTRIBUTE_READONLY @"R"
#define JUSTIFY_PROPERTY_NAME 31
#define JUSTIFY_OBJECT 47
#define JUSTIFY_ATTRIBUTE_STRING 25
			if ([attributes containsObject:STR_ATTRIBUTE_READONLY]) {
				attributeStringAndReadonly = SWF(@"%@ %@", [attributeString truncate:JUSTIFY_ATTRIBUTE_STRING], STR_ATTRIBUTE_READONLY);
			} else {
				attributeStringAndReadonly = SWF(@"%@", [attributeString truncate:JUSTIFY_ATTRIBUTE_STRING]);
			}
			NSString* objectDetail = [PROPERTYMAN.typeInfoTable objectDescription:obj targetClass:NSStringFromClass(targetClass) propertyName:propertyName];
			NSString* line = SWF(@"    %@   %@   %@", [propertyName ljust:JUSTIFY_PROPERTY_NAME], [[SWF(@"%@", objectDetail) truncate:JUSTIFY_OBJECT] ljust:JUSTIFY_OBJECT], attributeStringAndReadonly);
			[ary addObject:line];
		}
	}
	return [ary join:LF];
}

-(NSString*) manipulate:(id)targetObject {
	[[UIApplication sharedApplication].keyWindow addSubview:navigationController.view];
	[navigationController.topViewController performSelector:@selector(manipulateTargetObject:) withObject:targetObject];
	return SWF(@"%@ %@", NSLocalizedString(@"manipulate", nil), targetObject);
}

-(BOOL) isVisible {
	return nil != navigationController.view.superview;
}

-(void) hide {
	[navigationController popToRootViewControllerAnimated:false];
	[navigationController.view removeFromSuperview];
}

-(id) performTypeClassMethod:(id)str targetObject:(id)targetObject propertyName:(NSString*)propertyName failed:(BOOL*)failed {
	for (Class targetClass in [targetObject superclasses]) {
		NSString* typeKey = SWF(@"%@ %@", targetClass, propertyName);
		id typeClassName = [typeInfoTable.propertyTable objectForKey:typeKey];
		if (nil != typeClassName && [typeClassName hasPrefix:@"UI"]) {
			Class typeKlass = NSClassFromString(typeClassName);
			SEL sel = NSSelectorFromString(str);
			Method method = class_getClassMethod(typeKlass, sel);
			if (NULL == method) {
				*failed = true;
			} else {
				id obj = objc_msgSend(typeKlass, sel);
				return obj;
			}
		}
	}
	return nil;
}

+(PropertyManipulator*) sharedManipulator {
	static PropertyManipulator*	manager = nil;
	if (!manager) {
		manager = [PropertyManipulator new];
	}
	return manager;
}

-(id) init {
	self = [super init];
	if (self) {
		PropertyRootViewController* rootViewController = [[PropertyRootViewController alloc] initWithNibName:@"PropertyRootViewController" bundle:nil];
		self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
		[rootViewController release];
		self.typeInfoTable = [[TypeInfoTable alloc] init];
	}
	return self;
}


-(void)dealloc {
	[navigationController release];
	[typeInfoTable release];
	[super dealloc];
}

@end