//
//  NSObjectValueToString.h
//  TestApp
//
//  Created by wookyoung noh on 08/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (ValueToString)
-(NSString*) clearsContextBeforeDrawingToString ;
-(NSString*) hiddenToString ;
-(NSString*) clipsToBoundsToString ;
-(NSString*) opaqueToString ;
-(NSString*) alphaToString ;
-(NSString*) frameToString ;
-(NSString*) contentStretchToString ;
@end


@interface UITableView (ValueToString)
-(NSString*) contentOffsetToString ;
@end
