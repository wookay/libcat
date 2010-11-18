//
//  UIBarButtonItemBlock.m
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIBarButtonItemBlock.h"


UIBarButtonItem* barbutton_item(NSString* title, BarButtonItemBlock block) {
	return barbutton_item_style(title, block, UIBarButtonItemStyleBordered);
}

UIBarButtonItem* barbutton_item_style(NSString* title, BarButtonItemBlock block, UIBarButtonItemStyle style) {
	id target = [ProcForBarButtonItem procWithBlock:Block_copy(block)];
	UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:@selector(call)] autorelease];
	item.style = style;
	return item;		
}

UIBarButtonItem* barbutton_system(int systemItem, BarButtonItemBlock block) {
	return barbutton_system_style(systemItem, block, UIBarButtonItemStylePlain);
}

UIBarButtonItem* barbutton_system_style(int systemItem, BarButtonItemBlock block, UIBarButtonItemStyle style) {
	UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:[ProcForBarButtonItem procWithBlock:Block_copy(block)] action:@selector(call)] autorelease];
	item.style = style;
	return item;
}

UIBarButtonItem* barbutton_fixed_space(CGFloat width) {
	UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	item.width = width;
	return item;
}

UIBarButtonItem* barbutton_flexible_space(CGFloat width) {
	UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	item.width = width;
	return item;
}

@implementation ProcForBarButtonItem
@synthesize callBlock;

-(void) call {
	callBlock();
}

+(ProcForBarButtonItem*) procWithBlock:(BarButtonItemBlock)block {
	ProcForBarButtonItem* proc = [[ProcForBarButtonItem alloc] init];
	proc.callBlock = Block_copy(block);
	return proc;
}

- (id) init {
	self = [super init];
	if (self) {
		self.callBlock = nil;
	}
	return self;
}

-(void) dealloc {
	if (nil != callBlock) {
		Block_release(callBlock);
	}
    [super dealloc];
}

@end