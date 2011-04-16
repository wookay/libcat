//
//  UIActionSheetBlock.m
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIActionSheetBlock.h"
#import "NSArrayExt.h"
#import "Logger.h"
#import "Async.h"
#import "iPadExt.h"

@implementation UIActionSheet (Block)

+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons {
	[self show:view title:title_ buttons:buttons afterDone:nil pass:nil];
}

+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons afterDone:(ActionSheetBlock)doneBlock {
	[self show:view title:title_ buttons:buttons afterDone:doneBlock pass:nil];
}

+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons pass:(PassBlock)passBlock {
	[self show:view title:title_ buttons:buttons afterDone:nil pass:passBlock];
}

+(void) show:(id)view title:(NSString*)title_ buttons:(NSArray*)buttons afterDone:(ActionSheetBlock)doneBlock pass:(PassBlock)passBlock {
	
	NSString* cancelButtonTitle = nil;
	NSString* destructiveButtonTitle = nil;
	NSMutableArray* otherButtonTitles = [NSMutableArray array];
	ActionSheetBlock cancelBlock = nil;
	ActionSheetBlock destructiveBlock = nil;
	NSMutableArray* otherBlocks = [NSMutableArray array];
	
	for (NSArray* trio in buttons) {
		ActionSheetButtonType buttonType = [[trio objectAtFirst] intValue];
		NSString* buttonTitle = [trio objectAtSecond];
		ActionSheetBlock block = [trio objectAtThird];
		switch (buttonType) {
			case kActionSheetCancelButton:
				cancelButtonTitle = buttonTitle;
				cancelBlock = block;
				break;
			case kActionSheetDestructiveButton:
				destructiveButtonTitle = buttonTitle;
				destructiveBlock = block;
				break;
			case kActionSheetOtherButton:
			default:
				[otherButtonTitles addObject:buttonTitle];
				[otherBlocks addObject:block];
				break;
		}
	}
	
	UIActionSheet* sheet = [[self alloc] initWithTitle:title_
											  delegate:[ProcForActionSheet procWithCancelBlock:cancelBlock destructiveBlock:destructiveBlock otherBlocks:otherBlocks doneBlock:doneBlock]
									 cancelButtonTitle:cancelButtonTitle
								destructiveButtonTitle:destructiveButtonTitle
									 otherButtonTitles:nil];
	for (NSString* otherButtonTitle in otherButtonTitles) {
		[sheet addButtonWithTitle:otherButtonTitle];
	}
	[sheet autorelease]; 
	
	SEL showTarget;
	if ([view isKindOfClass:[UIToolbar class]]) {		
		showTarget = @selector(showFromToolbar:);
	} else if ([view isKindOfClass:[UITabBar class]]) {
		showTarget = @selector(showFromTabBar:);
	} else {
		showTarget = @selector(showInView:);
	}
	if ([sheet respondsToSelector:showTarget]) {
		if (IS_IPAD) {
			if ([view isKindOfClass:[UIWindow class]]) {
				view = [((UIWindow*)view).subviews objectAtFirst];
			}
		}
		if (nil != view) {
			[sheet performSelector:showTarget withObject:view];
		}
	}
	
	if (nil != passBlock) {
		[sheet dismissWithClickedButtonIndex:passBlock() animated:FALSE];
	}
}

@end




@implementation ProcForActionSheet
@synthesize cancelBlock;
@synthesize destructiveBlock;
@synthesize otherBlocks;
@synthesize doneBlock;

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (nil != cancelBlock && actionSheet.cancelButtonIndex == buttonIndex) {
		cancelBlock();
	} else if (nil != destructiveBlock && actionSheet.destructiveButtonIndex == buttonIndex) {
		destructiveBlock();
	} else {
		int idx = 0;
		if (nil != cancelBlock && nil != destructiveBlock) {
			idx -= 1;
		}
		if (nil != cancelBlock) {
			idx -= 1;
		} else if (nil != destructiveBlock) {
			idx -= 1;
		}
		idx += buttonIndex;
		if (idx >= 0 && self.otherBlocks.count > idx) {
			ActionSheetBlock block = [otherBlocks objectAtIndex:idx];
			block();
		}
	}
	if (nil != doneBlock) {
		doneBlock();
	}
	[actionSheet.delegate release];
}

+(ProcForActionSheet*) procWithCancelBlock:(ActionSheetBlock)cancelBlock_ destructiveBlock:(ActionSheetBlock)destructiveBlock_ otherBlocks:(NSArray*)otherBlocks_ doneBlock:(ActionSheetBlock)doneBlock_ {
	ProcForActionSheet* proc = [[ProcForActionSheet alloc] init];
	proc.cancelBlock = Block_copy(cancelBlock_);
	proc.destructiveBlock = Block_copy(destructiveBlock_);
	proc.otherBlocks = [NSMutableArray arrayWithArray:otherBlocks_];
	proc.doneBlock = Block_copy(doneBlock_);
	return proc;
}

- (id) init {
	self = [super init];
	if (self) {
		self.cancelBlock = nil;
		self.destructiveBlock = nil;
		self.otherBlocks = [NSMutableArray array];
		self.doneBlock = nil;
	}
	return self;
}

- (void)dealloc {
	if (nil != cancelBlock) {
		Block_release(cancelBlock);
	}
	if (nil != destructiveBlock) {
		Block_release(destructiveBlock);
	}	
	for (ActionSheetBlock block in otherBlocks) {
		Block_release(block);
	}
	[otherBlocks release];
	if (nil != doneBlock) {
		Block_release(doneBlock);
	}
	[super dealloc];
}

@end