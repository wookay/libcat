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

//#import "TouchSynthesis.h"


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
		return [COMMANDMAN performSelector:NSSelectorFromString(selectorStr) withObject:[self currentTargetObjectOrTopViewController] withObject:arg];
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

	NSString* lastMethodUppercased = SWF(@"set%@:", [lastMethod uppercaseFirstCharacter]);
	SEL setterSelector = NSSelectorFromString(lastMethodUppercased);
	if ([target respondsToSelector:setterSelector]) {		
		id obj = [self arg_to_proper_object:arg];
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
	return [ary join:LF];
}

-(id) arg_to_proper_object:(id)arg {
	NSString* obj = [[[arg strip] slice:1 backward:-1] strip];
	return obj;
}

-(NSString*) getterChain:(id)command arg:(id)arg {
	id target = currentTargetObject;
	NSMutableArray* ary = [NSMutableArray array];
	for (NSString* method in [command split:DOT]) {
		SEL selector = NSSelectorFromString(method);
		if ([target respondsToSelector:selector]) {
			NSMethodSignature* sig = [target methodSignatureForSelector:selector];
			const char* returnType = [sig methodReturnType];
			switch (*returnType) {
				case _C_ID:
					target = [target performSelector:selector];
					[ary addObject:SWF(@"%@ => %@", method, target)];
					break;
				case _C_VOID: {
						BOOL found = true;
						NSMethodSignature* sig = [target methodSignatureForSelector:selector];
						switch ([sig numberOfArguments]) {
							case 2:
								[target performSelector:selector];
								break;
								
							case 3: {
									const char* argType = [sig getArgumentTypeAtIndex:2];
									id argObj = nil;
									switch (*argType) {
										case _C_ID:
											argObj = arg;
											[target performSelector:selector withObject:argObj];
											break;
										case _C_INT:
											argObj = (id)[arg intValue];
											[target performSelector:selector withObject:argObj];
											break;
										case _C_FLT: {
												Method m = class_getInstanceMethod([target class], selector);
												IMP imp = method_getImplementation(m);
												((id (*)(id, SEL, float))imp)(target, selector, [arg floatValue]);
											}
											break;											
										default:
											found = false;
											break;
									}
								}
								break;
								
							default:
								log_info(@"sig numberOfArguments %d", [sig numberOfArguments]);
								found = false;
								break;
						}
						if (found) {
							[ary addObject:SWF(@"%@", NSStringFromSelector(selector))];
						} else {
							[ary addObject:SWF(@"%@ => %@", method, [COMMANDMAN commandNotFound])];
						}
					}
					break;
				default: {
					SEL toStringSelector = NSSelectorFromString(SWF(@"%@ToString", method));
					if ([target respondsToSelector:toStringSelector]) {
						target = [target performSelector:toStringSelector];
						[ary addObject:SWF(@"%@ => %@", method, target)];
					} else {
						[ary addObject:SWF(@"%@ => %@", method, [COMMANDMAN commandNotFound])];
					}
				}
					break;
			}
		} else {
			[ary addObject:SWF(@"%@ => %@", method, [COMMANDMAN commandNotFound])];
		}
	}
	return [ary join:LF];
}

-(UIViewController*) get_topViewController {
	UIViewController* rootVC = [self get_rootViewController];
	if (nil == rootVC) {
		return nil;
	} else {
		if ([rootVC isKindOfClass:[UINavigationController class]]) {
			UINavigationController* navigationController = (UINavigationController*)rootVC;
			return navigationController.topViewController;
		} else if ([rootVC isKindOfClass:[UITabBarController class]]) {
			UITabBarController* tabBarController = (UITabBarController*)rootVC;
			if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
				UINavigationController* navigationController = (UINavigationController*)tabBarController.selectedViewController;
				return navigationController.topViewController;
			} else {
				return tabBarController.selectedViewController;
			}			
		} else {
			return rootVC;
		}
	}
}

-(UIViewController*) get_rootViewController {
	id delegate = [UIApplication sharedApplication].delegate;
	if ([delegate respondsToSelector:@selector(navigationController)]) {
		return [delegate performSelector:@selector(navigationController)];
	} else if ([delegate respondsToSelector:@selector(tabBarController)]) {
		return [delegate performSelector:@selector(tabBarController)];	
	} else {
		return nil;
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
