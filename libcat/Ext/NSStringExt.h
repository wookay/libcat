//
//  NSStringExt.h
//  Bloque
//
//  Created by Woo-Kyoung Noh on 05/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_STRING     @""
#define SPACE            @" "
#define LF               @"\n"
#define TAB              @"\t"
#define AMP              @"&"
#define AT_SIGN			 @"@"
#define EQUAL            @"="
#define COLON            @":"
#define SEMICOLON		 @";"
#define SEMICOLON_SPACE	 @"; "
#define COMMA            @","
#define UNDERBAR		 @"_"
#define COMMA_SPACE		 @", "
#define COMMA_LF		 @",\n"
#define DOT              @"."
#define DOT_SPACE		 @". "
#define DOT_DOT			 @".."
#define STAR             @"*"
#define SLASH			 @"/"
#define PLUS             @"+"
#define PIPE             @"|"
#define MINUS			 @"-"
#define QUESTION_MARK    @"?"
#define EXCLAMATION_MARK @"!"
#define DOLLAR			 @"$"
#define TILDE			 @"~"
#define	LESS_THAN        @"<"
#define	GREATER_THAN     @">"
#define OPENING_BRACE	 @"{"
#define CLOSING_BRACE	 @"}"
#define OPENING_PARENTHESE		@"("
#define CLOSING_PARENTHESE		@")"
#define OPENING_SQUARE_BRACKET  @"["
#define CLOSING_SQUARE_BRACKET  @"]"
#define DOUBLE_QUOTATION_MARK	@"\""
#define SINGLE_QUOTATION_MARK	@"'"

#define CHAR_BACKSPACE	 '\b'
#define CHAR_MINUS       '-'

#define STR_TRUE	@"true"
#define STR_FALSE	@"false"
#define STR_NIL		@"nil"

#define TEXT_ALERT		NSLocalizedString(@"Alert", nil)
#define TEXT_WARNING	NSLocalizedString(@"Warning", nil)
#define TEXT_OK			NSLocalizedString(@"OK", nil)
#define TEXT_CANCEL		NSLocalizedString(@"Cancel", nil)
#define TEXT_NO			NSLocalizedString(@"No", nil)
#define TEXT_YES		NSLocalizedString(@"Yes", nil)

#define SECTION_INDEX_TITLE_FOR_SEARCH			@"{search}"
#define INDEX_OF_SECTION_INDEX_TITLE_FOR_SEARCH 0


#define CP949_ENCODING 0x80000422

NSString* SWF(NSString* format, ...) ;
NSArray* _w(NSString* str) ;
NSString* char_to_string(char ch) ;
NSString* int_to_string(int n);
NSString* double_to_string(double n) ;
NSString* unichar_to_string(unichar ch) ;
NSString* nil_to_empty_string(NSString* str) ;
NSInteger sortByStringComparator(NSString* uno, NSString* dos, void* context) ;
char unichar_high(unichar uch) ;
unsigned short unichar_low(unichar uch) ;


@interface NSString (Ext)
-(BOOL) isEmpty ;
-(BOOL) isNotEmpty ;	
-(BOOL) isIntegerNumber ;
-(BOOL) isIntegerNumberWithSpace ;
-(BOOL) isAlphabet ;
-(BOOL) hasSurrounded:(NSString*)a :(NSString*)b ;
-(BOOL) hasText:(NSString*)str ;

-(int) to_int ;
-(char) to_char ;
-(unichar) to_unichar ;
-(size_t) to_size_t ;

-(NSString*) stringAtIndex:(int)idx ;
-(unichar) unicharAtIndex:(int)idx ;
-(NSString*) last ;
-(NSString*) strip ;
-(NSString*) slice:(int)loc :(int)length_ ;
-(NSString*) slice:(int)loc backward:(int)backward ;
-(NSString*) gsub:(NSString*)str to:(NSString*)to ;
-(NSString*) uppercaseFirstCharacter ;
-(NSString*) repeat:(int)times ;
-(NSString*) reverse ;
-(NSString*) truncate:(int)lengthToCut ;
-(NSString*) ljust:(int)justified ;
+(NSString*) stringWithCharacter:(unichar) ch ;
+(NSString*) stringFormat:(NSString*)formatString withArray:(NSArray*)arguments ;

-(NSArray*) split ;
-(NSArray*) split:(id)sep ;
-(NSArray*) each_chars ;

-(NSData*) to_data ;

@end

