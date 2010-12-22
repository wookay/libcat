//
//  ConsoleManager.h
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CONSOLEMAN	[ConsoleManager sharedManager]

typedef enum { kGetterReturnTypeString, kGetterReturnTypeObject } GetterReturnType ;


@interface ConsoleManager : NSObject {
	id currentTargetObject;
}
@property (nonatomic, assign) id currentTargetObject;

-(id) input:(NSString*)command arg:(id)arg ;
-(id) input:(NSString*)input ;
+ (ConsoleManager*) sharedManager ;

-(void) start_servers ;
-(void) stop_servers ;	
-(UIViewController*) get_topViewController ;
-(UIWindow*) get_keyWindow ;
-(UIViewController*) get_rootViewController ;
-(id) get_argObject:(NSString*)arg ;
-(NSString*) getterChain:(id)command arg:(id)arg ;
-(id) arg_to_proper_object:(id)arg ;
-(NSString*) setterChain:(id)command arg:(id)arg ;
-(id) currentTargetObjectOrTopViewController ;
-(id) getterChainObject:(id)command arg:(id)arg returnType:(GetterReturnType)returnType ;
@end
