//
//  NewObjectManager.h
//  TestApp
//
//  Created by wookyoung noh on 11/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NEWOBJECTMAN	[NewObjectManager sharedManager]

#define NEW_OBJECT_PREFIX	DOLLAR
#define NEW_ONE_NAME		@"$0"

@interface NewObjectManager : NSObject {
	NSMutableDictionary* newObjects;
	id newOne;
	id oldOne;
}
@property (nonatomic, retain) NSMutableDictionary* newObjects;
@property (nonatomic, retain) id newOne;
@property (nonatomic, assign) id oldOne;

+ (NewObjectManager*) sharedManager ;
-(void) setNewObject:(id)obj forKey:(NSString*)key ;
-(id) newObjectForKey:(NSString*)key ;	
-(void) updateNewOne:(id)obj ;
@end
