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
#import "NSNumberExt.h"
#import "NSObjectExt.h"
#import "NSStringExt.h"
#import "NSArrayExt.h"
#import "NSObjectSetValueFromString.h"
#import "NSObjectValueToString.h"
#import "EditPropertyViewController.h"
#import <objc/runtime.h>
#import "ConsoleManager.h"

@implementation PropertyRootViewController
@synthesize targetObject;
@synthesize hierarchyData;
@synthesize propertiesData;

-(void) updateProperty:(NSString*)propertyName value:(id)value attributeString:(NSString*)attributeString {
	NSString* setter = SWF(@"set%@:", [propertyName uppercaseFirstCharacter]);
	SEL sel = NSSelectorFromString(setter);
	if ([targetObject respondsToSelector:sel]) {
		NSMethodSignature* sig = [targetObject methodSignatureForSelector:sel];
		const char* argType = [sig getArgumentTypeAtIndex:ARGUMENT_INDEX_ONE];
		Method m = class_getInstanceMethod([targetObject class], sel);
		IMP imp = method_getImplementation(m);
		switch (*argType) {
			case _C_ID:
				[targetObject performSelector:sel withObject:value];
				break;

			case _C_CHR:
			case _C_BOOL:
				((void (*)(id, SEL, BOOL))imp)(targetObject, sel, [value boolValue]);
				break;
				
			case _C_INT:
				((void (*)(id, SEL, int))imp)(targetObject, sel, [value intValue]);
				break;
				
			case _C_UINT:
				((void (*)(id, SEL, unsigned int))imp)(targetObject, sel, [value unsignedIntValue]);
				break;

			case _C_FLT:
				((void (*)(id, SEL, float))imp)(targetObject, sel, [value floatValue]);
				break;
				
			case _C_STRUCT_B:
			case _C_STRUCT_E: {
					NSMethodSignature* sig = [targetObject methodSignatureForSelector:sel];
					NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
					[invocation setSelector:sel];
					[invocation setTarget:targetObject];
					BOOL invoke = true;
					int idx = ARGUMENT_INDEX_ONE;
					if ([attributeString hasPrefix:@"{CGRect"]) {
						CGRect rect = CGRectFromString(value);
						[invocation setArgument:&rect atIndex:idx];
					} else if ([attributeString hasPrefix:@"{CGAffineTransform"]) {
						CGAffineTransform t = CGAffineTransformFromString(value);
						[invocation setArgument:&t atIndex:idx];
					} else if ([attributeString hasPrefix:@"{CATransform3D"]) {
						invoke = false;
					} else if ([attributeString hasPrefix:@"{CGSize"]) {
						CGSize size = CGSizeFromString(value);
						[invocation setArgument:&size atIndex:idx];
					} else if ([attributeString hasPrefix:@"{CGPoint"]) {
						CGPoint point = CGPointFromString(value);
						[invocation setArgument:&point atIndex:idx];
					} else {
						invoke = false;
					}
					if (invoke) {
						[invocation invoke];								
					}
				}
				break;
		}
		[self load_properties_data];
		[self.tableView reloadData];
	}
}

-(void) manipulateTargetObject:(id)targetObject_ {
	self.targetObject = targetObject_;
	self.title = SWF(@"%@", targetObject_);
	self.hierarchyData = [NSArray arrayWithArray:[targetObject_ class_hierarchy]];
	[self load_properties_data];
	[self.tableView reloadData];
}

-(void) load_properties_data {
	NSMutableArray* ary = [NSMutableArray array];
	for (int idx = 0; idx < hierarchyData.count - 1; idx++) {
		Class targetClass = [hierarchyData objectAtIndex:idx];
		[ary addObject:[targetObject class_properties:targetClass]];
	}
	self.propertiesData = [NSArray arrayWithArray:ary];
}

#pragma mark -
#pragma mark View lifecycle

-(IBAction) touchedDone:(id)sender {
	[PROPERTYMAN hide];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.targetObject = nil;
		self.hierarchyData = [NSArray array];
		self.propertiesData = [NSArray array];
    }
    return self;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {   // fixed font style. use custom view (UILabel) if you want something different
	Class targetClass = [self.hierarchyData objectAtIndex:section];
	return NSStringFromClass(targetClass);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.hierarchyData.count - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.propertiesData objectAtIndex:section] count];
}

-(kObjectAttributeType) objectAttributeTypeForProperty:(NSArray*)trio {
	id obj = [trio objectAtSecond];
	NSArray* attributes = [trio objectAtThird];
	NSString* attributeString = [attributes objectAtFirst];

	if ([obj isNull]) {
		if ([_w(@"@\"UIColor\"") containsObject:attributeString]) {
			return kObjectAttributeTypeObject;
		} else {
			return kObjectAttributeTypeNull;
		}
	} else {
#define STR_FLOAT @"f"
#define STR_NSSTRING @"@\"NSString\""
		if ([attributeString isEqualToString:STR_NSSTRING]) {
			return kObjectAttributeTypeString;
		} else if ([attributeString hasPrefix:AT_SIGN]) {
			return kObjectAttributeTypeObject;
		} else if ([attributeString hasPrefix:OPENING_BRACE]) { // struct
			return kObjectAttributeTypeStruct;
		} else {
			if ([attributes containsObject:STR_FLOAT]) {
				return kObjectAttributeTypeFloat;
			} else {
				return kObjectAttributeTypeInt; // i c
			}
		}
	}
	return kObjectAttributeTypeNone;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}

	NSArray* trio = [[self.propertiesData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString* propertyName = [trio objectAtFirst];
	cell.textLabel.text = propertyName;
	cell.textLabel.adjustsFontSizeToFitWidth = true;
	id obj = [trio objectAtSecond];
	
	Class targetClass = [self.hierarchyData objectAtIndex:indexPath.section];
	NSString* objectDetail = [PROPERTYMAN.typeInfoTable objectDescription:obj targetClass:NSStringFromClass(targetClass) propertyName:propertyName];
	cell.detailTextLabel.text = objectDetail;
	if ([@"false" isEqualToString:objectDetail]) {
		cell.detailTextLabel.textColor = [UIColor grayColor];
	} else {
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
	}
	kObjectAttributeType type = [self objectAttributeTypeForProperty:trio];
	switch (type) {
		case kObjectAttributeTypeObject:
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
			
		case kObjectAttributeTypeString:
		case kObjectAttributeTypeInt:
		case kObjectAttributeTypeFloat:
		case kObjectAttributeTypeStruct:
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
			
		case kObjectAttributeTypeNone:
		case kObjectAttributeTypeNull:
		default:
			cell.accessoryType = UITableViewCellAccessoryNone;
			break;
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSArray* trio = [[self.propertiesData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	id obj = [trio objectAtSecond];
	kObjectAttributeType type = [self objectAttributeTypeForProperty:trio];
	NSString* propertyName = [trio objectAtFirst];
	EditPropertyViewController* vc = [[EditPropertyViewController alloc] initWithNibName:@"EditPropertyViewController" bundle:nil];
	vc.delegate = self;
	vc.propertyType = type;
	vc.propertyName = propertyName;
	vc.propertyValue = obj;
	NSArray* attributes = [trio objectAtThird];
	NSString* attributeString = [attributes objectAtFirst];
	vc.attributeString = attributeString;
	[self.navigationController pushViewController:vc animated:true];
	vc.title = propertyName;
	[vc release];	
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
	NSArray* trio = [[self.propertiesData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	kObjectAttributeType type = [self objectAttributeTypeForProperty:trio];
	switch (type) {
		case kObjectAttributeTypeObject: {
				id obj = [trio objectAtSecond];

				PropertyRootViewController* vc = [[PropertyRootViewController alloc] initWithNibName:@"PropertyRootViewController" bundle:nil];
				[vc manipulateTargetObject:obj];
				[self.navigationController pushViewController:vc animated:true];
				vc.title = cell.textLabel.text;
				[vc release];								
			}
			break;
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
	[hierarchyData release];
	[propertiesData release];
    [super dealloc];
}


@end