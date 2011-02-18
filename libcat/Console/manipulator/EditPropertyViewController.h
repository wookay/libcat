//
//  EditPropertyViewController.h
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
	kObjectAttributeTypeNone,
	kObjectAttributeTypeNil,
	kObjectAttributeTypeObject,
	kObjectAttributeTypeString,
	kObjectAttributeTypeInt,
	kObjectAttributeTypeFloat,
	kObjectAttributeTypeStruct,
} kObjectAttributeType;


@protocol PropertyEditDelegate
-(void) updateProperty:(NSString*)propertyName value:(id)value attributeString:(NSString*)attributeString ;
@end


@interface EditPropertyViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* textField;
	id<PropertyEditDelegate> delegate;
	kObjectAttributeType propertyType;
	NSString* propertyName;
	NSString* propertyValue;
	NSString* attributeString;
}
@property (nonatomic, retain) UITextField* textField;
@property (nonatomic, assign) id<PropertyEditDelegate> delegate;
@property (nonatomic) kObjectAttributeType propertyType;
@property (nonatomic, retain) NSString* propertyName;
@property (nonatomic, retain) NSString* propertyValue;
@property (nonatomic, retain) NSString* attributeString;
@end
