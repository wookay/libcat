//
//  UIControlViewController.h
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIControlViewController : UIViewController {
	IBOutlet UILabel* counterLabel;
}

-(IBAction) touchedUpButton:(id)sender ;
-(IBAction) touchedDownButton:(id)sender ;

@end
