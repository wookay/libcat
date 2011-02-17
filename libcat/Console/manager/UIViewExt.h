//
//  UIViewExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 17/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UINavigationItem (Inspect)
-(NSString*) inspect ;
@end

@interface UIBarButtonItem (Inspect)
-(NSString*) inspect ;
@end



@interface UIView (Flick)
-(void) flick ;
@end
