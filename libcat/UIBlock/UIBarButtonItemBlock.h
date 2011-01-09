//
//  UIBarButtonItemBlock.h
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#define FLEXIBLE_SPACE_ITEM		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]

typedef void (^BarButtonItemBlock)() ;

UIBarButtonItem* barbutton_item(NSString* title, BarButtonItemBlock block) ;
UIBarButtonItem* barbutton_item_style(NSString* title, BarButtonItemBlock block, UIBarButtonItemStyle style) ;	
UIBarButtonItem* barbutton_system(int systemItem, BarButtonItemBlock block) ;
UIBarButtonItem* barbutton_system_style(int systemItem, BarButtonItemBlock block, UIBarButtonItemStyle style) ;
UIBarButtonItem* barbutton_fixed_space(CGFloat width) ;
UIBarButtonItem* barbutton_flexible_space(CGFloat width) ;	


@interface ProcForBarButtonItem : NSObject {
	BarButtonItemBlock callBlock;
}
@property (nonatomic, retain) BarButtonItemBlock callBlock;
-(void) call ;
+(ProcForBarButtonItem*) procWithBlock:(BarButtonItemBlock)block ;
@end