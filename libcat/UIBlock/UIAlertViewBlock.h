//
//  UIAlertViewBlock.h
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewBlock.h"

typedef void (^AlertBlock)(NSInteger buttonIndex) ;

enum { kAlertCancelOK_CANCEL, kAlertCancelOK_OK };

@interface UIAlertView (Block)

+(void) alert:(NSString*)message_ OK:(AlertBlock)block ;
+(void) alert:(NSString*)message_ OK:(AlertBlock)block pass:(PassBlock)passBlock ;
+(void) alert:(NSString*)message_ Cancel_OK:(AlertBlock)block ;
+(void) alert:(NSString*)message_ Cancel_OK:(AlertBlock)block pass:(PassBlock)passBlock ;

@end



@interface ProcForAlertView : NSObject <UIAlertViewDelegate> {
	AlertBlock callBlock;
}
@property (nonatomic, retain)	AlertBlock callBlock;
+(ProcForAlertView*) procWithBlock:(AlertBlock)block ;
@end
