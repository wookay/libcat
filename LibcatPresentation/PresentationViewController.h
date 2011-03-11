//
//  PresentationViewController.h
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 09/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentationViewController : UIViewController <UITableViewDelegate> {
	IBOutlet UITableView* tableView;
	IBOutlet UIPageControl* pageControl;
}
@property(nonatomic,retain) UITableView* tableView;
@property(nonatomic,retain) UIPageControl* pageControl;


-(IBAction) touchedPageControl:(id)sender ;
@end
