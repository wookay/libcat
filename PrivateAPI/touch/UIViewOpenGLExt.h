//
//  UIViewOpenGLExt.h
//  TestApp
//
//  Created by WooKyoung Noh on 04/12/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#if USE_OPENGL

#import <UIKit/UIKit.h>

@interface UIView (OpenGLExt)
-(BOOL) isOpenGLView ;
@end

@interface UIWindow (OpenGLExt)
-(BOOL) hasOpenGLView ;
@end

@interface UIView (OpenGLToUIImageExt)
-(UIImage *) opengl_to_image ;
@end

#endif