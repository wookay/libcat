//
//  ConsoleManager.h
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CONSOLEMAN	[ConsoleManager sharedManager]

@interface ConsoleManager : NSObject {
	id currentTargetObject;
}
@property (nonatomic, retain)	id currentTargetObject;

-(id) input:(NSString*)command arg:(id)arg ;
-(id) input:(NSString*)input ;
+ (ConsoleManager*) sharedManager ;

-(void) start_servers ;
-(void) stop_servers ;	
-(UINavigationController*) navigationController ;
-(NSString*) getterChain:(id)command arg:(id)arg ;
-(id) arg_to_proper_object:(id)arg ;
-(NSString*) setterChain:(id)command arg:(id)arg ;
-(id) currentTargetObjectOrTopViewController ;
@end
