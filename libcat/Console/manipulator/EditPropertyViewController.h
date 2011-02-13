//
//  EditPropertyViewController.h
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PropertyEditDelegate
-(void) updateProperty:(NSString*)propertyName value:(NSString*)value ;
@end


@interface EditPropertyViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* textField;
	id<PropertyEditDelegate> delegate;
	NSString* propertyName;
	NSString* propertyValue;
}
@property (nonatomic, retain) UITextField* textField;
@property (nonatomic, assign) id<PropertyEditDelegate> delegate;
@property (nonatomic, retain) NSString* propertyName;
@property (nonatomic, retain) NSString* propertyValue;
@end
