//
//  PresentationViewController.h
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 09/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GotoView.h"

@interface PresentationViewController : UIViewController <GotoDelegate, UITableViewDelegate> {
	IBOutlet UITableView* tableView;
	IBOutlet UIPageControl* pageControl;
    IBOutlet UIButton* goButton;
}
@property(nonatomic,retain) UITableView* tableView;
@property(nonatomic,retain) UIPageControl* pageControl;
@property(nonatomic,retain) UIButton* goButton;

-(IBAction) touchedGotoButton:(id)sender ;
-(IBAction) touchedPageControl:(id)sender ;
-(void) changeSlidePage:(int)page ;

@end
