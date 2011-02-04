//
//  ScrollViewController.h
//  TestApp
//
//  Created by WooKyoung Noh on 31/01/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView* scrollView;
	IBOutlet UILabel* label;
}
@property (nonatomic, retain) 	IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain)	IBOutlet UILabel* label;
@end
