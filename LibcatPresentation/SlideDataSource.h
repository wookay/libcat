//
//  SlideDataSource.h
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 10/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SlideDataSource : NSObject <UITableViewDataSource> {
	NSMutableArray* slides;
	int currentSlideIndex;
}
@property(nonatomic,retain) NSMutableArray* slides;
@property(nonatomic) int currentSlideIndex;
+ (SlideDataSource*) sharedInstance ;
-(void) loadSlideData ;
-(void) add_slide_page:(NSString*)slideTitle items:(NSArray*)items ;
@end
