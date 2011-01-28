//
//  UIEventExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 02/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIEvent (Ext)

-(id) initWithTouches:(NSSet*)touches ;
-(NSDictionary*) to_dict ;

@end
