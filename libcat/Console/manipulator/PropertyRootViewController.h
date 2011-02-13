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
}
@property (nonatomic, assign) id targetObject;
@end



@interface PropertyCell : UITableViewCell
@end
