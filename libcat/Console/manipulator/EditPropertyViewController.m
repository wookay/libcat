//
//  EditPropertyViewController.m
//  TestApp
//
//  Created by WooKyoung Noh on 13/02/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "EditPropertyViewController.h"
#import "Logger.h"
#import "iPadExt.h"

@implementation EditPropertyViewController
@synthesize textField;
@synthesize delegate;
@synthesize propertyName;
@synthesize propertyValue;

- (BOOL)textFieldShouldReturn:(UITextField *)textField_ {
	[delegate updateProperty:propertyName value:textField.text];
	[self.textField resignFirstResponder];
	[self.navigationController popViewControllerAnimated:true];
	return true;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.propertyName = nil;
		self.propertyValue = nil;
		self.delegate = nil;
    }
    return self;
}

-(void) viewDidLoad {
	[super viewDidLoad];
	self.textField.text = propertyValue;
	[self.textField becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (void)dealloc {
	delegate = nil;
	[textField release];
	[propertyName release];
	[propertyValue release];
    [super dealloc];
}


@end
