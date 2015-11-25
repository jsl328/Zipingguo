//
//  DCNaturalLanguage.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCNaturalLanguage : NSObject

+(char) initialAlphabetFromCharacter:(unichar) c;

+(NSComparisonResult) compareStringPhonetically:(NSString*) s1 withString:(NSString*) s2;

@end
