//
//  GotoView.m
//  LibcatPresentation
//
//  Created by WooKyoung Noh on 15/03/11.
//  Copyright 2011 factorcat. All rights reserved.
//

#import "GotoView.h"
#import "NSStringExt.h"

@implementation GotoView
@synthesize gotoDelegate;

+(void) showGotoAlertView:(NSString*)title_ currentPage:(int)currentPage numberOfPages:(int)numberOfPages delegate:(id)delegate_ {
	GotoView* gotoView = [[[GotoView alloc] initWithTitle:title_
												  message:LF
												 delegate:delegate_ 
										cancelButtonTitle:NSLocalizedString(@"Done",@"") 
									otherButtonTitles:nil] autorelease];
	gotoView.gotoDelegate = delegate_;
	[gotoView addSlider:currentPage numberOfPages:numberOfPages];
	[gotoView show];
}

-(IBAction) touchedSlider:(UISlider*)slider {
	[gotoDelegate changedSlidePage:slider.value];
}

-(void)	addSlider:(int)currentPage numberOfPages:(int)numberOfPages {
	UISlider* slider = [[[UISlider alloc] initWithFrame:CGRectMake(13.0, 10+35, 258.0-5, 27.0-3)] autorelease];
	slider.maximumValue = numberOfPages - 1;
	slider.value = currentPage;
	[slider addTarget:self action:@selector(touchedSlider:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:slider];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.gotoDelegate = nil;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	gotoDelegate = nil;
    [super dealloc];
}


@end
