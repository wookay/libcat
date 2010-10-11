//
//  TestObserver.h
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestObserver : NSObject {
	NSString* name;
	NSMutableArray* products;
	NSMutableSet* days;
	NSMutableDictionary* book;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableArray* products;
@property (nonatomic, retain) NSMutableSet* days;
@property (nonatomic, retain) NSMutableDictionary* book;

@end
