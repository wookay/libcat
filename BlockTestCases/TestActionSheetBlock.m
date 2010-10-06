//
//  TestActionSheetBlock.m
//  TestApp
//
//  Created by wookyoung noh on 06/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "UIActionSheetBlock.h"
#import "NSStringExt.h"
#import "UnitTest.h"
#import "NSNumberExt.h"

@interface TestActionSheetBlock : NSObject
@end


@implementation TestActionSheetBlock

-(void) test_action_sheet {
	__block NSMutableArray* ary;
	
	ary = [[NSMutableArray array] retain];
	[UIActionSheet show:[UIApplication sharedApplication].keyWindow
				  title:@"question" 
				buttons:[NSArray arrayWithObjects:
						 sheet_cancel(@"cancel 0", ^{ [ary addObject:@"0"]; }),
						 sheet_destructive(@"destructive 1", ^{ [ary addObject:@"1"]; }),
						 sheet_other(@"other 2", ^{ [ary addObject:@"2"]; }),
						 sheet_other(@"other 3", ^{ [ary addObject:@"3"]; }),
						 sheet_other(@"other 4", ^{ [ary addObject:@"4"]; }),
						 sheet_other(@"other 5", ^{ [ary addObject:@"5"]; }),
						 sheet_other(@"other 6", ^{ [ary addObject:@"6"]; }),
						 nil]
			  afterDone:^ {
					  assert_equal(_w(@"3"), ary);
					  [ary release];
				   }
				   pass:^int {
					   return 3;
				   }
	 ];
	
	ary = [[NSMutableArray array] retain];
	[UIActionSheet show:[UIApplication sharedApplication].keyWindow
				  title:@"question" 
				buttons:[NSArray arrayWithObjects:
						 sheet_other(@"other 0", ^{ [ary addObject:@"0"]; }),
						 sheet_other(@"other 1", ^{ [ary addObject:@"1"]; }),
						 sheet_other(@"other 2", ^{ [ary addObject:@"2"]; }),
						 sheet_other(@"other 3", ^{ [ary addObject:@"3"]; }),
						 nil]
			  afterDone:^ {
					  assert_equal(_w(@"3"), ary);
					  [ary release];
				   }
				   pass:^int {
					   return 3;
				   }
	 ];
	
	ary = [[NSMutableArray array] retain];
	[UIActionSheet show:[UIApplication sharedApplication].keyWindow
				  title:@"question" 
				buttons:[NSArray arrayWithObjects:
						 sheet_cancel(@"cancel 0", ^{ [ary addObject:@"0"]; }),
						 nil]
			  afterDone:^ {
					  assert_equal(_w(@"0"), ary);
					  [ary release];
				   }
				   pass:^int {
					   return 0;
				   }
	 ];
	
	ary = [[NSMutableArray array] retain];
	[UIActionSheet show:[UIApplication sharedApplication].keyWindow
				  title:@"question" 
				buttons:[NSArray arrayWithObjects:
						 sheet_destructive(@"destructive 0", ^{ [ary addObject:@"0"]; }),
						 sheet_other(@"other 1", ^{ [ary addObject:@"1"]; }),
						 nil]
			  afterDone:^ {
					  assert_equal(_w(@"1"), ary);
					  [ary release];
				   }
				   pass:^int {
					   return 1;
				   }
	 ];
}

@end
