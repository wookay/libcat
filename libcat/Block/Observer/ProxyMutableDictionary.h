//
//  ProxyMutableDictionary.h
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProxyMutableDictionary : NSObject {
	NSString* proxyKeyPath;
	NSMutableDictionary* proxyDict;
}
@property (nonatomic, retain)	NSString* proxyKeyPath;
@property (nonatomic, retain) 	NSMutableDictionary* proxyDict;
	
-(id) objectForKey:(id)aKey ;
-(void) setObject:(id)anObject forKey:(id)aKey ;
-(void) setDictionary:(NSDictionary *)otherDictionary ;
-(void) addEntriesFromDictionary:(NSDictionary *)otherDictionary ;
-(void) removeAllObjects ;
-(void) removeObjectsForKeys:(NSArray*)keyArray ;
-(void) removeObjectForKey:(id)aKey ;

@end

