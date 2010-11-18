//
//  UIControlViewController.m
//  TestApp
//
//  Created by wookyoung noh on 09/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIControlViewController.h"
#import "NSStringExt.h"
#import "UIBarButtonItemBlock.h"
#import "Logger.h"

@implementation UIControlViewController

-(IBAction) touchedUpButton:(id)sender {
	counterLabel.text = SWF(@"%d", [counterLabel.text intValue] + 1);
}

-(IBAction) touchedDownButton:(id)sender {
	counterLabel.text = SWF(@"%d", [counterLabel.text intValue] - 1);
}

-(void) setCounterLabelTextByInt:(int)intValue {
	counterLabel.text = SWF(@"%d", intValue);
}

-(void) setCounterLabelTextByFloat:(float)floatValue {
	counterLabel.text = SWF(@"%f", floatValue);
}

-(void) setCounterLabelTextByString:(NSString*)str {
	counterLabel.text = str;
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[upButton setTitle:NSLocalizedString(@"up", nil) forState:UIControlStateNormal];
	[downButton setTitle:NSLocalizedString(@"down", nil) forState:UIControlStateNormal];

	self.navigationController.toolbarHidden = false;		
	
}

-(void) viewWillAppear:(BOOL)animated {
	[self setToolbarItems:[NSArray arrayWithObjects:
						   barbutton_item_style(NSLocalizedString(@"+ 2", nil), ^{
								[self touchedUpButton:nil];
								[self touchedUpButton:nil];
							}, UIBarButtonItemStyleBordered),						   
						   barbutton_fixed_space(10),
						   barbutton_item(NSLocalizedString(@"- 2", nil), ^{
								[self touchedDownButton:nil];
								[self touchedDownButton:nil]; 
							}),
						   barbutton_flexible_space(0),
						   barbutton_system(UIBarButtonSystemItemAdd, ^{
								[self touchedUpButton:nil]; 
							}),
						   barbutton_fixed_space(15),
						   barbutton_system_style(UIBarButtonSystemItemTrash, ^{
								counterLabel.text = @"0";
							}, UIBarButtonItemStylePlain),
						   nil]];
	[super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
	self.navigationController.toolbarHidden = true;
	[super viewWillDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	log_info(@"viewDidUnload");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	log_info(@"dealloc");
    [super dealloc];
}


@end
