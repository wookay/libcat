//
//  UIViewControllerBlock.h
//  TestApp
//
//  Created by wookyoung noh on 26/11/10.
//  Copyright 2010 factorcat. All rights reserved.
//

typedef void (^TraverseViewControllerBlock)(int depth, UIViewController* viewController) ;

@interface UIViewController (Block)
-(void) traverseParentViewControllers:(TraverseViewControllerBlock)block ;
-(void) traverseParentViewControllers:(TraverseViewControllerBlock)block depth:(int)depth ;
-(void) traverseViewControllers:(TraverseViewControllerBlock)block viewControllers:(NSArray*)viewControllers ;
-(void) traverseViewControllers:(TraverseViewControllerBlock)block depth:(int)depth viewControllers:(NSArray*)viewControllers ;
@end
