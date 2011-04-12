//
//  ConsoleViewController.m
//  TestApp
//
//  Created by WooKyoung Noh on 18/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "ConsoleViewController.h"
#import "NSStringExt.h"
#import "PropertyManipulator.h"
#import "ConsoleManager.h"
#import "PropertyRootViewController.h"
#import "HitTestWindow.h"
#import "NSObjectExt.h"
#import "iPadExt.h"

#if USE_PRIVATE_API
#import "UIEventExt.h"
#endif

typedef enum {
	kConsoleSectionCommands,
#if USE_PRIVATE_API
	kConsoleSectionEvents,
#endif
	kConsoleSectionInfo,
	kConsoleSectionCount,
} kConsoleSection;

typedef enum {
	kConsoleSectionInfoRowConsoleServer,
	kConsoleSectionInfoRowLogsButton,
	kConsoleSectionInfoRowCount,
} kConsoleSectionInfoRow;

typedef enum {
	kConsoleSectionCommandsRowSelectUIObject,
	kConsoleSectionCommandsRowPropertyManipulator,
	kConsoleSectionCommandsRowCount,
} kConsoleSectionCommandsRow;

typedef enum {
	kConsoleSectionEventsRowRecord,
	kConsoleSectionEventsRowStopRecord,
	kConsoleSectionEventsRowPlay,
	kConsoleSectionEventsRowClear,
	kConsoleSectionEventsRowCount,
} kConsoleSectionEventsRow;



@implementation ConsoleViewController

#pragma mark -
#pragma mark View lifecycle

-(IBAction) touchedDone:(id)sender {
	[PROPERTYMAN hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.backgroundColor = [UIColor colorWithRed:0.87 green:0.89 blue:0.60 alpha:0.9];
	
	self.title = NSLocalizedString(@"Console", nil);
	if (nil == self.navigationController.parentViewController) {
		UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					target:self
																					action:@selector(touchedDone:)];						
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];		
	}
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:kConsoleSectionCommandsRowPropertyManipulator inSection:kConsoleSectionCommands];
	UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
	if (nil != cell) {
		NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
		[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
	}
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return kConsoleSectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case kConsoleSectionInfo:
			return kConsoleSectionInfoRowCount;
			break;
		case kConsoleSectionCommands:
			return kConsoleSectionCommandsRowCount;
			break;
#if USE_PRIVATE_API
		case kConsoleSectionEvents:
			return kConsoleSectionEventsRowCount;
			break;			
#endif
		default:
			break;
	}
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch (section) {
		case kConsoleSectionInfo:
			return NSLocalizedString(@"Run script/console.rb", nil);
			break;
	}	
	return nil;	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	switch (section) {
		case kConsoleSectionInfo:
			return 30;
			break;
	}	
	return 0;	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case kConsoleSectionCommands:
			if (kConsoleSectionCommandsRowPropertyManipulator == indexPath.row) {
				return 45;
			}
			break;
	}	
	return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {   // fixed font style. use custom view (UILabel) if you want something different
	switch (section) {
		case kConsoleSectionInfo:
			return NSLocalizedString(@"Info", nil);
			break;
		case kConsoleSectionCommands:
			return NSLocalizedString(@"Commands", nil);
			break;
#if USE_PRIVATE_API
		case kConsoleSectionEvents:
			return NSLocalizedString(@"Touch Events", nil);
			break;
#endif
		default:
			break;
	}
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = SWF(@"Cell %d", indexPath.section);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	switch (indexPath.section) {	
		case kConsoleSectionInfo:
			style = UITableViewCellStyleValue1;
			break;
		case kConsoleSectionCommands:
			style = UITableViewCellStyleSubtitle;
			break;
#if USE_PRIVATE_API
		case kConsoleSectionEvents:
			style = UITableViewCellStyleValue1;
			break;
#endif
	}
			
	if (cell == nil) {
		cell = [[[ConsoleTableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
	}	
			
	cell.userInteractionEnabled = true;
	cell.accessoryType = UITableViewCellAccessoryNone;

    // Configure the cell...
	switch (indexPath.section) {
		case kConsoleSectionInfo:
			switch (indexPath.row) {
				case kConsoleSectionInfoRowConsoleServer:
					cell.textLabel.text = NSLocalizedString(@"Console Server", nil);
					cell.detailTextLabel.text = SWF(@"%@:%d", [CONSOLEMAN get_local_ip_address], CONSOLEMAN.server_port);
					break;
				case kConsoleSectionInfoRowLogsButton: {
						cell.textLabel.text = NSLocalizedString(@"Logs Button", nil);
						UIWindow* window = [UIApplication sharedApplication].keyWindow;
						for (UIButton* button in window.subviews) {
							if ([button isKindOfClass:[LogsButton class]]) {
								if (button
									.hidden) {
								} else {
									cell.accessoryType = UITableViewCellAccessoryCheckmark;
								}
							}
						}
					}
					break;					
				default:
					break;
			}
			break;
			
		case kConsoleSectionCommands:
			switch (indexPath.row) {
				case kConsoleSectionCommandsRowPropertyManipulator: {
						cell.textLabel.text = NSLocalizedString(@"Property Manipulator", nil);
						id targetObject = [CONSOLEMAN currentTargetObjectOrTopViewController];
						cell.detailTextLabel.text = SWF(@"%@", targetObject);
						cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					}
					break;			
				case kConsoleSectionCommandsRowSelectUIObject:
					cell.textLabel.text = NSLocalizedString(@"Select UI Object", nil);
					break;										
				default:
					break;
			}			
			break;
			
#if USE_PRIVATE_API
		case kConsoleSectionEvents:
			cell.contentView.alpha = 1;
			cell.detailTextLabel.text = nil;
			
#define DISABLED_VIEW_ALPHA 0.6
			switch (indexPath.row) {
				case kConsoleSectionEventsRowStopRecord:
					cell.textLabel.text = NSLocalizedString(@"Stop Record Touch Events", nil);
					if (! EVENTRECORDER.recorded) {
						cell.userInteractionEnabled = false;
						cell.contentView.alpha = DISABLED_VIEW_ALPHA;
					}					
					break;
					
				case kConsoleSectionEventsRowRecord: {
					cell.textLabel.text = NSLocalizedString(@"Record Touch Events", nil);
					if (EVENTRECORDER.recorded) {
						cell.detailTextLabel.text = NSLocalizedString(@"Recording...", nil);
					} else {
						cell.detailTextLabel.text = nil;
					}
					if (EVENTRECORDER.recorded) {
						cell.userInteractionEnabled = false;
						cell.contentView.alpha = DISABLED_VIEW_ALPHA;
					}
				}
				break;
					
				case kConsoleSectionEventsRowPlay: {
						cell.textLabel.text = NSLocalizedString(@"Play Touch Events", nil);
						cell.detailTextLabel.text = SWF(@"%d", EVENTRECORDER.userEvents.count);
						if (EVENTRECORDER.recorded || 0==EVENTRECORDER.userEvents.count) {
							cell.userInteractionEnabled = false;
							cell.contentView.alpha = DISABLED_VIEW_ALPHA;
						}
					}
					break;					
					
				case kConsoleSectionEventsRowClear: {
						cell.textLabel.text = NSLocalizedString(@"Clear Touch Events", nil);
						if (EVENTRECORDER.recorded || 0 == EVENTRECORDER.userEvents.count) {
							cell.userInteractionEnabled = false;
							cell.contentView.alpha = DISABLED_VIEW_ALPHA;
						}
					}
					break;

			}
			break;
#endif

		default:
			break;
	}
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:true];

	switch (indexPath.section) {
		case kConsoleSectionInfo:
			switch (indexPath.row) {
				case kConsoleSectionInfoRowLogsButton: {
						[CONSOLEMAN toggle_logs_button];
						[self.tableView reloadData];
					}
					break;					
			}
			break;
			
		case kConsoleSectionCommands:
			switch (indexPath.row) {					
				case kConsoleSectionCommandsRowPropertyManipulator: {
						id targetObject = [CONSOLEMAN currentTargetObjectOrTopViewController];
						[PROPERTYMAN manipulate:targetObject];
					}
					break;
					
#define TIMEINTERVAL_ZOOMOUT 0.3
				case kConsoleSectionCommandsRowSelectUIObject:
					[UIView beginAnimations:nil context:nil];
					[UIView setAnimationDuration:TIMEINTERVAL_ZOOMOUT];
					self.navigationController.view.frame = CGRectMake(SCREEN_WIDTH, 0, 0, 0);
					[UIView commitAnimations];
					[[HitTestWindow sharedWindow] performSelector:@selector(hitTestOnce) afterDelay:TIMEINTERVAL_ZOOMOUT];
					break;

				default:
					break;
			}			
			break;
			
#if USE_PRIVATE_API
		case kConsoleSectionEvents:
			switch (indexPath.row) {
				case kConsoleSectionEventsRowStopRecord:
					[self performSelector:@selector(event_record_toggler) afterDelay:0];
					break;
					
				case kConsoleSectionEventsRowRecord:
					if (EVENTRECORDER.recorded) {
					} else {
						[UIView beginAnimations:nil context:nil];
						[UIView setAnimationDuration:TIMEINTERVAL_ZOOMOUT];
						self.navigationController.view.frame = CGRectMake(SCREEN_WIDTH, 0, 0, 0);
						[UIView commitAnimations];
						[self performSelector:@selector(event_record_toggler) afterDelay:TIMEINTERVAL_ZOOMOUT];
					}
					break;
					
				case kConsoleSectionEventsRowPlay:
					[UIView beginAnimations:nil context:nil];
					[UIView setAnimationDuration:TIMEINTERVAL_ZOOMOUT];
					self.navigationController.view.frame = CGRectMake(SCREEN_WIDTH, 0, 0, 0);
					[UIView commitAnimations];
					[EVENTRECORDER performSelector:@selector(playUserEvents) afterDelay:TIMEINTERVAL_ZOOMOUT];
					break;					
					
				case kConsoleSectionEventsRowClear:
					[EVENTRECORDER clearUserEvents];
					[self refreshEventsSection];
					break;
			}
			break;
			
#endif
			
		default:
			break;
	}
}

-(void) refreshEventsSection {
#if USE_PRIVATE_API
	NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:kConsoleSectionEvents];
	[self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
#endif
}

-(void) event_record_toggler {
#if USE_PRIVATE_API
	[EVENTRECORDER toggleRecordUserEvents];
	[self refreshEventsSection];
#endif
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end







@implementation ConsoleTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {	
    [super setSelected:selected animated:animated];
}
- (void)dealloc {
    [super dealloc];
}
@end