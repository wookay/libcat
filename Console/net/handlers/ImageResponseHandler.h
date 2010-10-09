//
//  ImageResponseHandler.h
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResponseHandler.h"

@interface ImageResponseHandler : HTTPResponseHandler {
	
}
-(UIImage*) capture_image ;
-(UIImage*) obj_to_image:(id)obj ;
@end
