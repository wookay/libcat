//
//  NSDataExt.h
//  HangulPlayer
//
//  Created by Woo-Kyoung Noh on 19/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


NSData* unichar_to_data(unichar ch) ;

@interface NSData (Ext)

-(unichar) to_unichar ;
-(NSData*) swap ;
-(NSData*) append:(NSData*)data ;
-(NSString*) ucs2_to_utf8_string ;
-(NSString*) to_utf8_string ;
- (NSString*) to_hex;

@end
