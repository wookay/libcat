//
//  UIViewFlick.h
//  TestApp
//
//  Created by WooKyoung Noh on 17/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UINavigationItem (ObjectInspect)
-(NSString*) inspect ;
@end

@interface UIBarButtonItem (ObjectInspect)
-(NSString*) inspect ;
@end



@interface UIView (Flick)
-(void) flick ;
@end

@interface CALayer (Flick)
-(void) flick ;
@end	


@interface NSValue (CGExt)
-(NSValue*) origin ;
-(NSValue*) size ;
-(CGFloat) x ;
-(CGFloat) y ;
-(CGFloat) width ;
-(CGFloat) height ;
@end



@interface NSArray (Description)
-(NSString*) arrayDescription ;
@end