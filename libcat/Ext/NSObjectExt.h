//
//  NSObjectExt.h
//  Concats
//
//  Created by Woo-Kyoung Noh on 19/09/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Ext)

-(void) performSelector:(SEL)selector afterDelay:(NSTimeInterval)ti ;
-(BOOL) isNull ;
-(BOOL) isNotNull ;
-(NSArray*) methods ;
-(NSArray*) class_methods ;
-(NSString*) downcasedClassName ;

@end
