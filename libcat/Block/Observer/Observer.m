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

	NSArray* pair = (NSArray*)context;
	NSString* targetClassName = NSStringFromClass([pair objectAtFirst]);
	id blockObj = [pair objectAtSecond];
//	log_info(@"observeValueForKeyPath %@ %@ %@ %@ %@", keyPath, object, change, targetClassName, blockObj);
	NSKeyValueChange kind = [[change objectForKey:@"kind"] intValue];
	if (NSKeyValueChangeSetting == kind) {
		if ([targetClassName isEqualToString:@"NSMutableDictionary"]) {
			DictionaryChangedBlock block = blockObj;
			id obj = [change objectForKey:@"new"];
			if ([obj isKindOfClass:[ProxyMutableDictionary class]]) {
				obj = ((ProxyMutableDictionary*)obj).proxyDict;
			}
			id oldObj = [change objectForKey:@"old"];
			block(kind, obj, oldObj, nil);			
		} else {
			ObjectChangedBlock block = blockObj;
			id obj = [change objectForKey:@"new"];
			id oldObj = [change objectForKey:@"old"];
			block(kind, obj, oldObj);
		}
	} else {
		if ([targetClassName isEqualToString:@"NSMutableSet"]) {
			SetChangedBlock block = blockObj;
			switch (kind) {
				case NSKeyValueChangeRemoval: {
					NSArray* old = [change objectForKey:@"old"];
					for (id oldObj in old) {
						block(kind, nil, oldObj);
					}						
				}
					break;
				case NSKeyValueChangeInsertion: {
					NSArray* new = [change objectForKey:@"new"];
					for (id obj in new) {
						block(kind, obj, nil);
					}					
				}
					break;
				default:
					log_info(@"default nilindex");
					break;
			}			
		} else if ([targetClassName isEqualToString:@"NSMutableArray"]) {
			ArrayChangedBlock block = blockObj;
			NSIndexSet* indexes = [change objectForKey:@"indexes"];
			NSArray* old = [change objectForKey:@"old"];
			NSArray* new = [change objectForKey:@"new"];
			__block int idx = CERO;
			[indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
				switch (kind) {
					case NSKeyValueChangeRemoval: {
							id oldObj = [old objectAtIndex:idx];
							block(kind, nil, oldObj, index);
						}
						break;												
					case NSKeyValueChangeInsertion: {
							id obj = [new objectAtIndex:idx];
							block(kind, obj, nil, index);
						}
						break;
					case NSKeyValueChangeReplacement: {
							id oldObj = [old objectAtIndex:idx];
							id newObj = [new objectAtIndex:idx];
							block(kind, newObj, oldObj, index);
						}
						break;		
					default:
						break;
				}
				idx += UNO;
			}];		
		}
	}
}

@end