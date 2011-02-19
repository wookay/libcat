//
//  ConsoleManager.m
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ConsoleManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CommandManager.h"
#import "HTTPServer.h"
#import "LoggerServer.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "GeometryExt.h"
#import "Logger.h"
#import "objc/runtime.h"
#import "Inspect.h"
#import "NSIndexPathExt.h"
#import "NewObjectManager.h"
#import "NSObjectExt.h"
#import "PropertyManipulator.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>

#define DEFAULT_ENV_COLUMNS 100

// used also in console.rb
#define CONSOLE_SERVER_PORT 8080
#define LOGGER_SERVER_PORT_OFFSET 10

@implementation ConsoleManager
@synthesize currentTargetObject;
@synthesize server_port;
@synthesize COLUMNS;

-(void) start_up {
	[self start_servers];
	[self show_console_button];
}

-(void) start_up:(int)port {
	[self start_servers:port];
}

-(void) start_servers {
	[self start_servers:CONSOLE_SERVER_PORT];
}

-(void) start_servers:(int)port {
	server_port = port;
	[[HTTPServer sharedServer] startWithPort:port];
	[[LoggerServer sharedServer] startWithPort:port+LOGGER_SERVER_PORT_OFFSET];
	LOGGERMAN.delegate = [LoggerServer sharedServer];	
	[LOGGERMAN.delegate addLogTextView];
//	log_info(@"start_servers %@:%d", [self get_local_ip_address], port);
}

-(void) stop {
	[[HTTPServer sharedServer] stop];
	[[LoggerServer sharedServer] stop];
	[LOGGERMAN.delegate removeLogTextView];
	LOGGERMAN.delegate = nil;	
	[self hide_console_button];
}

-(NSString*) get_local_ip_address {
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	
	return @"localhost";
}

-(id) input:(NSString*)command arg:(id)arg {
	NSString* selectorStr = [COMMANDMAN.commandsMap objectForKey:command];
	if (nil == selectorStr) {
		if ([[arg strip] hasPrefix:EQUAL]) {
			return [self setterChain:command arg:arg];
		} else {
			return [self getterChain:command arg:arg];
		}
	} else {
		SEL selector = NSSelectorFromString(selectorStr);
		if ([COMMANDMAN respondsToSelector:selector]) {
			return [COMMANDMAN performSelector:selector withObject:[self currentTargetObjectOrTopViewController] withObject:arg];
		} else {
			return SWF(@"%@ : %@", NSLocalizedString(@"Command Not Found", nil), command);
		}
	}
}

-(id) currentTargetObjectOrTopViewController {
	if (nil == self.currentTargetObject) {
		return [self get_topViewController];
	} else {
		return self.currentTargetObject;
	}
}

-(NSString*) setterChain:(id)command arg:(id)arg {
	NSMutableArray* ary = [NSMutableArray array];
	id target = currentTargetObject;
	NSString* lastMethod = nil;
	
	NSArray* commands = [command split:DOT];
	if (commands.count > 1) {
		lastMethod = [commands objectAtLast];
		for (NSString* method in [commands slice:0 backward:-2]) {
			SEL selector = NSSelectorFromString(method);
			if ([target respondsToSelector:selector]) {
				NSMethodSignature* sig = [target methodSignatureForSelector:selector];
				const char* returnType = [sig methodReturnType];
				switch (*returnType) {
					case _C_ID:
						target = [target performSelector:selector];
						[ary addObject:SWF(@"%@\t===>\t%@", method, target)];
						break;
					default: {
						SEL sel = NSSelectorFromString(method);
						if ([target respondsToSelector:sel]) {
							BOOL failed = false;
							target = [target getPropertyValue:sel failed:&failed];
							[ary addObject:SWF(@"%@\t===>\t%@", method, target)];
						} else {
							[ary addObject:SWF(@"%@\t===>\t%@", method, @"???")];
						}
					}
						break;
				}
			} else {
				[ary addObject:SWF(@"%@\t===>\t%@", method, [COMMANDMAN commandNotFound])];
			}
		}
	} else if (commands.count == 1) {
		lastMethod = [commands objectAtFirst];
	} else {
		return [COMMANDMAN commandNotFound];
	}

	if ([lastMethod hasPrefix:NEW_OBJECT_PREFIX]) {
		NSString* getterCommand = nil;
		NSString* getterArg = nil;
		arg = [[[arg strip] slice:1 backward:-1] strip];
		NSRange commandRange = [arg rangeOfString:SPACE];
		if (IS_NOT_FOUND(commandRange)) {
			getterCommand = arg;
		} else {
			getterCommand = [arg slice:0 :commandRange.location];
			getterArg = [arg slice:commandRange.location backward:-1];
		}
		id obj = [self getterChainObject:getterCommand arg:getterArg returnType:kGetterReturnTypeObject];
		[NEWOBJECTMAN setNewObject:obj forKey:lastMethod];
		[ary addObject:SWF(@"%@ = %@", lastMethod, obj)];							
	} else {
		id strObj = [self arg_to_proper_object:arg];
		NSString* lastMethodUppercased = SWF(@"set%@:", [lastMethod uppercaseFirstCharacter]);
		SEL sel = NSSelectorFromString(lastMethodUppercased);
		if ([target respondsToSelector:sel]) {
			NSMethodSignature* sig = [target methodSignatureForSelector:sel];
			const char* argType = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
			NSString* attributeString = SWF(@"%s", argType);
			if (_C_INT == *argType && [strObj isAlphabet]) {
				NSNumber* number = [PROPERTYMAN.typeInfoTable enumStringToNumber:strObj];
				if (nil != number) {
					strObj = SWF(@"%@", number);
				}
			} else if (_C_ID == *argType) {
				BOOL failed = false;
				id obj = [PROPERTYMAN.typeInfoTable objectStringToObject:strObj failed:&failed];
				if (! failed) {
					strObj = obj;
				}				
			}
			BOOL updated = false;
			BOOL failed = false;
			id targetObj = [PROPERTYMAN performTypeClassMethod:strObj targetObject:target propertyName:lastMethod failed:&failed];
			if (nil == targetObj) {
				if (failed) {
					if (nil == strObj) {
						updated = [target setProperty:lastMethod value:strObj attributeString:attributeString];
					}
				} else {
					updated = [target setProperty:lastMethod value:strObj attributeString:attributeString];
				}
			} else {
				updated = [target setProperty:lastMethod value:targetObj attributeString:attributeString];
			}
			if (updated) {
				NSString* detail = [PROPERTYMAN.typeInfoTable objectDescription:strObj targetClass:NSStringFromClass([target class]) propertyName:lastMethod];
				[ary addObject:SWF(@"%@ = %@", lastMethod, detail)];
			} else {
				[ary addObject:SWF(@"[%@ %@%@] %@", [target class], lastMethodUppercased, strObj, NSLocalizedString(@"failed", nil))];
			}						
		} else {
			if ([self respondsToSelector:sel]) {
				NSMethodSignature* sig = [self methodSignatureForSelector:sel];
				const char* argType = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
				if (_C_INT == *argType) {
					Method m = class_getInstanceMethod([self class], sel);
					IMP imp = method_getImplementation(m);					
					((void (*)(id, SEL, int))imp)(self, sel, [strObj intValue]);
				} else {
					[self performSelector:sel withObject:strObj];
				}
				NSString* detail = [PROPERTYMAN.typeInfoTable objectDescription:strObj targetClass:NSStringFromClass([self class]) propertyName:lastMethod];
				[ary addObject:SWF(@"%@ = %@", lastMethod, detail)];
			} else {
				[ary addObject:SWF(@"%@ %@", lastMethodUppercased, [COMMANDMAN commandNotFound])];
			}
		}
	}
	return [ary join:LF];
}

-(id) arg_to_proper_object:(id)arg {
	id obj = [self get_argObject:[[[arg strip] slice:1 backward:-1] strip]];
	return obj;
}


-(NSString*) getterChain:(id)command arg:(id)arg {
	return [self getterChainObject:command arg:arg returnType:kGetterReturnTypeString];
}

-(id) getterChainObject:(id)command arg:(id)arg returnType:(GetterReturnType)getterReturnType {
	id target = currentTargetObject;
	NSMutableArray* ary = [NSMutableArray array];
	if ([command isNil]) {
		return nil;
	}
	for (NSString* method in [command split:DOT]) {
		if ([method isEmpty]) {
			continue;
		}
		
		SEL selector = NSSelectorFromString(method);
		NSString* oldTargetStr = SWF(@"%@", [target class]);
		if ([target respondsToSelector:selector]) {
			BOOL found = true;
			NSMethodSignature* sig = [target methodSignatureForSelector:selector];
			const char* returnType = [sig methodReturnType];
			switch ([sig numberOfArguments]) {
#define ARGUMENT_COUNT_IS_ZERO	2
#define ARGUMENT_COUNT_IS_ONE	3
#define ARGUMENT_COUNT_IS_TWO	4
#define ARGUMENT_INDEX_TWO 3
				case ARGUMENT_COUNT_IS_ZERO: {
						BOOL failed = false;
						id obj = [target getPropertyValue:selector failed:&failed];
						if (failed) {
							if (_C_VOID == *returnType) {
								[target performSelector:selector];
								[ary addObject:SWF(@"[%@ %@]", oldTargetStr, method)];
							} else {
								found = false;
							}
						} else {
							Class targetClass = [target classForProperty:method]; 
							if (_C_ID == *returnType) {
								target = obj;
							}
							NSString* detail = [PROPERTYMAN.typeInfoTable objectDescription:obj targetClass:NSStringFromClass(targetClass) propertyName:method];
							[ary addObject:SWF(@"[%@ %@]\t===>\t%@", oldTargetStr, method, detail)];
						}							
					}
					break;
					
				case ARGUMENT_COUNT_IS_ONE: {
					id argObj = [self get_argObject:arg];
					const char* argType = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
					switch (*argType) {
						case _C_ID:
							switch (*returnType) {
								case _C_ID:
									target = [target performSelector:selector withObject:argObj];
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%@", oldTargetStr, method, argObj, target)];
									break;
									
								case _C_INT:
								case _C_UINT:
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%d", oldTargetStr, method, argObj, [target performSelector:selector withObject:argObj])];
									break;
									
								case _C_VOID:
									[target performSelector:selector withObject:argObj];
									[ary addObject:SWF(@"[%@ %@ %@]", oldTargetStr, method, argObj)];
									break;
									
								default:
									found = false;
									break;
							} // switch(*returnType)
							break;
							
						case _C_INT:
							switch (*returnType) {
								case _C_ID:
									target = [target performSelector:selector withObject:(id)[arg intValue]];
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%@", oldTargetStr, method, arg, target)];
									break;
									
								case _C_INT:
								case _C_UINT:
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%d", oldTargetStr, method, arg, [target performSelector:selector withObject:(id)[arg intValue]])];
									break;
									
								case _C_VOID:
									[target performSelector:selector withObject:(id)[arg intValue]];
									[ary addObject:SWF(@"[%@ %@ %@]", oldTargetStr, method, argObj)];
									break;
									
								default:
									found = false;
									break;
							} // switch(*returnType)
							break;
							
						case _C_UINT:
							switch (*returnType) {
								case _C_ID:
									target = [target performSelector:selector withObject:(id)[arg unsignedIntValue]];
									[ary addObject:SWF(@"[%@ @% %@]\t===>\t%@", oldTargetStr, method, arg, target)];
									break;
									
								case _C_INT:
								case _C_UINT:
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%d", oldTargetStr, method, arg, [target performSelector:selector withObject:(id)[arg unsignedIntValue]])];
									break;
									
								case _C_VOID:
									[target performSelector:selector withObject:(id)[arg unsignedIntValue]];
									[ary addObject:SWF(@"[%@ %@ %@]", oldTargetStr, method, argObj)];
									break;
									
								default:
									found = false;
									break;
							} // switch(*returnType)
							break;
							
						case _C_FLT: {
							Method m = class_getInstanceMethod([target class], selector);
							IMP imp = method_getImplementation(m);
							switch (*returnType) {
								case _C_ID:
									target = ((id (*)(id, SEL, float))imp)(target, selector, [arg floatValue]);
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%@", oldTargetStr, method, arg, target)];
									break;
									
								case _C_INT:
								case _C_UINT: {
									int returnValue = ((int (*)(id, SEL, float))imp)(target, selector, [arg floatValue]);
									[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%d", oldTargetStr, method, arg, returnValue)];
								}
									break;
									
								case _C_VOID:
									((void (*)(id, SEL, float))imp)(target, selector, [arg floatValue]);
									[ary addObject:SWF(@"[%@ %@ %@]", oldTargetStr, method, argObj)];
									break;
									
								default:
									found = false;
									break;
							} // switch(*returnType)
						} // case _C_FLT
							break;	
							
						default:
							found = false;
							break;
					} // switch(*argType)
				} // ARGUMENT_COUNT_IS_ONE
					break;
					
				case ARGUMENT_COUNT_IS_TWO: {
					if ([method isEqualToString:@"tableView:cellForRowAtIndexPath:"]) {
						int section = 0;
						int row = 0;
						if ([arg hasText:SPACE]) {
							NSArray* pair = [arg split:SPACE];
							section = [[pair objectAtFirst] to_int];
							row = [[pair objectAtSecond] to_int];
						} else {
							row = [arg to_int];
						}
						NSIndexPath* indexPath = [NSIndexPath indexPathWithSection:section Row:row];
						UITableView* tableView = nil;
						if ([target respondsToSelector:@selector(tableView)]) {
							tableView = [target performSelector:@selector(tableView)];
						}
						target = [target performSelector:selector withObject:tableView withObject:indexPath];
						[ary addObject:SWF(@"[%@ %@ %@]\t===>\t%@", oldTargetStr, method, arg, target)];	
					} else {
						NSArray* pair = [arg split:SPACE];
						id objOne = [pair objectAtFirst];
						id objTwo = [pair objectAtSecond];
						const char* argTypeOne = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
						const char* argTypeTwo = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_TWO];
						if (_C_ID == *argTypeOne && _C_UINT == *argTypeTwo) {
							[target performSelector:selector withObject:objOne withObject:(id)[objTwo intValue]];	
							[ary addObject:SWF(@"[%@ %@ %@]", oldTargetStr, method, arg)];	
						} else {
							found  = false;
						}
					}
				} // ARGUMENT_COUNT_IS_TWO
					break;
					
				default:
					found = false;
					break;
			} // switch ([sig numberOfArguments])
			if (found) {
			} else {
				[ary addObject:SWF(@"%@\t===>\t%@", method, [COMMANDMAN commandNotFound])];
			}
		} else {
			SEL sel = NSSelectorFromString(method);
			if ([target respondsToSelector:sel]) {
				BOOL failed = false;
				target = [target getPropertyValue:sel failed:&failed];
				[ary addObject:SWF(@"[%@ %@]\t===>\t%@", oldTargetStr, method, target)];
			} else {
				NSString* newArg = nil;
				if (nil == arg) {
					newArg = method;
				} else {
					newArg = SWF(@"%@ %@", method, arg);
				}
				NSArray* pair = [COMMANDMAN findTargetObject:[self currentTargetObjectOrTopViewController] arg:newArg];
				id obj = [pair objectAtSecond];
				if ([obj isNotNil]) {
					[ary addObject:SWF(@"%@", obj)];
				} else {
					[ary addObject:SWF(@"%@\t===>\t%@", method, [COMMANDMAN commandNotFound])];
				}
			}
		}
	} // for
	if (kGetterReturnTypeObject == getterReturnType) {
		return target;
	} else {
		return [ary join:LF];
	}
}

-(id) get_argObject:(NSString*)arg {
	BOOL foundNewObject = false;
	NSMutableArray* newObjectArgs = [NSMutableArray array];
	for (NSString* one in [arg split:SPACE]) {
		if ([one hasPrefix:NEW_OBJECT_PREFIX]) {
			id obj = [NEWOBJECTMAN newObjectForKey:one];
			if (nil != obj) {
				foundNewObject = true;
				[newObjectArgs addObject:obj];
			}
		} else {
			[newObjectArgs addObject:one];
		}
	}
	if (foundNewObject) {
		if (1 == newObjectArgs.count) {
			return [newObjectArgs objectAtFirst];
		} else {
			return newObjectArgs;
		}
	} else {
		return arg;
	}
}

-(id) input:(NSString*)input {
	NSRange commandRange = [input rangeOfString:SPACE];
	if (IS_NOT_FOUND(commandRange)) {
		return [self input:input arg:nil];
	} else {
		NSString* command = [input slice:0 :commandRange.location];
		id arg = [input slice:commandRange.location backward:-1];
		return [self input:command arg:arg];		
	}
}


-(UIViewController*) get_topViewController {
	UIViewController* rootVC = [self get_rootViewController];
	if (nil == rootVC) {
		return nil;
	} else {
		UIViewController* topViewController = nil;
		if ([rootVC isKindOfClass:[UINavigationController class]]) {
			UINavigationController* navigationController = (UINavigationController*)rootVC;
			topViewController = navigationController.topViewController;
		} else if ([rootVC isKindOfClass:[UITabBarController class]]) {
			UITabBarController* tabBarController = (UITabBarController*)rootVC;
			if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
				UINavigationController* navigationController = (UINavigationController*)tabBarController.selectedViewController;
				topViewController = navigationController.topViewController;
			} else {
				topViewController = tabBarController.selectedViewController;
			}			
		} else {
			topViewController = rootVC;
		}
		if ([topViewController respondsToSelector:@selector(modalViewController)]) {
			return topViewController.modalViewController ? topViewController.modalViewController : topViewController;
		} else {
			return topViewController;
		}
	}
}

-(UIWindow*) get_keyWindow {
	return [UIApplication sharedApplication].keyWindow;
}

-(UIViewController*) get_rootViewController {
	id delegate = [UIApplication sharedApplication].delegate;
	if ([delegate respondsToSelector:@selector(navigationController)]) {
		return [delegate performSelector:@selector(navigationController)];
	} else if ([delegate respondsToSelector:@selector(tabBarController)]) {
		return [delegate performSelector:@selector(tabBarController)];	
	} else if ([delegate respondsToSelector:@selector(viewController)]) {
		return [delegate performSelector:@selector(viewController)];	
#if USE_COCOA
	} else if ([delegate conformsToProtocol:@protocol(NSApplicationDelegate)]) {
		NSWindow* window = [delegate performSelector:@selector(window)];
		if (nil == window) {
			return nil;
		} else {
			return window.windowController ? window.windowController : window;
		}
#endif
	} else {
		return nil;
	}
}

-(IBAction) touchedConsoleButton:(id)sender {
	[PROPERTYMAN showConsoleController];
}


-(void) show_console_button {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	CGRect windowFrame = window.frame;
	CGRect consoleRect = CGRectOffset(CGRectTopRight(windowFrame, 70, 19), -2, 21);
	UIButton* consoleButton = [[UIButton alloc] initWithFrame:consoleRect];
	[consoleButton addTarget:self action:@selector(touchedConsoleButton:) forControlEvents:UIControlEventTouchUpInside];
	consoleButton.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:consoleRect.size.height/1.3];
	consoleButton.titleLabel.textAlignment = UITextAlignmentCenter;
	consoleButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	consoleButton.titleLabel.adjustsFontSizeToFitWidth = true;
	consoleButton.layer.cornerRadius = 4.1;
	consoleButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0 alpha:0.8];
	[consoleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[consoleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
	[consoleButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[consoleButton setTitle:NSLocalizedString(@"Console", nil) forState:UIControlStateNormal];
	[window addSubview:consoleButton];
	[consoleButton release];
	
	CGRect logRect = CGRectOffset(CGRectTopRight(windowFrame, 45, consoleRect.size.height), -10 - consoleRect.size.width, consoleRect.origin.y);
	UIButton* showLogsButton = [[UIButton alloc] initWithFrame:logRect];
	BOOL settingConsoleLogsButton = [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_CONSOLE_LOGS_BUTTON];
	showLogsButton.hidden = settingConsoleLogsButton;
	showLogsButton.tag = kTagLogsButton;
	[showLogsButton addTarget:self action:@selector(touchedToggleLogsButton:) forControlEvents:UIControlEventTouchUpInside];
	showLogsButton.titleLabel.font = consoleButton.titleLabel.font;
	showLogsButton.titleLabel.textAlignment = consoleButton.titleLabel.textAlignment;
	showLogsButton.titleLabel.baselineAdjustment = consoleButton.titleLabel.baselineAdjustment;
	showLogsButton.titleLabel.adjustsFontSizeToFitWidth = consoleButton.titleLabel.adjustsFontSizeToFitWidth;
	showLogsButton.layer.cornerRadius = consoleButton.layer.cornerRadius;
	showLogsButton.backgroundColor = consoleButton.backgroundColor;
	[showLogsButton setTitleColor:[consoleButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
	[showLogsButton setTitleColor:[consoleButton titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
	[showLogsButton setTitleShadowColor:[consoleButton titleShadowColorForState:UIControlStateNormal] forState:UIControlStateNormal];
	[showLogsButton setTitle:NSLocalizedString(@"Logs", nil) forState:UIControlStateNormal];	
	[window addSubview:showLogsButton];
	[showLogsButton release];		
}

-(void) toggle_logs_button {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	UIButton* showLogsButton = (UIButton*)[window viewWithTag:kTagLogsButton];
	BOOL hidden = showLogsButton.hidden;
	if (hidden) {
		[window bringSubviewToFront:showLogsButton];
	} else {
		[LoggerServer sharedServer].logTextView.hidden = true;
	}
	showLogsButton.hidden = ! hidden;
}

-(IBAction) touchedToggleLogsButton:(id)sender {
	BOOL hidden = [LoggerServer sharedServer].logTextView.hidden;
	if (hidden) {
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		[window bringSubviewToFront:[LoggerServer sharedServer].logTextView];
	}
	[LoggerServer sharedServer].logTextView.hidden = ! hidden;
}

-(void) hide_console_button {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	for (UIView* view in window.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			[view removeFromSuperview];
		} else if ([view isKindOfClass:[UITextView class]]) {
			[view removeFromSuperview];
		}
	}
}

+ (ConsoleManager*) sharedManager {
	static ConsoleManager*	manager = nil;
	if (!manager) {
		manager = [ConsoleManager new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
		self.currentTargetObject = nil;
		self.COLUMNS = DEFAULT_ENV_COLUMNS;
	}
	return self;
}

- (void)dealloc {
	currentTargetObject = nil;
	[super dealloc];
}

@end