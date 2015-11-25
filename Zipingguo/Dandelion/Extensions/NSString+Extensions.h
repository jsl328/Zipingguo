//
//  NSObject+NSString_Extensions.h
//  Nanumanga
//
//  Created by Bob Li on 13-10-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

-(BOOL) startsWithString:(NSString*) string;

-(BOOL) endsWithString:(NSString*) string;
-(BOOL) endsWithStrings:(NSArray*) strings;

- (NSArray *) arrayOfNumbersInString:(NSString *)s;

- (NSString *)MD5Hash;
@end
