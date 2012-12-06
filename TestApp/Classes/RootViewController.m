//
//  RootViewController.m
//  TestApp
//
//  Created by wookyoung noh on 04/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "RootViewController.h"
#import "UnitTest.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "Logger.h"
#import "Async.h"
#import "NSNumberExt.h"
#import "ConsoleManager.h"
#import "UIControlViewController.h"
#import "ScrollViewController.h"

enum { kSectionSampleControllers, kSectionUnitTest, kSectionMax };
	enum { kSectionSampleControllersRowScrollView, kSectionSampleControllersRowCounter, kSectionSampleControllersRowCount };
	enum { kRowTests, kRowAssertions, kRowFailures, kRowErrors, kRowMaxUnitTest };

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];	
	
	self.title = NSLocalizedString(@"libcat", nil);
	self.tableView.sectionHeaderHeight = 50;
}

-(void) viewWillAppear:(BOOL)animated {
	self.navigationController.toolbarHidden = true;		
	[super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}
	
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case kSectionUnitTest:
			return kRowMaxUnitTest;
			break;
		case kSectionSampleControllers:
			return kSectionSampleControllersRowCount;
		default:
			break;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = SWF(@"Cell %d", indexPath.section);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		int style = (kSectionUnitTest == indexPath.section) ? UITableViewCellStyleValue1 : UITableViewCellStyleDefault;
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
    }
    
	switch (indexPath.section) {
		case kSectionUnitTest:
			switch (indexPath.row) {
				case kRowTests:
					cell.textLabel.text = NSLocalizedString(@"Tests", nil);
					cell.detailTextLabel.text = int_to_string(UNITTESTMAN.tests);
					break;
				case kRowAssertions:
					cell.textLabel.text = NSLocalizedString(@"Assertions", nil);
					cell.detailTextLabel.text = int_to_string(UNITTESTMAN.assertions);
					if (0 == UNITTESTMAN.failures && UNITTESTMAN.assertions > 0) {
						cell.textLabel.backgroundColor = [UIColor clearColor];
						cell.detailTextLabel.backgroundColor = [UIColor clearColor];
						cell.contentView.backgroundColor = [UIColor greenColor];
					}
					break;
				case kRowFailures:
					cell.textLabel.text = NSLocalizedString(@"Failures", nil);
					cell.detailTextLabel.text = int_to_string(UNITTESTMAN.failures);
					if (UNITTESTMAN.failures > 0) {
						cell.textLabel.backgroundColor = [UIColor clearColor];
						cell.detailTextLabel.backgroundColor = [UIColor clearColor];
						cell.contentView.backgroundColor = [UIColor redColor];
					}
					break;
				case kRowErrors:
					cell.textLabel.text = NSLocalizedString(@"Errors", nil);
					cell.detailTextLabel.text = int_to_string(UNITTESTMAN.errors);
					break;
				default:
					break;
			}
			break;

		case kSectionSampleControllers:
			cell.textLabel.adjustsFontSizeToFitWidth = true;
			cell.detailTextLabel.adjustsFontSizeToFitWidth = true;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			switch (indexPath.row) {
				case kSectionSampleControllersRowScrollView:
					cell.textLabel.text = NSLocalizedString(@"Scroll View", nil);
					break;
				case kSectionSampleControllersRowCounter:
					cell.textLabel.text = NSLocalizedString(@"Counter", nil);
					break;
			}
			break;
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 41;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case kSectionUnitTest:
			return NSLocalizedString(@"Unit Test", nil);
			break;
		case kSectionSampleControllers:
			return NSLocalizedString(@"Sample Controllers", nil);
			break;
	}
	return nil;
}
	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch (section) {
		case kSectionUnitTest:
			return SWF(NSLocalizedString(@"Finished in %.2g seconds.", nil), UNITTESTMAN.elapsed);
			break;
		default:
			break;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	
	switch (indexPath.section) {
		case kSectionSampleControllers:
			switch (indexPath.row) {
				case kSectionSampleControllersRowScrollView: {
						ScrollViewController* vc = [[ScrollViewController alloc] initWithNibName:@"ScrollViewController" bundle:nil];
						[self.navigationController pushViewController:vc animated:true];
						vc.title = cell.textLabel.text;
						float red = get_random(FF)/FF;
						float green = get_random(FF)/FF;
						float blue = get_random(FF)/FF;
						vc.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
						[vc release];			
					}					
					break;
				case kSectionSampleControllersRowCounter: {
						UIControlViewController* vc = [[UIControlViewController alloc] initWithNibName:@"UIControlViewController" bundle:nil];
						[self.navigationController pushViewController:vc animated:true];
						vc.title = cell.textLabel.text;
						[vc release];						
					}					
					break;
			}
			break;
	}
	
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)dealloc {
    [super dealloc];
}

@end