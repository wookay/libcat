//
//  UIControlViewController.h
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIControlViewController : UIViewController <UIGestureRecognizerDelegate> {
	IBOutlet UILabel* counterLabel;
	IBOutlet UIButton* upButton;
	IBOutlet UIButton* downButton;
}

-(IBAction) touchedUpButton:(id)sender ;
-(IBAction) touchedDownButton:(id)sender ;
-(void) setCounterLabelTextByInt:(int)intValue ;
-(void) setCounterLabelTextByFloat:(float)floatValue ;
-(void) setCounterLabelTextByString:(NSString*)str ;

@end
