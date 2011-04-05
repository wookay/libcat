//
//  NSDataExt.h
//  HangulPlayer
//
//  Created by Woo-Kyoung Noh on 19/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSData (Ext)
-(char) onebyte_to_char ;
- (int) onebyte_to_int ;
- (NSData*) append:(NSData*)data ;
- (NSString*) to_hex;
- (NSData*) slice:(int)loc :(int)length_ ;
-(NSData*) slice:(int)loc backward:(int)backward ;
@end



NSData* unichar_to_data(unichar ch) ;
@interface NSData (UTF8EncodingExt)
- (unichar) to_unichar ;
- (NSData*) swap ;
- (NSString*) to_utf8_string ;
@end
