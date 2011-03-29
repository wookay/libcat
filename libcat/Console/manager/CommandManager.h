//
//  CommandManager.h
//  TestApp
//
//  Created by wookyoung noh on 07/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMMANDMAN	[CommandManager sharedManager]
typedef id (^CommandBlock)(id currentObject, id arg) ;
typedef id (^ActionBlock)() ;


NSString* surrounded_array_prefix_index(NSArray* array) ;
enum { LS_OBJECT, LS_VIEWCONTROLLERS, LS_TABLEVIEW, LS_SECTIONS, LS_VIEW, LS_INDENTED_VIEW, LS_VIEW_SUBVIEWS, LS_TABBAR, LS_NAVIGATIONITEM, LS_NAVIGATIONCONTROLLER_TOOLBAR, LS_NAVIGATIONCONTROLLER_TOOLBAR_ITEMS, LS_TOOLBAR, LS_TOOLBAR_ITEMS, LS_CLASS_METHODS,  LS_LAYER, LS_LAYER_SUBLAYERS, LS_INDENTED_LAYER, LS_WINDOWS, LS_ARRAY, };


@protocol HitTestDelegate
-(void) touchedHitTestView:(UIView*)view ;
@end


@interface CommandManager : NSObject <HitTestDelegate> {
	NSMutableDictionary* commandsMap;
}
@property (nonatomic, retain) NSMutableDictionary* commandsMap;

-(NSDictionary*) load_system_commands ;
-(NSArray*) findTargetObject:(id)currentObject arg:(id)arg ;
-(id) findTargetObjectOrCurrentObject:(id)currentObject arg:(id)arg ;
+ (CommandManager*) sharedManager ;
-(id) commandNotFound ;
-(NSArray*) array_ls:(id)currentObject arg:(id)arg ;
-(NSArray*) get_targetStringAndBlocks:(id)currentObject ;
-(id) get_targetObjectActionBlock:(id)targetObject ;
@end


