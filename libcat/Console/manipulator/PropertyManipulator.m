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

@implementation PropertyManipulator
@synthesize navigationController;
@synthesize typeInfoTable;

-(NSString*) manipulate:(id)targetObject {
	[[UIApplication sharedApplication].keyWindow addSubview:navigationController.view];
	[navigationController.topViewController performSelector:@selector(manipulateTargetObject:) withObject:targetObject];
	return SWF(@"%@ %@", NSLocalizedString(@"manipulate", nil), targetObject);
}

-(BOOL) isVisible {
	return nil != navigationController.view.superview;
}

-(void) hide {
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