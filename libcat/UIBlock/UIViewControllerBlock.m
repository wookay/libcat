//
//  UIViewControllerBlock.m
//  TestApp
//
//  Created by wookyoung noh on 26/11/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIViewControllerBlock.h"

@implementation UIViewController (Block)

-(void) traverseParentViewControllers:(TraverseViewControllerBlock)block {
	int depth = 0;
	UIViewController* viewController = self;
	while ((viewController = viewController.parentViewController)) {
		depth += 1;
	}
	[self traverseParentViewControllers:block depth:depth];
}

-(void) traverseParentViewControllers:(TraverseViewControllerBlock)block depth:(int)depth {
	UIViewController* parentViewController_ = self.parentViewController;
	if (nil != parentViewController_) {
		[parentViewController_ traverseParentViewControllers:block depth:depth-1];
	}
	block(depth, self);	
}

-(void) traverseViewControllers:(TraverseViewControllerBlock)block viewControllers:(NSArray*)viewControllers {
	[self traverseViewControllers:block depth:0 viewControllers:viewControllers];
}

-(void) traverseViewControllers:(TraverseViewControllerBlock)block depth:(int)depth viewControllers:(NSArray*)viewControllers {
	for (UIViewController* vc in viewControllers) {
		if (vc == self) {
		} else {
			block(depth, vc);
			depth += 1;
		}
	}
	block(depth, self);
}

@end