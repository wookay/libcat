//
//  TypeInfoTable.h
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TypeInfoTable : NSObject {
	NSDictionary* typedefTable;
	NSDictionary* propertyTable;
}
@property (nonatomic, retain)	NSDictionary* typedefTable;
@property (nonatomic, retain)	NSDictionary* propertyTable;

-(NSNumber*) enumStringToNumber:(NSString*)str ;
-(NSString*) findEnumDefinitionByEnumString:(NSString*)str ;
-(id) objectStringToObject:(NSString*)str failed:(BOOL*)failed ;

-(NSString*) objectDescriptionForProperty:(id)obj targetClass:(NSString*)targetClass propertyName:(NSString*)propertyName ;
-(NSString*) objectDescription:(id)obj targetClass:(NSString*)targetClass propertyName:(NSString*)propertyName ;
-(NSString*) objectDescriptionInternal:(id)obj targetClass:(NSString*)targetClass propertyName:(NSString*)propertyName removeLF:(BOOL)removeLF ;

//GEN
-(void) load_property_table ;
-(void) load_typedef_table ;

@end

