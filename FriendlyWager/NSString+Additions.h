//
//  StringHelper.h
//  
//
//  Created by Sergio on 22/10/10.
//  Copyright 2010 Sergio. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (helper)

- (NSString*) substringFrom: (NSInteger) a to: (NSInteger) b;

- (NSInteger) indexOf: (NSString*) substring from: (NSInteger) starts;

- (NSString*) trim;

- (BOOL) startsWith:(NSString*) s;

- (BOOL) containsString:(NSString*) aString;

- (NSString *)urlEncodeCopy;

- (NSString *)shortURL;

- (NSString *)reformatTelephone;

- (BOOL)containsNullString;

@end
