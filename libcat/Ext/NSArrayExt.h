//
//  NSArrayExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 12/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _array0() [NSArray array]
#define _array1(obj1) [NSArray arrayWithObjects:obj1, nil]
#define _array2(obj1, obj2) [NSArray arrayWithObjects:obj1, obj2, nil]
#define _array3(obj1, obj2, obj3) [NSArray arrayWithObjects:obj1, obj2, obj3, nil]
#define _array4(obj1, obj2, obj3, obj4) [NSArray arrayWithObjects:obj1, obj2, obj3, obj4, nil]

#define COMPARE_DOS(uno, dos)	(uno == dos ? NSOrderedSame : (uno>dos ? NSOrderedAscending : NSOrderedDescending))

NSArray* PAIR(id uno, id dos) ;
NSArray* TRIO(id uno, id dos, id tres) ;	
NSArray* CUAD(id uno, id dos, id tres, id cuatro) ;

@interface NSArray (Ext)
-(BOOL) isEmpty ;
-(NSArray*) append:(NSArray*)ary ;
-(NSArray*) rshift:(int)cnt ;
-(NSArray*) arrayAtFirst ;
-(NSArray*) arrayAtSecond ;
-(NSDictionary*) dictionaryAtFirst ;
-(NSDictionary*) dictionaryAtSecond ;	
-(id) objectAtIndexPath:(NSIndexPath*)indexPath ;
-(NSArray*) arrayAtIndex:(int)idx ;
-(id) objectAtFirst ;
-(id) objectAtSecond ;
-(id) objectAtThird ;
-(id) objectAtFourth ;
-(id) objectAtLast ;
-(id) at:(int)idx ;
-(id) first ;
-(id) last ;
-(int) index:(id)obj ;
-(BOOL) hasObject:(id)obj ;
-(NSArray*) slice:(int)loc :(int)length_ ;
-(NSArray*) slice:(int)loc backward:(int)backward ;
-(NSString*) join:(NSString*)separator ;
-(NSString*) join ;
-(NSArray*) reverse ;
-(NSArray*) transpose ;
-(NSArray*) diagonal:(id)padding ;
-(NSArray*) undiagonal ;
-(NSArray*) withoutObject:(id)obj ;
-(NSArray*) sort ;
-(NSArray*) sortByFirstObject ;
-(NSArray*) sortByFunction:(NSInteger (*)(id, id, void *))comparator ;
@end
