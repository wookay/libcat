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

enum { kSectionUnitTest, kSectionConsole, kSectionMax };
	enum { kRowTests, kRowAssertions, kRowFailures, kRowErrors, kRowMaxUnitTest };
	enum { kRowConsoleInteractiveShell, kRowConsoleLogWatcher, kRowMaxConsole };

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case kSectionUnitTest:
			return kRowMaxUnitTest;
			break;
		case kSectionConsole:
			return kRowMaxConsole;
			break;
		default:
			break;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		int style = (kSectionUnitTest == indexPath.section) ? UITableViewCellStyleValue1 : UITableViewCellStyleValue2;
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
    }
    
	switch (indexPath.section) {
		case kSectionUnitTest:
			switch (indexPath.row) {
				case kRowTests:
					cell.textLabel.text = NSLocalizedString(@"Tests", nil);
					cell.detailTextLabel.text = int_to_string(TESTMAN.tests);
					break;
				case kRowAssertions:
					cell.textLabel.text = NSLocalizedString(@"Assertions", nil);
					cell.detailTextLabel.text = int_to_string(TESTMAN.assertions);
					if (0 == TESTMAN.failures && TESTMAN.assertions > 0) {
						cell.textLabel.backgroundColor = [UIColor clearColor];
						cell.detailTextLabel.backgroundColor = [UIColor clearColor];
						cell.contentView.backgroundColor = [UIColor greenColor];
					}
					break;
				case kRowFailures:
					cell.textLabel.text = NSLocalizedString(@"Failures", nil);
					cell.detailTextLabel.text = int_to_string(TESTMAN.failures);
					if (TESTMAN.failures > 0) {
						cell.textLabel.backgroundColor = [UIColor clearColor];
						cell.detailTextLabel.backgroundColor = [UIColor clearColor];
						cell.contentView.backgroundColor = [UIColor redColor];
					}
					break;
				case kRowErrors:
					cell.textLabel.text = NSLocalizedString(@"Errors", nil);
					cell.detailTextLabel.text = int_to_string(TESTMAN.errors);
					break;
				default:
					break;
			}
			break;

		case kSectionConsole:
			cell.textLabel.adjustsFontSizeToFitWidth = true;
			cell.detailTextLabel.adjustsFontSizeToFitWidth = true;
			switch (indexPath.row) {
				case kRowConsoleInteractiveShell:
					cell.textLabel.text = NSLocalizedString(@"Interactive Shell", nil);
					cell.detailTextLabel.text = @"libcat/Console/script/console.rb";
					break;
				case kRowConsoleLogWatcher:
					cell.textLabel.text = NSLocalizedString(@"Log Watcher", nil);
					cell.detailTextLabel.text = @"libcat/Console/script/log_watcher.rb";
					break;
			}
			break;
	}

	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case kSectionUnitTest:
			return NSLocalizedString(@"Unit Test", nil);
			break;
		case kSectionConsole:
			return NSLocalizedString(@"Console", nil);
			break;
	}
	return nil;
}
	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch (section) {
		case kSectionUnitTest:
			return SWF(NSLocalizedString(@"Finished in %.3g seconds.", nil), TESTMAN.elapsed);
			break;
		default:
			break;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	log_info(@"didSelectRowAtIndexPath %@", indexPath);
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	
	switch (indexPath.section) {
		case kSectionUnitTest: {
				UIViewController* vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
				[self.navigationController pushViewController:vc animated:true];
				vc.title = cell.textLabel.text;
#define FF 255.0
				float red = get_random(FF)/FF;
				float green = get_random(FF)/FF;
				float blue = get_random(FF)/FF;
				vc.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
				[vc release];			
			}
			break;
			
		case kSectionConsole: {
				UIControlViewController* vc = [[UIControlViewController alloc] initWithNibName:@"UIControlViewController" bundle:nil];
				[self.navigationController pushViewController:vc animated:true];
				vc.title = cell.textLabel.text;
				[vc release];						
			}
			break;
			
		default:
			break;
	}

    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)dealloc {
    [super dealloc];
}

@end