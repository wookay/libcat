//
//  ConsoleManager.m
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "ConsoleManager.h"
#import "CommandManager.h"
#import "HTTPServer.h"
#import "LoggerServer.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "GeometryExt.h"
#import "Logger.h"
#import "objc/runtime.h"
#import "NSObjectValueToString.h"
#import "NSObjectSetValueFromString.h"
#import "Inspect.h"
#import "NSIndexPathExt.h"
#import "NewObjectManager.h"
#import "NSObjectExt.h"

// used also in console.rb
#define CONSOLE_SERVER_PORT 8080
#define LOGGER_SERVER_PORT	8081


@implementation ConsoleManager
@synthesize currentTargetObject;

-(void) start_servers {
	[[HTTPServer sharedServer] startWithPort:CONSOLE_SERVER_PORT];
	[[LoggerServer sharedServer] startWithPort:LOGGER_SERVER_PORT];
	LOGGERMAN.delegate = [LoggerServer sharedServer];
}

-(void) stop_servers {
	[[HTTPServer sharedServer] stop];
	[[LoggerServer sharedServer] stop];
	LOGGERMAN.delegate = nil;
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
						[ary addObject:SWF(@"%@ => %@", method, target)];
						break;
					default: {
						SEL toStringSelector = NSSelectorFromString(SWF(@"%@ToString", method));
						if ([target respondsToSelector:toStringSelector]) {
							target = [target performSelector:toStringSelector];
							[ary addObject:SWF(@"%@ => %@", method, target)];
						} else {
							[ary addObject:SWF(@"%@ => %@", method, @"???")];
						}
					}
						break;
				}
			} else {
				[ary addObject:SWF(@"%@ => %@", method, [COMMANDMAN commandNotFound])];
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
		id obj = [self arg_to_proper_object:arg];
		NSString* lastMethodUppercased = SWF(@"set%@:", [lastMethod uppercaseFirstCharacter]);
		SEL setterSelector = NSSelectorFromString(lastMethodUppercased);
		if ([target respondsToSelector:setterSelector]) {		
			NSString* setValueFromString = SWF(@"set%@FromString:", [lastMethod uppercaseFirstCharacter]);
			SEL fromStringSelector = NSSelectorFromString(setValueFromString);
			if ([target respondsToSelector:fromStringSelector]) {
				[target performSelector:fromStringSelector withObject:obj];
				[ary addObject:SWF(@"%@ = %@", lastMethod, obj)];							
			} else {
				[ary addObject:SWF(@"[%@ %@%@] %@", [target class], setValueFromString, obj, NSLocalizedString(@"failed", nil))];
			}
		} else {
			[ary addObject:SWF(@"%@ %@", lastMethodUppercased, [COMMANDMAN commandNotFound])];
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

-(id) getterChainObject:(id)command arg:(id)arg returnType:(GetterReturnType)returnType {
	id target = currentTargetObject;
	NSMutableArray* ary = [NSMutableArray array];
	for (NSString* method in [command split:DOT]) {
		if ([method isEmpty]) {
			continue;
		}
		
		SEL selector = NSSelectorFromString(method);
		NSString* oldTargetStr = SWF(@"%@", [target downcasedClassName]);
		if ([target respondsToSelector:selector]) {
			BOOL found = true;
			NSMethodSignature* sig = [target methodSignatureForSelector:selector];
			const char* returnType = [sig methodReturnType];
			switch ([sig numberOfArguments]) {
#define ARGUMENT_COUNT_IS_ZERO	2
#define ARGUMENT_COUNT_IS_ONE	3
#define ARGUMENT_COUNT_IS_TWO	4
#define ARGUMENT_INDEX_ONE 2
#define ARGUMENT_INDEX_TWO 3
				case ARGUMENT_COUNT_IS_ZERO:
					switch (*returnType) {
						case _C_ID:
							target = [target performSelector:selector];
							[ary addObject:SWF(@"[%@ %@] => %@", oldTargetStr, method, target)];
							break;
							
						case _C_INT:
						case _C_UINT:
							[ary addObject:SWF(@"[%@ %@] => %d", oldTargetStr, method, [target performSelector:selector])];
							break;
							
						case _C_VOID:
							[target performSelector:selector];
							[ary addObject:SWF(@"[%@ %@]", oldTargetStr, method)];
							break;
							
						default:
							log_info(@"zero *returnType %c", *returnType);
							found = false;
							break;
					} // switch (*returnType)
					break;
					
				case ARGUMENT_COUNT_IS_ONE: {
					id argObj = [self get_argObject:arg];
					const char* argType = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
					switch (*argType) {
						case _C_ID:
							switch (*returnType) {
								case _C_ID:
									target = [target performSelector:selector withObject:argObj];
									[ary addObject:SWF(@"[%@ %@ %@] => %@", oldTargetStr, method, argObj, target)];
									break;
									
								case _C_INT:
								case _C_UINT:
									[ary addObject:SWF(@"[%@ %@ %@] => %d", oldTargetStr, method, argObj, [target performSelector:selector withObject:argObj])];
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
									[ary addObject:SWF(@"[%@ %@ %@] => %@", oldTargetStr, method, arg, target)];
									break;
									
								case _C_INT:
								case _C_UINT:
									[ary addObject:SWF(@"[%@ %@ %@] => %d", oldTargetStr, method, arg, [target performSelector:selector withObject:(id)[arg intValue]])];
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
									[ary addObject:SWF(@"[%@ @% %@] => %@", oldTargetStr, method, arg, target)];
									break;
									
								case _C_INT:
								case _C_UINT:
									[ary addObject:SWF(@"[%@ %@ %@] => %d", oldTargetStr, method, arg, [target performSelector:selector withObject:(id)[arg unsignedIntValue]])];
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
									[ary addObject:SWF(@"[%@ %@ %@] => %@", oldTargetStr, method, arg, target)];
									break;
									
								case _C_INT:
								case _C_UINT: {
									int returnValue = ((int (*)(id, SEL, float))imp)(target, selector, [arg floatValue]);
									[ary addObject:SWF(@"[%@ %@ %@] => %d", oldTargetStr, method, arg, returnValue)];
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
						[ary addObject:SWF(@"[%@ %@ %@] => %@", oldTargetStr, method, arg, target)];	
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
				[ary addObject:SWF(@"%@ => %@", method, [COMMANDMAN commandNotFound])];
			}
		} else {
			SEL toStringSelector = NSSelectorFromString(SWF(@"%@ToString", method));
			if ([target respondsToSelector:toStringSelector]) {
				target = [target performSelector:toStringSelector];
				[ary addObject:SWF(@"[%@ %@] => %@", oldTargetStr, method, target)];
			} else {
				NSString* newArg = nil;
				if (nil == arg) {
					newArg = method;
				} else {
					newArg = SWF(@"%@ %@", method, arg);
				}
				NSArray* pair = [COMMANDMAN findTargetObject:[self currentTargetObjectOrTopViewController] arg:newArg];
				id obj = [pair objectAtSecond];
				if ([obj isNotNull]) {
					[ary addObject:SWF(@"%@", obj)];
				} else {
					[ary addObject:SWF(@"%@ => %@", method, [COMMANDMAN commandNotFound])];
				}
			}
		}
	} // for
	if (kGetterReturnTypeObject == returnType) {
		return target;
	} else {
		return [ary join:LF];
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
		if (nil == topViewController.modalViewController) {
			return topViewController;
		} else {
			return topViewController.modalViewController;
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
	} else {
		return nil;
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
	}
	return self;
}

- (void)dealloc {
	currentTargetObject = nil;
	[super dealloc];
}

@end
