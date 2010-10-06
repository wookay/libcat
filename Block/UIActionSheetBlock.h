//
//  UIActionSheetBlock.h
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewBlock.h"
#import "NSNumberExt.h"

typedef enum { kActionSheetCancelButton, kActionSheetDestructiveButton, kActionSheetOtherButton } ActionSheetButtonType;
typedef void (^ActionSheetBlock)() ;

#define sheet_cancel(title, block)		[NSArray arrayWithObjects:Enum(kActionSheetCancelButton), title, Block_copy(block), nil]
#define sheet_destructive(title, block)	[NSArray arrayWithObjects:Enum(kActionSheetDestructiveButton), title, Block_copy(block), nil]
#define sheet_other(title, block)		[NSArray arrayWithObjects:Enum(kActionSheetOtherButton), title, Block_copy(block), nil]

@interface UIActionSheet (Block)
+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons ;
+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons afterDone:(ActionSheetBlock)doneBlock ;
+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons pass:(PassBlock)passBlock ;
+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons afterDone:(ActionSheetBlock)doneBlock pass:(PassBlock)passBlock ;
@end



@interface ProcForActionSheet : NSObject <UIActionSheetDelegate> {
	ActionSheetBlock cancelBlock;
	ActionSheetBlock destructiveBlock;
	NSMutableArray* otherBlocks;
	ActionSheetBlock doneBlock;
}
@property (nonatomic, retain)	ActionSheetBlock cancelBlock;
@property (nonatomic, retain)	ActionSheetBlock destructiveBlock;
@property (nonatomic, retain)	NSMutableArray* otherBlocks;
@property (nonatomic, retain)	ActionSheetBlock doneBlock;
+(ProcForActionSheet*) procWithCancelBlock:(ActionSheetBlock)cancelBlock_ destructiveBlock:(ActionSheetBlock)destructiveBlock_ otherBlocks:(NSArray*)otherBlocks_ doneBlock:(ActionSheetBlock)doneBlock_ ;
@end
