//
//  SlideDataSource.m
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 10/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "SlideDataSource.h"
#import "NSArrayExt.h"
#import "NSNumberExt.h"
#import "NSStringExt.h"
#import "Logger.h"
#import "Settings.h"
#import "NSDateExt.h"

void SLIDE_PAGE(NSString* slideTitle, NSArray* slideItems) {
	[[SlideDataSource sharedInstance] add_slide_page:slideTitle items:slideItems];
}

@implementation SlideDataSource
@synthesize slides;
@synthesize currentSlideIndex;

-(void) loadSlideData {
	
	//
//	SLIDE_PAGE(@"", [NSArray arrayWithObjects:@"5시 15분", nil]);	

	
	
	SLIDE_PAGE(@"libcat", [NSArray arrayWithObjects:SPACE, SPACE, PAIR([[NSDate date] year_monthName_day_SPACE], Enum(UITextAlignmentRight)), PAIR(@"ㄴㅇㄱ ", Enum(UITextAlignmentRight)), nil]);	
	SLIDE_PAGE(@"libcat", [NSArray arrayWithObjects:@"https://github.com/wookay/libcat", @"오픈 소스 프로젝트", @"아이폰 앱 개발을 동적으로 하자", @"허세 코딩", nil]);
	SLIDE_PAGE(@"사용 언어", [NSArray arrayWithObjects:[UIImage imageNamed:@"graphs_languages.png"], nil]);
	SLIDE_PAGE(@"구성", [NSArray arrayWithObjects:@"Ext", @"Block", @"Unit Test, Logger", @"Console", nil]);
	SLIDE_PAGE(@"Ext", [NSArray arrayWithObjects:@"Objective-C Library", @"Foundation Extensions & Macros", nil]);
	SLIDE_PAGE(@"Ext", [NSArray arrayWithObjects:@"NSStringExt", @"NSArrayExt", @"NSDictionaryExt", @"...", nil]);
	SLIDE_PAGE(@"Block", [NSArray arrayWithObjects:@"Block Extensions", @" for array, dictionary, number", @"UIBlock Extensions", nil]);
	SLIDE_PAGE(@"Unit Test", [NSArray arrayWithObjects:@"유닛 테스트 코드 작성", @"재사용 가능한 코드 유지", nil]);
	SLIDE_PAGE(@"Unit Test ( Example )", [NSArray arrayWithObjects:[UIImage imageNamed:@"unittest_example.png"], nil]);
	SLIDE_PAGE(@"Unit Test ( Run )", [NSArray arrayWithObjects:[UIImage imageNamed:@"unittest_run.png"], nil]);
	SLIDE_PAGE(@"Unit Test ( Report )", [NSArray arrayWithObjects:[UIImage imageNamed:@"unittest_report.png"], nil]);
	SLIDE_PAGE(@"Logger", [NSArray arrayWithObjects:@"log_info(@\"message\")", @"  RootViewController.m #032   message", @"log_info(@\"idx %d\", idx)", @"  RootViewController.m #033   idx 1    ", nil]);
	SLIDE_PAGE(@"Console", [NSArray arrayWithObjects:@"Command shell debugging environment", @"스크립팅", @"자동화", nil]);
	SLIDE_PAGE(@"ls", [NSArray arrayWithObjects:
@"[ ls ]          : list current object",      
@"[ ls -r ]     : list recursive      ", nil]);
	SLIDE_PAGE(@"cd", [NSArray arrayWithObjects:
@"	cd TARGET         : change target object",
@"	[ cd ]            : to topViewController",
@"	[ cd . ]          : to self             ",
@"	[ cd .. ]         : to superview        ",
@"	[ cd / ]          : to rootViewController",
@"	[ cd ~ ]          : to keyWindow",
@"	[ cd 0 ]          : at index as listed          ",
@"	[ cd 1 0 ]        : at section and index        ",
@"	[ cd -1 0 ]       : at index on toolbar",
@"	[ cd Title ]      : labeled as Title   ",
@"	[ cd view ]       : to property        ",
@"	[ cd UIButton ]   : to class           ",
@"	[ cd 0x6067490 ]  : at memory address   ",
					   SPACE,
					   nil]);
	SLIDE_PAGE(@"pwd", [NSArray arrayWithObjects:@"view & controller hierarchy", nil]);
	SLIDE_PAGE(@"p", [NSArray arrayWithObjects:@"properties",
@"[ text ]          : property getter",
@"[ text = hello ]  : property setter",
					  nil]);
	SLIDE_PAGE(@"t", [NSArray arrayWithObjects:@"터치 이벤트", nil]);
	SLIDE_PAGE(@"b", [NSArray arrayWithObjects:@"popViewController", nil]);
	SLIDE_PAGE(@"rm", [NSArray arrayWithObjects:@"removeFromSuperview", nil]);
	SLIDE_PAGE(@"f", [NSArray arrayWithObjects:@"flick target UI", nil]);
	SLIDE_PAGE(@"open", [NSArray arrayWithObjects:@"open Safari UI", nil]);
	SLIDE_PAGE(@"hit", [NSArray arrayWithObjects:@"hitTest UI on/off", nil]);
	SLIDE_PAGE(@"events", [NSArray arrayWithObjects:@"터치 이벤트 기록, 재생", @"USE_PRIVATE_API=1", nil]);
	SLIDE_PAGE(@"events", [NSArray arrayWithObjects:
@"[ events record ]      : record on/off (er)",
@"[ events play ]        : play events (ep)",
@"[ events cut N ]       : cut N events (ex)",
@"[ events clear ]       : clear events (ec)",
@"[ events replay NAME ] : replay events (ee)",
@"[ events save NAME ]   : save events (es)",
@"[ events load NAME ]   : load events (el)",
	SPACE, nil]);
	SLIDE_PAGE(@"피드백", [NSArray arrayWithObjects:@"구글 그룹 구독", @"http://groups.google.com/group/interactivelibcat", nil]);
	SLIDE_PAGE(@"질문?", [NSArray arrayWithObjects:@"", nil]);
	SLIDE_PAGE(@"FIN", [NSArray arrayWithObjects:SPACE, PAIR(@"감사합니다", Enum(UITextAlignmentCenter)), nil]);

}

-(void) add_slide_page:(NSString*)slideTitle items:(NSArray*)items {
	[slides addObject:PAIR(slideTitle, items)];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[slides objectAtIndex:currentSlideIndex] objectAtSecond] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {   // fixed font style. use custom view (UILabel) if you want something different
	return [[slides objectAtIndex:currentSlideIndex] objectAtFirst];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.imageView.image = nil;
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.text = nil;
	
	// Configure the cell.
	id item = [[[slides objectAtIndex:currentSlideIndex] objectAtSecond] objectAtIndex:indexPath.row];
	NSString* itemText;	
	if ([item isKindOfClass:[UIImage class]]) {
		cell.imageView.image = item;
	} else {
		if ([item isKindOfClass:[NSArray class]]) {
			itemText = [item objectAtFirst];
			cell.textLabel.textAlignment = [[item objectAtSecond] intValue];
		} else {
			itemText = item;
		}
		cell.textLabel.adjustsFontSizeToFitWidth = true;
		cell.textLabel.text = itemText;
		cell.textLabel.numberOfLines = [itemText split:LF].count;
		cell.textLabel.font = [UIFont fontWithName:@"HeummBombi152" size:40];
		cell.textLabel.textColor = COLOR_RGBA_FF(0x06, 0x10, 0x2b, 1);
	}
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


+ (SlideDataSource*) sharedInstance {
	static SlideDataSource*	manager = nil;
	if (!manager) {
		manager = [SlideDataSource new];
	}
	return manager;
}

- (id) init {
	self = [super init];
	if (self) {
		self.currentSlideIndex = 0;
		self.slides = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc {
	[slides release];
	[super dealloc];
}


@end
