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

@implementation PropertyManipulator
@synthesize navigationController;
@synthesize typeInfoTable;

-(NSString*) list_properties:(id)targetObject {
	NSArray* hierarchyData = [targetObject class_hierarchy];
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 0; idx < hierarchyData.count - 1; idx++) {
		Class targetClass = [hierarchyData objectAtIndex:idx];
		[ary addObject:SWF(@"%@", NSStringFromClass(targetClass))];
		NSArray* propertiesData = [targetObject class_properties:targetClass];
		for (NSArray* trio in propertiesData) {
			NSString* propertyName = [trio objectAtFirst];
			id obj = [trio objectAtSecond];
			NSArray* attributes = [trio objectAtThird];
			NSString* attributeString = [attributes objectAtFirst];
#define JUSTIFY_PROPERTY_NAME 37
#define JUSTIFY_OBJECT 35
			NSString* line = SWF(@"    %@   %@   %@", [propertyName ljust:JUSTIFY_PROPERTY_NAME], [[SWF(@"%@", obj) truncate:JUSTIFY_OBJECT] ljust:JUSTIFY_OBJECT], attributeString);
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