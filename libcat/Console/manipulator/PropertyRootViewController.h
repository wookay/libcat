//
//  PropertyRootViewController.h
//  TestApp
//
//  Created by WooKyoung Noh on 12/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPropertyViewController.h"

@interface PropertyRootViewController : UITableViewController <PropertyEditDelegate> {
	id targetObject;
	NSArray* hierarchyData;
	NSArray* propertiesData;
}
@property (nonatomic, assign) id targetObject;
@property (nonatomic, retain) NSArray* hierarchyData;
@property (nonatomic, retain) NSArray* propertiesData;
-(void) load_properties_data ;
-(kObjectAttributeType) objectAttributeTypeForProperty:(NSArray*)trio ;
-(void) manipulateTargetObject:(id)targetObject_ ;
@end
