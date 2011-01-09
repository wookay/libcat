//
//  UIButtonBlock.h
//  BlockTest
//
//  Created by wookyoung noh on 03/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

typedef void (^ButtonBlock)(id sender) ;


@interface UIButton (Block)

-(void) addBlock:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents ;
-(void) removeBlockForControlEvents:(UIControlEvents)controlEvents ;

@end



@interface ProcForButton : NSObject {
	ButtonBlock callBlock;
}
@property (nonatomic, retain)	ButtonBlock callBlock;
-(void) call:(id)sender ;
+(ProcForButton*) procWithBlock:(ButtonBlock)block ;
@end
