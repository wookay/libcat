//
//  Inspect.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 09/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Inspect)
-(id) inspect ;
-(id) inspect_objc ;
@end


@interface NSFormatterToInspect : NSFormatter
@end

@interface NSFormatterToInspectObjC : NSFormatter
@end



NSString* NSStringFromCGColor(CGColorRef colorRef) ;


NSString* objectInspect(id obj) ;