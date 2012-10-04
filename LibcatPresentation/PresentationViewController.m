//
//  PresentationViewController.m
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 09/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "PresentationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Logger.h"
#import "SlideDataSource.h"
#import "NSArrayExt.h"
#import "Settings.h"
#import "GotoView.h"
#import "NSTextExt.h"

@implementation PresentationViewController
@synthesize tableView;
@synthesize pageControl;

-(IBAction) touchedGotoButton:(id)sender {
	[GotoView showGotoAlertView:NSLocalizedString(@"Page", nil) currentPage:pageControl.currentPage numberOfPages:pageControl.numberOfPages delegate:self];
}

-(void) changedSlidePage:(int)page {
	if (pageControl.currentPage != page) {
		pageControl.currentPage = page;
		[self changeSlidePage:page];
	}
}

-(void) changeSlidePage:(int)page {
	UITableViewRowAnimation animation;
	if ([SlideDataSource sharedInstance].currentSlideIndex > page) {
		animation = UITableViewRowAnimationRight;
	} else {
		animation = UITableViewRowAnimationLeft;
	}
	[SlideDataSource sharedInstance].currentSlideIndex = page;	
	NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:0];
	[tableView reloadSections:indexSet withRowAnimation:animation];	
	//log_info(@"c %d", page);
}

-(IBAction) touchedPageControl:(id)sender {
	[self changeSlidePage:pageControl.currentPage];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	tableView.dataSource = [SlideDataSource sharedInstance];
	tableView.delegate = self;
	tableView.backgroundColor = COLOR_RGBA_FF(0xdb, 0xcf, 0x48, 1);
	tableView.separatorColor = COLOR_RGBA_FF(0x10, 0x10, 0x10, 0.1);
	
	[[SlideDataSource sharedInstance] loadSlideData];

	int cnt = [SlideDataSource sharedInstance].slides.count;
	pageControl.numberOfPages = cnt;
	pageControl.backgroundColor = COLOR_RGBA_FF(0x31, 0xa1, 0x31, 1);
	pageControl.layer.cornerRadius = 5;
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return NO;//(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#define SLIDE_TITLE_RECT CGRectMake(0,0,480,90)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return SLIDE_TITLE_RECT.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([SlideDataSource sharedInstance].slides.count > pageControl.currentPage) {
		NSArray* slidePair = [[SlideDataSource sharedInstance].slides objectAtIndex:pageControl.currentPage];
		NSArray* items = [slidePair objectAtSecond];
		if (items.count > indexPath.row) {
			id item = [items objectAtIndex:indexPath.row];
			if ([item isKindOfClass:[UIImage class]]) {
				return 150;
			}
		}
	}
	return 50;
}

- (UIView*) tableView:(UITableView *)tableView_ viewForHeaderInSection:(NSInteger)section {
    NSString* titleForHeader = [self.tableView.dataSource tableView:tableView_ titleForHeaderInSection:section];
	CGRect rect = SLIDE_TITLE_RECT;
	UILabel* label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = COLOR_RGBA_FF(0x06, 0x10, 0x2b, 1);
	label.shadowColor = COLOR_RGBA_FF(0x95, 0x95, 0x95, 1);
	label.text = titleForHeader;
    self.title = titleForHeader;
	return label;
}

-(IBAction) touchedFullScreenImage:(id)sender {
    [sender removeTarget:self action:@selector(touchedFullScreenImage:) forControlEvents:UIControlEventTouchUpInside];
    [sender removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [[[[SlideDataSource sharedInstance].slides objectAtIndex:pageControl.currentPage] objectAtSecond] objectAtIndex:indexPath.row];
	if ([item isKindOfClass:[UIImage class]]) {
        UIImage* image = item;
         UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.view.frame;
        [button addTarget:self action:@selector(touchedFullScreenImage:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:button];
    }
	[tableView_ deselectRowAtIndexPath:indexPath animated:true];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)dealloc {
	[tableView release];
	[pageControl release];
    [super dealloc];
}


@end
