//
//  NSObjectSetValueFromString.h
//  TestApp
//
//  Created by wookyoung noh on 08/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (ColorFromString)
+(UIColor*) colorFromString:(NSString*)str ;
@end 

@interface UIView (SetValueFromString)
-(void) setFrameFromString:(NSString*)str ;
-(void) setAlphaFromString:(NSString*)str ;	
-(void) setTextFromString:(NSString*)str ;
-(void) setBackgroundColorFromString:(NSString*)str ;
@end

@interface UILabel (SetValueFromString)
-(void) setTextColorFromString:(NSString*)str ;
-(void) setShadowColorFromString:(NSString*)str ;
@end


@interface UITableView (SetValueFromString)
-(void) setContentOffsetFromString:(NSString*)str ;
@end	


@interface UIViewController (SetValueFromString)
-(void) setTitleFromString:(NSString*)str ;
@end

@interface UINavigationItem (SetValueFromString)
-(void) setTitleFromString:(NSString*)str ;
@end