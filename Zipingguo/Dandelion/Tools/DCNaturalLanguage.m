//
//  DCNaturalLanguage.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCNaturalLanguage.h"
#import "DCPinyin.h"

@implementation DCNaturalLanguage

+(char) initialAlphabetFromCharacter:(unichar) c {

    if (c >= 0x4e00 && c <= 0x9fff) {
        return [DCPinyin initialAlphabetFromCharacter:c];
    }
    else {
        return c;
    }
}

+(NSComparisonResult) compareStringPhonetically:(NSString*) s1 withString:(NSString*) s2 {

    int position = 0;
    
    while (position <= s1.length - 1 && position <= s2.length - 1) {
    
        unichar c1 = [s1 characterAtIndex:position];
        unichar c2 = [s2 characterAtIndex:position];
        
        BOOL isC1Chinese = c1 >= 0x4e00 && c1 <= 0x9fff;
        BOOL isC2Chinese = c2 >= 0x4e00 && c2 <= 0x9fff;
        
        int result;
        
        if (isC1Chinese && isC2Chinese) {
            result = [DCPinyin initialAlphabetFromCharacter:c1] - [DCPinyin initialAlphabetFromCharacter:c2];
        }
        else {
            result = c1 - c2;
        }
        
        if (result < 0) {
            return NSOrderedAscending;
        }
        else if (result == 0) {
            return NSOrderedSame;
        }
        else {
            return NSOrderedDescending;
        }
    }
    
    if (s1.length < s2.length) {
        return NSOrderedAscending;
    }
    else if (s1.length == s2.length) {
        return NSOrderedSame;
    }
    else {
        return NSOrderedDescending;
    }
}

@end
