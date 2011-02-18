//
//  PropertyManipulator.h
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeInfoTable.h"

#define PROPERTYMAN [PropertyManipulator sharedManipulator]

@interface PropertyManipulator : NSObject {
    UINavigationController *navigationController;
	TypeInfoTable* typeInfoTable;
}
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) TypeInfoTable* typeInfoTable;

+ (PropertyManipulator*) sharedManipulator ;
-(NSString*) manipulate:(id)targetObject ;
-(BOOL) isVisible ;
-(void) hide ;
-(NSString*) list_properties:(id)targetObject ;
-(id) performTypeClassMethod:(id)str targetObject:(id)targetObject propertyName:(NSString*)propertyName failed:(BOOL*)failed ;
-(void) showConsoleController ;

@end