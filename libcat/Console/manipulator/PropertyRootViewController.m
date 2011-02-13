//
//  PropertyRootViewController.m
//  TestApp
//
//  Created by WooKyoung Noh on 12/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "PropertyRootViewController.h"
#import "Logger.h"
#import "PropertyManipulator.h"
#import "NSObjectExt.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "NSObjectSetValueFromString.h"
#import "NSObjectValueToString.h"
#import "EditPropertyViewController.h"

#define ATTRIBUTE_READONLY	@"R"
#define	ATTRIBUTE_OBJECT	@"&"

@implementation PropertyRootViewController
@synthesize targetObject;

-(void) manipulateTargetObject:(id)targetObject_ {
	self.targetObject = targetObject_;
	self.title = SWF(@"%@", targetObject_);
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark View lifecycle

-(IBAction) touchedDone:(id)sender {
	[PROPERTYMAN hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [targetObject class_properties_count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[[PropertyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}

	NSArray* trio = [[targetObject class_properties] objectAtIndex:indexPath.row];
	NSString* propertyName = [trio objectAtFirst];
	cell.textLabel.text = propertyName;
	cell.textLabel.adjustsFontSizeToFitWidth = true;
	id obj = [trio objectAtSecond];
	NSString* objectDetail = [PROPERTYMAN.typeInfoTable objectDescription:obj targetClass:NSStringFromClass([targetObject class]) propertyName:propertyName];
	cell.detailTextLabel.text = objectDetail;
	if ([@"false" isEqualToString:objectDetail]) {
		cell.detailTextLabel.textColor = [UIColor grayColor];
	} else {
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
	}
	NSArray* attributes = [trio objectAtThird];
	
	@try {
		cell.accessoryType = UITableViewCellAccessoryNone;
		if ([attributes containsObject:ATTRIBUTE_READONLY] && ![attributes containsObject:ATTRIBUTE_OBJECT]) {
		} else {
			if ([attributes containsObject:ATTRIBUTE_OBJECT]) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else {
				NSString* setter = SWF(@"set%@FromString:", [propertyName capitalizedString]);
				SEL sel = NSSelectorFromString(setter);
				if ([targetObject respondsToSelector:sel]) {
					cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;					
				}
			}
		}		
	} @catch (NSException* exception) {
	}
	
    return cell;
}

-(void) updateProperty:(NSString*)propertyName value:(NSString*)value {
	NSString* setter = SWF(@"set%@FromString:", [propertyName capitalizedString]);
	SEL sel = NSSelectorFromString(setter);
	if ([targetObject respondsToSelector:sel]) {
		[targetObject performSelector:sel withObject:value];
		[self.tableView reloadData];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSArray* trio = [[targetObject class_properties] objectAtIndex:indexPath.row];
	NSString* propertyName = [trio objectAtFirst];
	id obj = [trio objectAtSecond];
//	NSArray* attributes = [trio objectAtThird];
	
//	if ([attributes containsObject:ATTRIBUTE_READONLY] && ![attributes containsObject:ATTRIBUTE_OBJECT]) {
//	} else {
//		if ([attributes containsObject:ATTRIBUTE_OBJECT]) {
//		} else {
//			NSString* setter = SWF(@"set%@FromString:", [propertyName capitalizedString]);
//			SEL sel = NSSelectorFromString(setter);
//			if ([targetObject respondsToSelector:sel]) {
				EditPropertyViewController* vc = [[EditPropertyViewController alloc] initWithNibName:@"EditPropertyViewController" bundle:nil];
				vc.delegate = self;
//				vc.targetObject = [trio objectAtSecond];
				NSString* getter = SWF(@"%@ToString", propertyName);
				SEL sel = NSSelectorFromString(getter);
				NSString* text = nil;
				if ([obj isKindOfClass:[NSString class]]) {
					text = obj;
				} else if ([obj respondsToSelector:sel]) {
					text = [obj performSelector:sel];
				}			
				vc.propertyName = propertyName;
				vc.propertyValue = text;
				[self.navigationController pushViewController:vc animated:true];
				vc.title = propertyName;
				[vc release];												
//			}
//		}
//	}
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
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	NSArray* trio = [[targetObject class_properties] objectAtIndex:indexPath.row];
	NSArray* attributes = [trio objectAtThird];
	if ([attributes containsObject:ATTRIBUTE_READONLY] && ![attributes containsObject:ATTRIBUTE_OBJECT]) {
	} else {
		if ([attributes containsObject:ATTRIBUTE_OBJECT]) {
			id obj = [trio objectAtSecond];
			PropertyRootViewController* vc = [[PropertyRootViewController alloc] initWithNibName:@"PropertyRootViewController" bundle:nil];
			vc.targetObject = obj;
			[self.navigationController pushViewController:vc animated:true];
			vc.title = cell.textLabel.text;
			[vc release];								
		} else {
			NSString* propertyName = [trio objectAtFirst];
			NSString* setter = SWF(@"set%@FromString:", [propertyName capitalizedString]);
			SEL sel = NSSelectorFromString(setter);
			if ([targetObject respondsToSelector:sel]) {
				[self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
			}
		}
	}
		 
	[tableView deselectRowAtIndexPath:indexPath animated:true];
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
	self.targetObject = nil;
    [super dealloc];
}


@end





@implementation PropertyCell 

-(void) layoutSubviews {
	@try {
		[super layoutSubviews];
	} @catch (NSException* exception) {
	}
}

@end
