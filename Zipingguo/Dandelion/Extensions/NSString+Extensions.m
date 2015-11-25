//
//  NSObject+NSString_Extensions.m
//  Nanumanga
//
//  Created by Bob Li on 13-10-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Extensions)

-(BOOL) startsWithString:(NSString*) string {
    return self.length >= string.length && [[self substringToIndex:string.length] isEqualToString:string];
}

-(BOOL) endsWithString:(NSString*) string {
    return self.length >= string.length && [[self substringFromIndex:self.length - string.length] isEqualToString:string];
}

-(BOOL) endsWithStrings:(NSArray*) strings {
    return [strings any:^(NSString* item) {
        return [self endsWithString:item];
    }];
}

- (NSArray *) arrayOfNumbersInString:(NSString *)s{
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    NSString *str = @"";
    //传入 I payed 15.90 dollars for 5 nuts.
    for (NSInteger i = 0; i < [s length]; i++) {
        unichar c  = [s characterAtIndex:i];
        
        if (c >= '0'&&c <= '9') {
            [mutableString appendFormat:@"%c",c];
            str = [mutableString copy];//每次都创建一个新的对象
            if (i == [s length]-1) {
                [marray addObject:str];
                
            }
        }else{
            if ([mutableString length] !=0) {
                [marray addObject:str];
                [mutableString setString:@""];
            }
        }
    }
    //    for (NSInteger i = 0; i < [marray count]-1; i++) {
    //        for (int j = 0; j < [marray count]-1-i; j++) {
    //            NSString *str1 = [marray objectAtIndex:j];
    //            NSString *str2 = [marray objectAtIndex:j+1];
    //            //转化为数字再比较
    //            if ([str1 intValue] > [str2 intValue]) {
    //                [marray exchangeObjectAtIndex:j withObjectAtIndex:j +1];
    //            }
    //        }
    //    }
    return marray;
}

- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}


@end
