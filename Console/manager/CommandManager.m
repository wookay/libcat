//
//  CommandManager.m
//  TestApp
//
//  Created by b b on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "CommandManager.h"
#import "NSMutableDictionaryExt.h"
#import "NSDictionaryExt.h"
#import "NSDictionaryBlock.h"
#import "NSStringExt.h"
#import "NSIndexPathExt.h"
#import "Logger.h"
#import "ConsoleManager.h"
#import "NSArrayExt.h"
#import "NSArrayBlock.h"
#import "Async.h"
#import "NSNumberExt.h"


NSArray* array_prefix_index(NSArray* array) {
	return [array map_with_index:^id(id obj, int idx) { return SWF(@"[%d] %@", idx, obj); }];
}


@implementation CommandManager
@synthesize commandsMap;

-(id) commandNotFound {
	return NSLocalizedString(@"Command Not Found", nil);
}

-(NSDictionary*) load_system_commands {
	return [NSDictionary dictionaryWithKeysAndObjects:
			@"echo", @"command_echo:arg:",
			@"pwd", @"command_pwd:arg:",
			@"cd", @"command_cd:arg:",
			@"ls", @"command_ls:arg:",
			@"t", @"command_touch:arg:",
			@"touch", @"command_touch:arg:",
			@"back", @"command_back:arg:",
			@"b", @"command_back:arg:",
			@"rm", @"command_rm:arg:",
			nil];
}

-(id) command_echo:(id)currentObject arg:(id)arg {
	return arg;
}

-(id) command_pwd:(id)currentObject arg:(id)arg {
	return SWF(@"%@", [currentObject class]);
}

-(NSString*) command_cd:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id response = [pair objectAtFirst];
	id changeObject = [pair objectAtSecond];
	CONSOLEMAN.currentTargetObject = changeObject;
	return response;
}

-(NSString*) command_rm:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id changeObject = [pair objectAtSecond];
	if ([changeObject isKindOfClass:[UIView class]]) {
		UIView* view = (UIView*)changeObject;
		CONSOLEMAN.currentTargetObject = view.superview;
		[view removeFromSuperview];
		return SWF(@"cd %@", [CONSOLEMAN.currentTargetObject class]);
	}
	return NSLocalizedString(@"Not Found", nil);
}

-(NSString*) command_touch:(id)currentObject arg:(id)arg {
	if ([arg isNotEmpty] && [arg isNumberOrSpace]) {
		BOOL found = false;
		int section = 0;
		int row = 0;
		if ([arg hasText:SPACE]) {
			NSArray* pair = [arg split:SPACE];
			section = [[pair objectAtFirst] to_int];
			row = [[pair objectAtSecond] to_int];
		} else {
			row = [arg to_int];
		}
		if ([currentObject isKindOfClass:[UIViewController class]]) {
			UIViewController* controller = currentObject;
			if ([controller.view isKindOfClass:[UITableView class]]) {
				UITableView* tableView = (UITableView*)controller.view;
				if (section < [tableView numberOfSections] && row < [tableView numberOfRowsInSection:section]) {
					NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
					[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
					found = true;
				}				
			}
		}
		if (found) {
			return NSLocalizedString(@"touch didSelectRowAtIndexPath", nil);
		}
	}
	return NSLocalizedString(@"Not Found", nil);
}

-(NSString*) command_back:(id)currentObject arg:(id)arg {
	if ([currentObject isKindOfClass:[UIViewController class]]) {
		UIViewController* controller = currentObject;
		if ([controller.parentViewController isKindOfClass:[UINavigationController class]]) {
			if (controller.navigationController.viewControllers.count > 1) {
				[controller.navigationController popViewControllerAnimated:true];
				return NSLocalizedString(@"back popViewControllerAnimated", nil);
			}
		}
	}
	return NSLocalizedString(@"Not Found", nil);
}



-(NSString*) command_ls:(id)currentObject arg:(id)arg {
	NSMutableArray* ary = [NSMutableArray array];
	NSArray* arrayLS = [self array_ls:currentObject arg:arg];
	for (NSArray* pair in arrayLS) {
		int lsType = [[pair objectAtFirst] intValue];
		id obj = [pair objectAtSecond];
		switch (lsType) {
			case LS_OBJECT: {
					NSString* classNameUpper = [SWF(@"%@", [obj class]) uppercaseString];
					[ary addObject:SWF(@"[%@]: %@", classNameUpper, obj)];
				}
				break;
			case LS_VIEWCONTROLLERS:
				[ary addObject:SWF(@"VIEWCONTROLLERS: %@", array_prefix_index(obj))];
				break;
			case LS_TABLEVIEW:
				[ary addObject:SWF(@"TABLEVIEW: %@", obj)];
				break;
			case LS_SECTIONS: {
					NSArray* sections = [(NSArray*)obj map:^id(id sectionAry) { return array_prefix_index(sectionAry); }];
					[ary addObject:SWF(@"SECTIONS: %@", sections)];
				}
				break;
			case LS_VIEW:
				[ary addObject:SWF(@"VIEW: %@", obj)];
				break;
			case LS_VIEW_SUBVIEWS:
				[ary addObject:SWF(@"VIEW.SUBVIEWS: %@", array_prefix_index(obj))];
				break;
			default:
				break;
		}
	}
	return [ary join:LF];
}

-(NSArray*) array_ls:(id)currentObject arg:(id)arg {
	if ([currentObject isKindOfClass:[UINavigationController class]]) {
		UINavigationController* navigationController = currentObject;
		return [NSArray arrayWithObjects:
				PAIR(Enum(LS_OBJECT), currentObject),
				PAIR(Enum(LS_VIEWCONTROLLERS), navigationController.viewControllers),
				nil];
	} else if ([currentObject isKindOfClass:[UIViewController class]]) {
		UIViewController* controller = currentObject;
		if ([controller.view isKindOfClass:[UITableView class]]) {
			UITableView* tableView = (UITableView*)controller.view;
			NSMutableArray* sections = [NSMutableArray array];
			for (int section = 0; section < [tableView numberOfSections]; section++) {
				NSMutableArray* ary = [NSMutableArray array];
				for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
					NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
					UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
					[ary addObject:cell];
				}
				[sections addObject:ary];
			}
			return [NSArray arrayWithObjects:
					PAIR(Enum(LS_OBJECT), currentObject),
					PAIR(Enum(LS_TABLEVIEW), tableView),
					PAIR(Enum(LS_SECTIONS), sections),
					nil];
		} else {
			return [NSArray arrayWithObjects:
					PAIR(Enum(LS_OBJECT), currentObject),
					PAIR(Enum(LS_VIEW), controller.view),
					PAIR(Enum(LS_VIEW_SUBVIEWS), controller.view.subviews),
					nil];			
		}
	} else if ([currentObject isKindOfClass:[UITableView class]]) {
		UITableView* tableView = currentObject;
		NSMutableArray* sections = [NSMutableArray array];
		for (int section = 0; section < [tableView numberOfSections]; section++) {
			NSMutableArray* ary = [NSMutableArray array];
			for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
				NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
				UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
				[ary addObject:cell];
			}
			[sections addObject:ary];
		}
		return [NSArray arrayWithObjects:
				PAIR(Enum(LS_OBJECT), currentObject),
				PAIR(Enum(LS_SECTIONS), sections),
				nil];	
	} else if ([currentObject isKindOfClass:[UIView class]]) {
		UIView* view = currentObject;
		return [NSArray arrayWithObjects:
				PAIR(Enum(LS_OBJECT), currentObject),
				PAIR(Enum(LS_VIEW_SUBVIEWS), view.subviews),
				nil];
	} else {
		return [NSArray arrayWithObjects:
				PAIR(Enum(LS_OBJECT), currentObject),
				nil];		
	}
}

-(NSArray*) findTargetObject:(id)currentObject arg:(id)arg {
	id changeObject = nil;
	if ([SLASH isEqualToString:arg]) {
		changeObject = [[CONSOLEMAN navigationController].viewControllers objectAtFirst];
	} else if ([DOT isEqualToString:arg]) {
		changeObject = currentObject;
	} else if ([DOT_DOT isEqualToString:arg]) {
		if (nil == currentObject) {
			return PAIR(EMPTY_STRING, nil);
		} else {
			if ([currentObject isKindOfClass:[UIViewController class]]) {
				UIViewController* controller = currentObject;
				changeObject = controller.parentViewController;
			} else if ([currentObject isKindOfClass:[UIView class]]) {
				UIView* view = currentObject;
				Class klass_UIViewControllerWrapperView = NSClassFromString(@"UIViewControllerWrapperView");
				if ([view.superview isKindOfClass:klass_UIViewControllerWrapperView]) {
					BOOL found = false;
					for (UIViewController* controller in [CONSOLEMAN navigationController].viewControllers) {
						if (controller.view == view) {
							found = true;
							changeObject = controller;
							break;
						}
					}
					if (found) {
					} else {
						changeObject = view.superview;							
					}
				} else {
					changeObject = view.superview;
				}
			}
		}
	} else if ([arg hasPrefix:@"0x"]) {
		size_t address = [arg to_size_t];
		id obj = (id)address;
		changeObject = obj;
	} else if ([arg isNotEmpty] && [arg isNumberOrSpace]) {
		BOOL found = false;
		int section = 0;
		int row = 0;
		if ([arg hasText:SPACE]) {
			NSArray* pair = [arg split:SPACE];
			section = [[pair objectAtFirst] to_int];
			row = [[pair objectAtSecond] to_int];
		} else {
			row = [arg to_int];
		}
		
		if ([currentObject isKindOfClass:[UINavigationController class]]) {
			UINavigationController* navigationController = currentObject;
			if (row < navigationController.viewControllers.count) {
				UIViewController* controller = [navigationController.viewControllers objectAtIndex:row];
				changeObject = controller;
				found = true;
			}
		} else if ([currentObject isKindOfClass:[UIViewController class]]) {
			UIViewController* controller = currentObject;
			if ([controller.view isKindOfClass:[UITableView class]]) {
				UITableView* tableView = (UITableView*)controller.view;
				if (section < [tableView numberOfSections] && row < [tableView numberOfRowsInSection:section]) {
					NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
					UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
					changeObject = cell;
					found = true;
				}				
			} else {
				if (row < controller.view.subviews.count) {
					UIView* subview = [controller.view.subviews objectAtIndex:row];
					changeObject = subview;
					found = true;
				}
			}
		} else if ([currentObject isKindOfClass:[UITableView class]]) {
			UITableView* tableView = currentObject;
			if (section < [tableView numberOfSections] && row < [tableView numberOfRowsInSection:section]) {
				NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
				UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
				changeObject = cell;
				found = true;
			}
		} else if ([currentObject isKindOfClass:[UIView class]]) {
			UIView* view = currentObject;
			if (row < view.subviews.count) {
				UIView* subview = [view.subviews objectAtIndex:row];
				changeObject = subview;
				found = true;
			}
		}
		if (! found) {
			return PAIR(NSLocalizedString(@"Not Found", nil), nil); 
		}
	} else if ([arg isNotEmpty]) {
		SEL selector = NSSelectorFromString(arg);
		if ([currentObject respondsToSelector:selector]) {
			id obj = [currentObject performSelector:selector];
			if (nil != obj) {
				changeObject = obj;
			}
		}
	} else {
		changeObject = [CONSOLEMAN navigationController].topViewController;
	}
	if (nil == changeObject) {
		return PAIR(NSLocalizedString(@"OK", nil), nil); 
	} else {
		return PAIR(SWF(@"cd %@", [changeObject class]), changeObject);
	}	
}



//-(NSString*) command_touch:(id)currentObject arg:(id)arg {
//	id changeObject = nil;
//	if ([arg isEmpty]) {
//		changeObject = currentObject;
//	} else {
//		NSArray* pair = [self changeCurrentObject:currentObject arg:arg];
//		changeObject = [pair objectAtSecond];
//	}	
//	
//	if ((nil != changeObject) && [changeObject respondsToSelector:@selector(touchUpInside)]) {
//		CONSOLEMAN.currentObject = changeObject;
//		[CONSOLEMAN.currentObject performSelectorOnMainThread:@selector(touchUpInside) withObject:nil waitUntilDone:NO];
//		CONSOLEMAN.currentObject = nil;
//		return NSLocalizedString(@"touchUpInside", nil);
//	} else {
//		return NSLocalizedString(@"Not Found", nil);
//	}
//}

+ (CommandManager*) sharedManager {
	static CommandManager*	manager = nil;
	if (!manager) {
		manager = [CommandManager new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
		self.commandsMap = [NSMutableDictionary dictionaryWithDictionary:[self load_system_commands]];
	}
	return self;
}

- (void)dealloc {
	[commandsMap release];
	[super dealloc];
}

@end
