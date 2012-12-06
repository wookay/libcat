//
//  Observer.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "Observer.h"
#import "Logger.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Numero.h"
#import "ProxyMutableDictionary.h"

NSString* keyValueChangeToString(NSKeyValueChange kind) {
	return [_w(@"nil NSKeyValueChangeSetting NSKeyValueChangeInsertion NSKeyValueChangeRemoval NSKeyValueChangeReplacement")
			objectAtIndex:kind];
}



@implementation Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (nil == context) {
		return;
	}
    id blockObj = (id) context;
    ObjectChangedBlock block = blockObj;
    block(keyPath, object, change);
}

@end