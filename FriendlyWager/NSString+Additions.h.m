//
//  StringHelper.m
//  
//
//  Created by Sergio on 22/10/10.
//  Copyright 2010 Sergio. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (helper)

- (NSString*) substringFrom: (NSInteger) a to: (NSInteger) b {
	NSRange r;
	r.location = a;
	r.length = b - a;
	return [self substringWithRange:r];
}

- (NSInteger) indexOf: (NSString*) substring from: (NSInteger) starts {
	NSRange r;
	r.location = starts;
	r.length = [self length] - r.location;
	
	NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
	if (index.location == NSNotFound) {
		return -1;
	}
	return index.location + index.length;
}

- (NSString*) trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL) startsWith:(NSString*) s {
	if([self length] < [s length]) return NO;
	return [s isEqualToString:[self substringFrom:0 to:[s length]]];
}

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString *)urlEncodeCopy
{
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef) self,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
	
    NSString *str = encodedString;
    [encodedString release];
    return str;
}


- (NSString *)shortURL
{
	NSString *apiEndpoint = [NSString stringWithFormat:@"http://is.gd/api.php?longurl=%@", self];
	NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
												  encoding:NSASCIIStringEncoding
													 error:nil];
	
	return shortURL;
}

- (NSString *)reformatTelephone
{
    if ([self containsString:@"-"]) 
    {
        self = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self containsString:@" "]) 
    {
        self = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self containsString:@"("]) 
    {
        self = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsString:@")"]) 
    {
        self = [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return self;
}

- (BOOL)containsNullString
{
    return ([[self lowercaseString] containsString:@"null"]) ? YES : NO;
}

@end
