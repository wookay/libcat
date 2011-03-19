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
#import "UIViewFlick.h"
#import "NSIndexPathExt.h"
#import "Logger.h"
#import "ConsoleManager.h"
#import "NSArrayExt.h"
#import "NSArrayBlock.h"
#import "NSObjectExt.h"
#import "Async.h"
#import "NSNumberExt.h"
#import "NSObjectExt.h"
#import "Inspect.h"
#import "UnitTest.h"
#import "NewObjectManager.h"
#import "objc/runtime.h"
#import "NSTimerExt.h"
#import "HitTestWindow.h"
#import "GeometryExt.h"
#import "UIViewControllerBlock.h"
#import "UIViewBlock.h"
#import "PropertyManipulator.h"
#import <QuartzCore/QuartzCore.h>

#if USE_COCOA
	#import "NSWindowExtMac.h"
	#import "NSViewExtMac.h"
#endif

#define TOOLBAR_ITEMS_SECTION_INDEX -1




NSArray* array_prefix_index(NSArray* array) {
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 0; idx < array.count; idx++) {
		id obj = [array objectAtIndex:idx];
		[ary addObject:SWF(@"  [%d] %@", idx, [obj inspect])];
	}
	return ary;
}

NSString* surrounded_array_prefix_index(NSArray* array) {
	NSArray* ary = array_prefix_index(array);
	if (ary.count > 0) {
		return SWF(@"\n%@", [ary join:LF]);
	} else {
		return @"[]";
	}
}

@implementation CommandManager
@synthesize commandsMap;

#pragma mark HitTestDelegate

-(void) touchedHitTestView:(UIView*)view {
	log_info(@"hitTest %@", view);
}

-(id) commandNotFound {
	return NSLocalizedString(@"Command Not Found", nil);
}

-(NSDictionary*) load_system_commands {
	return [NSDictionary dictionaryWithKeysAndObjects:
			@"pwd", @"command_pwd:arg:",
			@"hit", @"command_hit:arg:",
			@"events", @"command_events:arg:",
			@"cd", @"command_cd:arg:",
			@"ls", @"command_ls:arg:",
			@"touch", @"command_touch:arg:",
			@"flick", @"command_flick:arg:",
			@"back", @"command_back:arg:",
			@"manipulate", @"command_manipulate:arg:",
			@"png", @"command_png:arg:",
			@"hide_console", @"command_hide_console:arg:",
			@"show_console", @"command_show_console:arg:",
			@"rm", @"command_rm:arg:",
			@"properties", @"command_properties:arg:",
			@"commands", @"command_commands:arg:",
			@"enum", @"command_enum:arg:",
			@"fill_rect", @"command_fill_rect:arg:",
			@"add_ui", @"command_add_ui:arg:",
			@"new_objects", @"command_new_objects:arg:",
			@"completion", @"command_completion:arg:",
			@"prompt", @"command_prompt:arg:",
			@"openURL", @"command_openURL:arg:",
			@"log", @"command_log:arg:",
			@"map", @"command_map:arg:",
			@"echo", @"command_echo:arg:",
			nil];
}

#define kTagFillRect 51
-(NSString*) command_add_ui:(id)currentObject arg:(id)arg {
	Class klass = NSClassFromString(arg);
	
	if (nil == klass) {
		return NSLocalizedString(@"Not Found", nil);
	}
		
	CGRect rect = CGRectZero;
	for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews) {
		if (kTagFillRect == view.tag) {
			rect = view.frame;
			[view removeFromSuperview];
			break;
		}
	}
	if (CGRectIsEmpty(rect)) {
		rect = CGRectMake(60,190,200,50);
	}
	
	UIView* ui = nil;
	if (klass == [UIButton class]) {
		ui = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[(UIButton*)ui setTitle:NSLocalizedString(@"Title", nil) forState:UIControlStateNormal];
	} else if (klass == [UIProgressView class]) {
		ui = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	} else if (klass == [UISegmentedControl class]) {
		NSArray* items = [NSArray arrayWithObjects:@"item 0", @"item 1", nil];
		ui = [[UISegmentedControl alloc] initWithItems:items];
	} else {
		ui = [[klass alloc] initWithFrame:CGRectZero];
		if ([ui isKindOfClass:[UILabel class]]) {
			((UILabel*)ui).text = NSLocalizedString(@"Text", nil);
		} else if ([ui isKindOfClass:[UITextField class]]) {
			ui.backgroundColor = [UIColor lightGrayColor];
		}
	}
	ui.frame = rect;
	[[UIApplication sharedApplication].keyWindow addSubview:ui];
	CONSOLEMAN.currentTargetObject = ui;
	[ui flick];
	[ui release];
	return SWF(@"%@ %@", NSLocalizedString(@"add_ui", nil), ui);
}

#define STR_CLEAR @"clear"
-(NSString*) command_fill_rect:(id)currentObject arg:(id)arg {
	if ([STR_CLEAR isEqualToString:arg]) {
		for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews) {
			if (kTagFillRect == view.tag) {
				[view removeFromSuperview];
			}
		}
		return SWF(@"%@ %@", NSLocalizedString(@"fill_rect", nil), NSLocalizedString(@"clear", nil));
	} else {
		CGRect rect = CGRectForString(arg);
		UIView* view = [[UIView alloc] initWithFrame:rect];
		view.tag = kTagFillRect;
		view.backgroundColor = [UIColor blueColor];
		[[UIApplication sharedApplication].keyWindow addSubview:view];
		[view release];
		[view flick];
		return SWF(@"%@ %@", NSLocalizedString(@"fill_rect", nil), SFRect(rect));
	}
}

-(NSString*) command_openURL:(id)currentObject arg:(id)arg {
#define STR_COLON @":"
	NSString* urlScheme;
	if ([arg hasText:STR_COLON]) {
		urlScheme = arg;
	} else if ([arg hasText:SPACE]) {
		urlScheme = [[arg split:SPACE] join:STR_COLON];
	} else {
		urlScheme = SWF(@"%@%@", arg, STR_COLON);
	}
	NSURL* appURL = [NSURL URLWithString:urlScheme];
	[[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:appURL afterDelay:0.3];	
	return SWF(@"openURL %@", urlScheme);
}

-(NSString*) command_show_console:(id)currentObject arg:(id)arg {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	for (UIView* view in window.subviews) {
		if ([view isKindOfClass:[ConsoleButton class]]) {
			view.hidden = false;
		}
	}	
	return NSLocalizedString(@"show", nil);
}

-(NSString*) command_hide_console:(id)currentObject arg:(id)arg {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	for (UIView* view in window.subviews) {
		if ([view isKindOfClass:[ConsoleButton class]]) {
			view.hidden = true;
		}
	}
	return NSLocalizedString(@"hide", nil);
}

-(NSString*) command_commands:(id)currentObject arg:(id)arg {
	NSMutableArray* ary = [NSMutableArray array];
	for (NSString* command in [commandsMap allKeys]) {
		[ary addObject:SWF(@"%@", command)];
	}
	return [[ary sort] join:LF];
}

-(NSString*) command_enum:(id)currentObject arg:(id)arg {
	NSString* definition = [PROPERTYMAN.typeInfoTable findEnumDefinitionByEnumString:arg];
	if (nil == definition) {
		return NSLocalizedString(@"Not Found", nil);
	} else {
		return definition;
	}
}

-(NSString*) command_hit:(id)currentObject arg:(id)arg {
	HitTestWindow* hitTestWindow = [HitTestWindow sharedWindow];
	return [hitTestWindow hitTestView];
}

-(id) command_png:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id targetObject = [pair objectAtSecond];	
	if ([targetObject isNil]) {
		targetObject = currentObject;
	}
	
	UIImage* image = nil;
	if ([targetObject isKindOfClass:[UIImage class]]) {
		image = (UIImage*)targetObject;
	} else if ([targetObject isKindOfClass:[UIView class]]) {
		UIView* view = (UIView*)targetObject;
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
		[view.layer renderInContext:UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	NSString* ret;
	if (nil == image) {
		ret = NSLocalizedString(@"Not UIView Class", nil);
	} else {
		NSArray* searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* fileName = SWF(@"%p.png", targetObject);
		NSString* path = [[searchPath objectAtFirst] stringByAppendingPathComponent:fileName];
		NSData* imageData = UIImagePNGRepresentation(image);
		[imageData writeToFile:path atomically:true];
		ret = SWF(@"%@ %@", NSLocalizedString(@"Saved to", nil), path);
	}
	return ret;
}

-(id) command_log:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id targetObject = [pair objectAtSecond];	
	if ([targetObject isNil]) {
		targetObject = currentObject;
	}
	log_info(@"%@", targetObject);
	return SWF(@"%@ %@", NSLocalizedString(@"log", nil), targetObject);
}

-(id) command_echo:(id)currentObject arg:(id)arg {
	return arg;
}

-(id) command_map:(id)currentObject arg:(id)arg {
	return SWF(@"[%@]: %@", [currentObject class], [[CONSOLEMAN mapTargetObject:currentObject arg:arg] arrayDescription]);
}

-(id) command_prompt:(id)currentObject arg:(id)arg {
	if (nil == CONSOLEMAN.currentTargetObject) {
		CONSOLEMAN.currentTargetObject = [CONSOLEMAN get_topViewController];
	}
	return SWF(@"%@", [CONSOLEMAN.currentTargetObject class]);
}

-(NSString*) command_new_objects:(id)currentObject arg:(id)arg {
	NSMutableArray* ary = [NSMutableArray array];
	[ary addObject:SWF(@"NEW_OBJECTS: %@", NEWOBJECTMAN.newObjects)];
	[ary addObject:SWF(@"%@: %@", NEW_ONE_NAME, NEWOBJECTMAN.newOne)];
	return [ary join:LF];
}

-(NSString*) command_cd:(id)currentObject arg:(id)arg {
	id changeObject = nil;
	if (nil == arg) {
		CONSOLEMAN.currentTargetObject = [CONSOLEMAN get_topViewController];
		changeObject = CONSOLEMAN.currentTargetObject;
	} else {
		NSArray* pair = [self findTargetObject:currentObject arg:arg];
		changeObject = [pair objectAtSecond];
		if ([changeObject isNil]) {
			id response = [pair objectAtFirst];
			return response;
		} else {
			if (changeObject == [changeObject class] && nil != CONSOLEMAN.currentTargetObject) {
				NSString* ret = SWF(@"%@ = %@", NEW_ONE_NAME, CONSOLEMAN.currentTargetObject);
				[NEWOBJECTMAN updateNewOne:CONSOLEMAN.currentTargetObject];
				CONSOLEMAN.currentTargetObject = changeObject;
				return ret;
			} else {
				NEWOBJECTMAN.oldOne = CONSOLEMAN.currentTargetObject;
				CONSOLEMAN.currentTargetObject = changeObject;
			}
		}
	}
	return EMPTY_STRING;
}

-(NSString*) command_touch:(id)currentObject arg:(id)arg {
	NSArray* trio = [self findTargetObject:currentObject arg:arg];
	id actionBlockObj = [trio objectAtThird];
	if (nil != actionBlockObj && [actionBlockObj isNotNil]) {
		if ([actionBlockObj isKindOfClass:NSClassFromString(@"__NSMallocBlock__")]) {
			ActionBlock actionBlock = (ActionBlock)actionBlockObj;
			NSString* methodStr = actionBlock();
			CONSOLEMAN.currentTargetObject = nil;
			return methodStr;
		}
	}
	return NSLocalizedString(@"Not Found", nil);
}

-(NSString*) command_flick:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id changeObject = [pair objectAtSecond];
	if ([changeObject isNil]) {
		changeObject = CONSOLEMAN.currentTargetObject;
	}
	if ([changeObject isKindOfClass:[UIView class]]) {
		UIView* view = changeObject;
		[view flick];
	} else if ([changeObject isKindOfClass:[CALayer class]]) {
		CALayer* layer = changeObject;
		[layer flick];			
	} else if ([changeObject isKindOfClass:[UIBarButtonItem	class]]) {
		UIBarButtonItem* barButtonItem = (UIBarButtonItem*)changeObject;
		UIBarButtonItemStyle style = barButtonItem.style;		
		[UIView animate:^ {
			barButtonItem.style = enum_rshift(UIBarButtonItemStyleDone, style);
		} afterDone:^ {
			barButtonItem.style = style;
		}];
#if USE_COCOA
	} else if ([changeObject isKindOfClass:[NSView class]]) {
		[changeObject flick];
#endif
	}
	return EMPTY_STRING;
}

-(NSString*) command_rm:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id changeObject = [pair objectAtSecond];
	if ([changeObject isKindOfClass:[UIView class]]) {
		UIView* view = (UIView*)changeObject;
		UIView* superview = view.superview;
		if (nil == superview) {
			return NSLocalizedString(@"Not Found Superview", nil);
		}  else {
			CONSOLEMAN.currentTargetObject = superview;
			[view removeFromSuperview];
			return SWF(@"cd %@", [CONSOLEMAN.currentTargetObject class]);
		}
	} else if ([changeObject isKindOfClass:[CALayer class]]) {
		CALayer* layer = (CALayer*)changeObject;
		CALayer* superlayer = layer.superlayer;
		if (nil == superlayer) {
			return NSLocalizedString(@"Not Found Superlayer", nil);
		} else {
			if (1 == superlayer.sublayers.count) {
				if ([layer.delegate isKindOfClass:[UIView class]]) {
					[layer.delegate removeFromSuperview];
					CONSOLEMAN.currentTargetObject = superlayer.delegate;
				}
			} else {
				[layer removeFromSuperlayer];
				CONSOLEMAN.currentTargetObject = superlayer;
			}
			return SWF(@"cd %@", [CONSOLEMAN.currentTargetObject class]);
		}
	}
	return NSLocalizedString(@"Not Found", nil);
}

-(NSString*) command_back:(id)currentObject arg:(id)arg {
	if ([currentObject isKindOfClass:[UIViewController class]]) {
		UIViewController* controller = currentObject;
		if ([controller.parentViewController isKindOfClass:[UINavigationController class]]) {
			if (controller.navigationController.viewControllers.count > 1) {
				NSString* oldTargetStr = [controller.navigationController className];
				[controller.navigationController popViewControllerAnimated:false];
				CONSOLEMAN.currentTargetObject = nil;
				return SWF(@"[%@ popViewControllerAnimated: %d]", oldTargetStr, false);
			}
		}
	}
	return NSLocalizedString(@"Not Found", nil);
}

-(NSString*) command_properties:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id targetObject = [pair objectAtSecond];
	if ([targetObject isNil]) {
		targetObject = currentObject;
	}
	return [PROPERTYMAN list_properties:targetObject];
}

-(NSString*) command_manipulate:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id targetObject = [pair objectAtSecond];	
	if (IS_NIL(arg)) {
		if ([PROPERTYMAN isVisible]) {
			[PROPERTYMAN hide];
			return NSLocalizedString(@"off", nil);
		}
	}
	if ([targetObject isNil]) {
		targetObject = currentObject;
	}
	return [PROPERTYMAN manipulate:targetObject];
}

-(NSString*) command_completion:(id)currentObject arg:(id)arg {
	NSArray* pair = [self get_targetStringAndBlocks:currentObject];
	NSDictionary* targetStrings = [pair objectAtFirst];
	NSMutableArray* ary = [NSMutableArray arrayWithArray:[currentObject methods]];
	[ary addObjectsFromArray:[targetStrings allKeys]];
	if (currentObject == [currentObject class]) {
		[ary addObjectsFromArray:[currentObject class_methods]];
	}
	if ([currentObject isKindOfClass:[UIView class]]) {
		for(NSString* method in [UIColor class_methods]) {
			if ([method hasSuffix:@"Color"]) {
				[ary addObject:method];
			}
		}
	}
	return [ary join:LF];
}

-(NSString*) command_ls:(id)currentObject arg:(id)arg {
	NSArray* pair = [self findTargetObject:currentObject arg:arg];
	id targetObject = [pair objectAtSecond];	
	if ([targetObject isNil]) {
		targetObject = currentObject;
	}
		
	NSMutableArray* ary = [NSMutableArray array];
	NSArray* arrayLS = [self array_ls:targetObject arg:arg];
	for (NSArray* pair in arrayLS) {
		int lsType = [[pair objectAtFirst] intValue];
		id obj = [pair objectAtSecond];
		switch (lsType) {
			case LS_OBJECT: {
					if (nil == obj) {
					} else {
						NSString* classNameUpper = [SWF(@"%@", [obj class]) uppercaseString];
						[ary addObject:SWF(@"[%@]: %@", classNameUpper, [obj inspect])];
					}
				}
				break;
			case LS_VIEWCONTROLLERS:
				[ary addObject:SWF(@"VIEWCONTROLLERS: %@", surrounded_array_prefix_index(obj))];
				break;
			case LS_TABLEVIEW:
				[ary addObject:SWF(@"TABLEVIEW: %@", [obj inspect])];
				break;
			case LS_SECTIONS: {
					NSArray* sectionTitles = [pair objectAtThird];
					[ary addObject:@"SECTIONS:"];
					[(NSArray*)obj each_with_index:^(id sectionAry, int idx) {
						NSString* sectionTitle = [sectionTitles objectAtIndex:idx];
						if (nil == sectionTitle) {
							[ary addObject:SWF(@"== %@ %d ==", NSLocalizedString(@"Section", nil), idx)];
						} else {
							[ary addObject:SWF(@"== %@ %d : %@ ==", NSLocalizedString(@"Section", nil), idx, sectionTitle)];
						}
						[ary addObject:[array_prefix_index(sectionAry) join:LF]];
					}];				
				}
				break;
			case LS_VIEW:
				[ary addObject:SWF(@"VIEW: %@", [obj inspect])];
				break;
			case LS_INDENTED_VIEW:
			case LS_INDENTED_LAYER: {
					int depth = [[pair objectAtThird] intValue];
					[ary addObject:SWF(@"%@%@", [TAB repeat:depth], [obj inspect])];
				}
				break;				
			case LS_VIEW_SUBVIEWS:
				[ary addObject:SWF(@"VIEW.SUBVIEWS: %@", surrounded_array_prefix_index(obj))];
				break;
			case LS_TABBAR:
				[ary addObject:SWF(@"TABBAR: %@", [obj inspect])];				
				break;
			case LS_NAVIGATIONITEM:
				[ary addObject:SWF(@"NAVIGATIONITEM: %@", [obj inspect])];				
				break;				
			case LS_NAVIGATIONCONTROLLER_TOOLBAR:
				[ary addObject:SWF(@"NAVIGATIONCONTROLLER_TOOLBAR: %@", [obj inspect])];				
				break;								
			case LS_NAVIGATIONCONTROLLER_TOOLBAR_ITEMS:
				[ary addObject:SWF(@"NAVIGATIONCONTROLLER_TOOLBAR_ITEMS:\n%d%@", TOOLBAR_ITEMS_SECTION_INDEX, surrounded_array_prefix_index(obj))];				
				break;												
			case LS_TOOLBAR:
				[ary addObject:SWF(@"TOOLBAR: %@", [obj inspect])];				
				break;								
			case LS_TOOLBAR_ITEMS:
				[ary addObject:SWF(@"TOOLBAR_ITEMS: %d %@", TOOLBAR_ITEMS_SECTION_INDEX, surrounded_array_prefix_index(obj))];				
				break;																
			case LS_CLASS_METHODS:
				[ary addObject:SWF(@"CLASS_METHODS: %@", [obj inspect])];				
				break;	
			case LS_LAYER:
				[ary addObject:SWF(@"LAYER: %@", [obj inspect])];
				break;												
			case LS_LAYER_SUBLAYERS:
				[ary addObject:SWF(@"LAYER.SUBLAYERS: %@", surrounded_array_prefix_index(obj))];
				break;		
			default:
				break;
		}
	}
	return [ary join:LF];
}

-(id) command_pwd:(id)currentObject arg:(id)arg {	
	NSMutableArray* ary = [NSMutableArray array];
	
	if ([currentObject isKindOfClass:[UIView class]]) {
		UIView* view = currentObject;
#define JUSTIFY_VIEW 85
		TraverseViewBlock traverseViewBlock = ^(int depth, UIView* superview) {
			[ary addObject:SWF(@"%@%@", [TAB repeat:depth], [[superview inspect] truncate:JUSTIFY_VIEW])];
		};
		[view traverseSuperviews:traverseViewBlock];
	} else if ([currentObject isKindOfClass:[CALayer class]]) {
			CALayer* layer = currentObject;
			TraverseLayerBlock traverseLayerBlock = ^(int depth, CALayer* superlayer) {
				[ary addObject:SWF(@"%@%@", [TAB repeat:depth], [[superlayer inspect] truncate:JUSTIFY_VIEW])];
			};
			[layer traverseSuperlayers:traverseLayerBlock];			
	} else if ([currentObject isKindOfClass:[UIViewController class]]) {
		TraverseViewControllerBlock traverseViewControllerBlock = ^(int depth, UIViewController* parentViewController) {
			[ary addObject:SWF(@"%@%@", [TAB repeat:depth], [parentViewController inspect])];
		};		
		UIViewController* controller = currentObject;
		if ([controller.parentViewController isKindOfClass:[UINavigationController class]]) {
			[controller traverseViewControllers:traverseViewControllerBlock viewControllers:controller.navigationController.viewControllers];
		} else {
			[controller traverseParentViewControllers:traverseViewControllerBlock];
		}
	}
	return [ary join:LF];
}

-(NSArray*) array_ls:(id)currentObject arg:(id)arg {
	NSMutableArray* ret = [NSMutableArray array];
	[ret addObject:PAIR(Enum(LS_OBJECT), currentObject)];

	BOOL recursive = [LS_OPTION_RECURSIVE isEqualToString:arg];
	TraverseViewBlock traverseBlock = ^(int depth, UIView* subview) {
		[ret addObject:TRIO(Enum(LS_INDENTED_VIEW), subview, FIXNUM(depth))];
	};
	
	if ([currentObject isKindOfClass:[UITabBarController class]]) {
		UITabBarController* tabBarController = currentObject;
		[ret addObject:PAIR(Enum(LS_TABBAR), tabBarController.tabBar)];
		[ret addObject:PAIR(Enum(LS_VIEWCONTROLLERS), tabBarController.viewControllers)];
	} else if ([currentObject isKindOfClass:[UINavigationController class]]) {
		UINavigationController* navigationController = currentObject;
		[ret addObject:PAIR(Enum(LS_VIEWCONTROLLERS), navigationController.viewControllers)];
		if (! navigationController.toolbarHidden) {
			[ret addObject:PAIR(Enum(LS_TOOLBAR), navigationController.toolbar)];
			[ret addObject:PAIR(Enum(LS_TOOLBAR_ITEMS), navigationController.toolbar.items)];
		}
	} else if ([currentObject isKindOfClass:[UIViewController class]]) {
		UIViewController* controller = currentObject;
		if (nil != controller.navigationItem) {
			[ret addObject: PAIR(Enum(LS_NAVIGATIONITEM), controller.navigationItem) ];
		}
		if ([controller.view isKindOfClass:[UITableView class]]) {
			UITableView* tableView = (UITableView*)controller.view;
			NSMutableArray* sections = [NSMutableArray array];
			NSMutableArray* sectionTitles = [NSMutableArray array];
			for (int section = 0; section < [tableView numberOfSections]; section++) {
				NSMutableArray* ary = [NSMutableArray array];
				for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
					NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
					UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
					if (nil != cell) {
						[ary addObject:cell];
					}
				}
				[sections addObject:ary];
				[sectionTitles addObject:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
			}
			[ret addObject:PAIR(Enum(LS_TABLEVIEW), tableView)];
			[ret addObject:TRIO(Enum(LS_SECTIONS), sections, sectionTitles)];
		} else {
			if (recursive) {
				[controller.view traverseSubviews:traverseBlock reverse:true];
			} else {
				[ret addObject:PAIR(Enum(LS_VIEW), controller.view)];
				[ret addObject:PAIR(Enum(LS_VIEW_SUBVIEWS), [controller.view.subviews reverse])];
			}
		}
		if (! controller.navigationController.toolbarHidden &&  nil != controller.navigationController.toolbar) {
			[ret addObject: PAIR(Enum(LS_NAVIGATIONCONTROLLER_TOOLBAR), controller.navigationController.toolbar) ];
			[ret addObject: PAIR(Enum(LS_NAVIGATIONCONTROLLER_TOOLBAR_ITEMS), controller.navigationController.toolbar.items) ];
		}
	} else if ([currentObject isKindOfClass:[UITableView class]]) {
		UITableView* tableView = currentObject;
		NSMutableArray* sections = [NSMutableArray array];
		NSMutableArray* sectionTitles = [NSMutableArray array];
		for (int section = 0; section < [tableView numberOfSections]; section++) {
			NSMutableArray* ary = [NSMutableArray array];
			for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
				NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
				UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
				if (nil != cell) {
					[ary addObject:cell];
				}
			}
			[sections addObject:ary];
			[sectionTitles addObject:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
		}
		[ret addObject:TRIO(Enum(LS_SECTIONS), sections, sectionTitles)];
	} else if ([currentObject isKindOfClass:[UIView class]]) {
		UIView* view = currentObject;
		if (recursive) {
			[view traverseSubviews:traverseBlock reverse:true];
		} else {
			[ret addObject:PAIR(Enum(LS_VIEW_SUBVIEWS), [view.subviews reverse])];
		}
	} else if ([currentObject isKindOfClass:[CALayer class]]) {
		TraverseLayerBlock traverseLayerBlock = ^(int depth, CALayer* sublayer) {
			[ret addObject:TRIO(Enum(LS_INDENTED_LAYER), sublayer, FIXNUM(depth))];
		};		
		CALayer* layer = currentObject;
		if (recursive) {
			[layer traverseSublayers:traverseLayerBlock reverse:true];
		} else {
			[ret addObject:PAIR(Enum(LS_LAYER_SUBLAYERS), layer.sublayers == nil ? [NSArray array] : [layer.sublayers reverse])];
		}		
#if USE_COCOA
	} else if ([currentObject isKindOfClass:[NSWindow class]]) {
		NSWindow* window = currentObject;
		[ret addObject:PAIR(Enum(LS_VIEW_SUBVIEWS), [window.contentView subviews])];	
#endif
	} else if (currentObject == [currentObject class]) {
		[ret addObject:PAIR(Enum(LS_CLASS_METHODS), [currentObject class_methods])];
	}
	return ret;
}

-(NSArray*) findTargetObject:(id)currentObject arg:(id)arg {
	id changeObject = nil;
	id actionBlock = nil;
	if ([SLASH isEqualToString:arg]) {
		changeObject = [CONSOLEMAN get_rootViewController];
	} else if ([TILDE isEqualToString:arg]) {
		changeObject = [CONSOLEMAN get_keyWindow];
	} else if ([MINUS isEqualToString:arg]) {
		if (nil == NEWOBJECTMAN.oldOne) {
			changeObject = currentObject;
		} else {
			changeObject = NEWOBJECTMAN.oldOne;
		}
	} else if ([DOT isEqualToString:arg]) {
		changeObject = currentObject;
		actionBlock = [self get_targetObjectActionBlock:currentObject];		
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
					if ([CONSOLEMAN get_topViewController].view == view) {
						changeObject = [CONSOLEMAN get_topViewController];
					} else {
						changeObject = view.superview;							
					}
				} else {
					changeObject = view.superview;
				}
			} else if ([currentObject isKindOfClass:[CALayer class]]) {
				CALayer* layer = currentObject;
				if (nil != layer.delegate && [layer.delegate isKindOfClass:[UIView class]]) {
					changeObject = layer.delegate;
				}
			}
		}		
	} else if ([arg hasPrefix:NEW_OBJECT_PREFIX]) {
		id obj = [CONSOLEMAN get_argObject:arg];
		changeObject = obj;
	} else if ([arg hasPrefix:MEMORY_ADDRESS_PREFIX]) {
		size_t address = [arg to_size_t];
		id obj = (id)address;
		
		changeObject = obj;
		actionBlock = [self get_targetObjectActionBlock:obj];
	} else if ([arg isIntegerNumberWithSpace]) {
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
		if (TOOLBAR_ITEMS_SECTION_INDEX == section) {
			if ([currentObject isKindOfClass:[UIViewController class]]) {
				UIViewController* controller = currentObject;
				if (! controller.navigationController.toolbarHidden &&  nil != controller.navigationController.toolbar) {
					NSArray* items = controller.navigationController.toolbar.items;
					if (items.count > row) {
						UIBarButtonItem* barButtonItem = [items objectAtIndex:row];
						changeObject = barButtonItem;
						found = true;
						ActionBlock block = ^id {
							[barButtonItem.target performSelector:barButtonItem.action];
							return NSStringFromSelector(barButtonItem.action);
						};
						actionBlock = Block_copy(block);
					}
				}
			}
		} else { // TOOLBAR_ITEMS_SECTION_INDEX != section
			if ([currentObject isKindOfClass:[UITabBarController class]]) {
				UITabBarController* tabBarController = currentObject;
				if (row < tabBarController.viewControllers.count) {
					UIViewController* controller = [tabBarController.viewControllers objectAtIndex:row];
					changeObject = controller;
					found = true;
					ActionBlock block = ^id {
						tabBarController.selectedIndex = row;
						return SWF(@"[%@ setSelectedIndex: %d]", [tabBarController className], row);
					};
					actionBlock = Block_copy(block);
				}			
			} else if ([currentObject isKindOfClass:[UINavigationController class]]) {
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
						ActionBlock block = ^id {
							[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
							return SWF(@"[%@ tableView:didSelectRowAtIndexPath: %d %d]", tableView.delegate, section, row);
						};
						actionBlock = Block_copy(block);
					}				
				} else {
					if (row < controller.view.subviews.count) {
						UIView* subview = [[controller.view.subviews reverse] objectAtIndex:row];
						changeObject = subview;
						found = true;
						
						if ([subview isKindOfClass:[UIControl class]]) {
							ActionBlock block = ^id {				
								[(UIControl*)subview sendActionsForControlEvents:UIControlEventTouchUpInside];
								return SWF(@"[%@ sendActionsForControlEvents: %@]", [subview className], @"UIControlEventTouchUpInside");
							};
							actionBlock = Block_copy(block);
						}					
					}
				}
			} else if ([currentObject isKindOfClass:[UITableView class]]) {
				UITableView* tableView = currentObject;
				if (section < [tableView numberOfSections] && row < [tableView numberOfRowsInSection:section]) {
					NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
					UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
					changeObject = cell;
					found = true;
					ActionBlock block = ^id {
						[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
						return SWF(@"[%@ tableView:didSelectRowAtIndexPath: %d %d]", tableView.delegate, section, row);
					};
					actionBlock = Block_copy(block);				
				}
			} else if ([currentObject isKindOfClass:[UIView class]]) {
				UIView* view = currentObject;
				if (row < view.subviews.count) {
					UIView* subview = [[view.subviews reverse] objectAtIndex:row];				
					changeObject = subview;
					found = true;
					if ([subview isKindOfClass:[UIControl class]]) {
						ActionBlock block = ^id {				
							[(UIControl*)subview sendActionsForControlEvents:UIControlEventTouchUpInside];
							return SWF(@"[%@ sendActionsForControlEvents: %@]", [subview className], @"UIControlEventTouchUpInside");
						};
						actionBlock = Block_copy(block);
					}
				}
			} else if ([currentObject isKindOfClass:[CALayer class]]) {
				CALayer* layer = currentObject;
				if (row < layer.sublayers.count) {
					CALayer* sublayer = [[layer.sublayers reverse] objectAtIndex:row];				
					changeObject = sublayer;
					found = true;
				}
#if USE_COCOA
			} else if ([currentObject isKindOfClass:[NSWindow class]]) {
				return [self findTargetObject:[currentObject contentView] arg:arg];
			} else if ([currentObject isKindOfClass:[NSView class]]) {
				UIView* view = currentObject;
				if (row < view.subviews.count) {
					UIView* subview = [view.subviews objectAtIndex:row];				
					changeObject = subview;
					found = true;
					
					if ([subview isKindOfClass:[NSControl class]]) {
						ActionBlock block = ^id {				
							[(NSControl*)subview performClick:subview];
							return SWF(@"[%@ performClick: %@]", [subview className], @"sender");
						};
						actionBlock = Block_copy(block);
					}
				}
#endif
			}
		} // TOOLBAR_ITEMS_SECTION_INDEX != section
		if (! found) {
			return PAIR(NSLocalizedString(@"Not Found", nil), nil); 
		}
	} else if ([arg isNotEmpty]) {
		SEL selector = NSSelectorFromString(arg);
		if ([currentObject respondsToSelector:selector]) {
			if ([currentObject propertyHasObjectType:selector]) {
				id obj = [currentObject performSelector:selector];			
				if (nil != obj) {
					changeObject = obj;
				}
			} else {
				return TRIO(NSLocalizedString(@"Not Object", nil), [NilClass nilClass], [NilClass nilClass]); 
			}
		} else if ([arg hasText:DOT]) {
			id cur = currentObject;
			for (id item in [arg split:DOT]) {
				NSArray* trio = [self findTargetObject:cur arg:item];
				id obj = [trio objectAtSecond];
				if (IS_NIL(obj)) {
					break;
				}
				cur = obj;
			}
			changeObject = cur;
		}
		
		if (nil == changeObject) { // search by title
			NSArray* pair = [self get_targetStringAndBlocks:currentObject];
			NSDictionary* targetStrings = [pair objectAtFirst];
			NSDictionary* targetBlocks = [pair objectAtSecond];
			id obj = [targetStrings	objectForKey:arg];
			if (nil == obj) {
				obj = [targetStrings objectForKey:NSLocalizedString(arg, nil)];
			}
			if (nil == obj) {
				Class klass = NSClassFromString(arg);
				if (nil != klass) {
					changeObject = klass;
					[NEWOBJECTMAN updateNewOne:changeObject];
				}
			} else {
				changeObject = obj;
				actionBlock = [targetBlocks objectForKey:arg];
			}
		}
	}
	if (nil == changeObject) {
		return TRIO(NSLocalizedString(@"Not Found", nil), [NilClass nilClass], [NilClass nilClass]); 
	} else {
		return TRIO(SWF(@"cd %@", [changeObject class]), changeObject, actionBlock);
	}	
}

-(id) get_targetObjectActionBlock:(id)targetObject {
	id actionBlock = nil;
	if ([targetObject isKindOfClass:[UITableViewCell class]]) {
		UITableViewCell* cell = targetObject;
		UITableView* tableView = (UITableView*)cell.superview;
		for (NSIndexPath* indexPath in [tableView indexPathsForVisibleRows]) {
			UITableViewCell* cellObj = [tableView cellForRowAtIndexPath:indexPath];
			if (cell == cellObj) {
				ActionBlock block = ^id {
					[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
					return SWF(@"[%@ tableView:didSelectRowAtIndexPath: %d %d]", tableView.delegate, indexPath.section, indexPath.row);
				};
				actionBlock = Block_copy(block);
				break;
			}
		}
	} else if ([targetObject isKindOfClass:[UIControl class]]) {
		ActionBlock block = ^id {				
			[targetObject sendActionsForControlEvents:UIControlEventTouchUpInside];
			return SWF(@"[%@ sendActionsForControlEvents: %@]", [targetObject className], @"UIControlEventTouchUpInside");
		};
		actionBlock = Block_copy(block);
	} else if ([targetObject isKindOfClass:[UIBarButtonItem class]]) {
		UIBarButtonItem* barButtonItem = targetObject;
		ActionBlock block = ^id {				
			[barButtonItem.target performSelector:barButtonItem.action];
			return NSStringFromSelector(barButtonItem.action);
		};
		actionBlock = Block_copy(block);			
	}
	return actionBlock;
}

-(NSArray*) get_targetStringAndBlocks:(id)currentObject {
	NSMutableDictionary* targetStrings = [NSMutableDictionary dictionary];
	NSMutableDictionary* targetBlocks = [NSMutableDictionary dictionary];
	if ([currentObject isKindOfClass:[UIViewController class]]) {
		UIViewController* controller = currentObject;
		if ([controller.view isKindOfClass:[UITableView class]]) {
			UITableView* tableView = (UITableView*)controller.view;
			for (int section = 0; section < [tableView numberOfSections]; section++) {
				for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
					NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
					UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
					NSString* textLabelText = cell.textLabel.text;
					if (nil != textLabelText) {
						[targetStrings setObject:cell forKey:textLabelText];
						ActionBlock block = ^id {
							[tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
							return SWF(@"[%@ tableView:didSelectRowAtIndexPath: %d %d]", tableView.delegate, section, row);
						};
						[targetBlocks setObject:Block_copy(block) forKey:textLabelText];
					}
				}
			}
		} else {
			for (UIView* subview in controller.view.subviews) {
				if ([subview isKindOfClass:[UIControl class]] && [subview respondsToSelector:@selector(titleLabel)]) {
					NSString* titleLabelText = [[subview performSelector:@selector(titleLabel)] text];
					if (nil != titleLabelText) {
						[targetStrings setObject:subview forKey:titleLabelText];
						ActionBlock block = ^id {
							[(UIControl*)subview sendActionsForControlEvents:UIControlEventTouchUpInside];
							return SWF(@"[%@ sendActionsForControlEvents: %@]", [subview className], @"UIControlEventTouchUpInside");
						};
						[targetBlocks setObject:Block_copy(block) forKey:titleLabelText];						
					}
				}
			}
		}
	}
	return PAIR(targetStrings, targetBlocks);
}

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

