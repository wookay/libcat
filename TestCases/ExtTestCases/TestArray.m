//
//  TestArray.m
//  TestApp
//
//  Created by wookyoung noh on 05/10/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSArrayExt.h"
#import "UnitTest.h"
#import "Logger.h"
#import "NSStringExt.h"
#import "Inspect.h"

@interface TestArray : NSObject
@end


@implementation TestArray

-(void) test_inspect {
	NSArray* lines;
	
	lines = [@"거울속에는소리가없소\
\n저렇게까지조용한세상은참없을것이오\
\n\
\n거울속에도내게귀가있소\
\n내말을못알아듣는딱한귀가두개나있소\
\n\
\n거울속의나는왼손잡이오\
\n내握手를받을줄모르는-악수를모르는왼손잡이요\
\n\
\n거울때문에나는거울속의나를만져보지를못하는구료마는\
\n거울이아니었던들내가어찌거울속의나를만나보기라도했겠소\
\n\
\n나는至今거울을안가졌소마는거울속에는늘거울속의내가있소\
\n잘은모르지만외로된事業에골몰할게요\
\n\
\n거울속의나는참나와는反對요마는\
\n또괘닮았소\
\n나는거울속의나를근심하고診察할수없으니퍽섭섭하오" split:LF];
	assert_equal(lines.count+2, [[lines inspect] split:LF].count);
	
	lines = [@"1 2 3 4 5" split:SPACE];
	assert_equal(@"[\"1\", \"2\", \"3\", \"4\", \"5\"]", [lines inspect]);
}

-(void) test_array {
	NSArray* ary = _w(@"1 2 3");
	
	assert_equal(@"1", [ary objectAtFirst]);
	assert_equal(@"2", [ary objectAtSecond]);
	assert_equal(@"3", [ary objectAtLast]);

	assert_equal(_w(@"1 2 3"), [_w(@"2 1 3") sort]);
}

-(void) test_pair {
	assert_equal(_w(@"a b"), PAIR(@"a", @"b"));
}

-(void) test_trio {
	assert_equal(_w(@"a b c"), TRIO(@"a", @"b", @"c"));
}

-(void) test_transpose {
	NSArray* expected = _array2(_w(@"1 3 5"), _w(@"2 4 6"));
	assert_equal(expected, [_array3(_w(@"1 2"), _w(@"3 4"), _w(@"5 6")) transpose]);
	
	expected = _array3(_w(@"1 2"), _w(@"3 4"), _w(@"5 6"));
	assert_equal(expected, [[_array3(_w(@"1 2"), _w(@"3 4"), _w(@"5 6")) transpose] transpose]);
	
	assert_equal(_array0(), [_array0() transpose]);
}

-(void) test_diagonal {
	NSArray* expected = _array3(_w(@"1 _ _"), _w(@"_ 2 _"), _w(@"_ _ 3"));
	assert_equal(expected, [_w(@"1 2 3") diagonal:UNDERBAR]);
	
	expected = _array3(_w(@"3 _ _"), _w(@"_ 2 _"), _w(@"_ _ 1"));
	assert_equal(expected, [[_w(@"1 2 3") reverse] diagonal:UNDERBAR]);

	expected = _array3(_w(@"_ _ 1"), _w(@"_ 2 _"), _w(@"3 _ _"));
	assert_equal(expected, [[[_w(@"1 2 3") diagonal:UNDERBAR] reverse] transpose]);
	
	expected = _array3(_w(@"_ _ 3"), _w(@"_ 2 _"), _w(@"1 _ _"));
	assert_equal(expected, [[[[_w(@"1 2 3") reverse] diagonal:UNDERBAR] reverse] transpose]);

	assert_equal(_w(@"1 2 3"), [[_w(@"1 2 3") diagonal:UNDERBAR] undiagonal]);

}

@end