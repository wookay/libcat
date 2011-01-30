//
//  ConsoleManager.h
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONSOLEMAN	[ConsoleManager sharedManager]

typedef enum { kGetterReturnTypeString, kGetterReturnTypeObject } GetterReturnType ;


@interface ConsoleManager : NSObject {
	id currentTargetObject;
}
@property (nonatomic, retain) id currentTargetObject; // retain to get the view class in command_prompt:arg:

-(id) input:(NSString*)command arg:(id)arg ;
-(id) input:(NSString*)input ;
+ (ConsoleManager*) sharedManager ;

-(void) start_servers ;
-(void) start_servers:(int)port ;
-(void) stop_servers ;	
-(id) get_argObject:(NSString*)arg ;
-(NSString*) getterChain:(id)command arg:(id)arg ;
-(id) arg_to_proper_object:(id)arg ;
-(NSString*) setterChain:(id)command arg:(id)arg ;
-(id) currentTargetObjectOrTopViewController ;
-(id) getterChainObject:(id)command arg:(id)arg returnType:(GetterReturnType)returnType ;

-(UIViewController*) get_topViewController ;
-(UIWindow*) get_keyWindow ;
-(UIViewController*) get_rootViewController ;
@end
