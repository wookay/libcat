//
//  NSObjectValueToString.h
//  TestApp
//
//  Created by wookyoung noh on 08/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

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


@interface NSArray (ValueToString)
-(NSString*) countToString ;
@end


@interface UINavigationItem (Inspect)
-(NSString*) inspect ;
@end

@interface UIBarButtonItem (Inspect)
-(NSString*) inspect ;
@end