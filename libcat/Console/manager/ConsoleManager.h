//
//  ConsoleManager.h
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONSOLEMAN	[ConsoleManager sharedManager]
#define SETTING_CONSOLE_SHOW_LOGS_BUTTON @"Console Show Logs Button"
#define SETTING_CONSOLE_RECORD_BUTTON @"Console Record Button"

#define LS_OPTION_RECURSIVE		@"-r"
#define MEMORY_ADDRESS_PREFIX	@"0x"

typedef enum { kGetterReturnTypeInspect, kGetterReturnTypeObject } GetterReturnType ;


@interface ConsoleManager : NSObject {
	id currentTargetObject; // TARGET
	int server_port;
	int COLUMNS;
}
@property (nonatomic, retain) id currentTargetObject; // retain to get the view class in command_prompt:arg:
@property (nonatomic, readonly) int server_port;
@property (nonatomic) int COLUMNS;

-(id) inputCommand:(NSString*)command arg:(id)arg ;
-(id) input:(NSString*)command arg:(id)arg ;
-(id) input:(NSString*)input ;
+ (ConsoleManager*) sharedManager ;

-(NSArray*) mapTargetObject:(id)targetObject arg:(id)arg ;
-(id) get_argObject:(NSString*)arg ;
-(NSString*) getterChain:(id)command arg:(id)arg ;
-(NSString*) setterChain:(id)command arg:(id)arg ;
-(id) currentTargetObjectOrTopViewController ;
-(id) getterChainObject:(id)target command:(id)command arg:(id)arg returnType:(GetterReturnType)getterReturnType ;

-(UIViewController*) get_topViewController ;
-(UIViewController*) get_rootViewController ;

+(void) run ;
+(void) run:(int)port ;
+(void) stop ;
+(void) hide_console_button ;
-(void) start_servers ;
-(void) start_servers:(int)port ;
-(void) stop ;
-(NSString*) get_local_ip_address ;
-(void) make_console_buttons ;
-(void) hide_console_button ;
-(void) toggle_logs_button ;
//-(void) update_record_button ;

@end



@interface ConsoleButton : UIButton
@end

@interface LogsButton : ConsoleButton
@end