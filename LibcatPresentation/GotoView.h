//
//  GotoView.h
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 15/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GotoDelegate
-(void) changedSlidePage:(int)page ;
@end


@interface GotoView : UIAlertView <UIAlertViewDelegate> {
	id<GotoDelegate> gotoDelegate;
}
@property (nonatomic, assign) id<GotoDelegate> gotoDelegate; 

+(void) showGotoAlertView:(NSString*)title_ currentPage:(int)currentPage numberOfPages:(int)numberOfPages delegate:(id)delegate_ ;
-(void)	addSlider:(int)currentPage numberOfPages:(int)numberOfPages ;

@end
