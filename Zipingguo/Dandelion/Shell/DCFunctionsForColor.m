//
//  DCFunctionsForColor.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFunctionsForColor.h"

UIColor* DCColorFromHex(NSString* hex) {
    
    int position = 0;
    if ([hex characterAtIndex:0] == '#') {
        position = 1;
    }
    
    int c1 = DCNumberFromHexChars([hex characterAtIndex:position], [hex characterAtIndex:position + 1]);
    int c2 = DCNumberFromHexChars([hex characterAtIndex:position + 2], [hex characterAtIndex:position + 3]);
    int c3 = DCNumberFromHexChars([hex characterAtIndex:position + 4], [hex characterAtIndex:position + 5]);
    int c4 = position + 6 <= hex.length - 1 ? DCNumberFromHexChars([hex characterAtIndex:position + 6], [hex characterAtIndex:position + 7]) : -1;
    
    if (c4 == -1) {
        return DCColorFromRGB(c1, c2, c3);
    }
    else {
        return DCColorFromARGB(c1, c2, c3, c4);
    }
}

UIColor* DCColorFromARGB(int a, int r, int g, int b) {
    
    return [UIColor colorWithRed:(float)r / 255 green:(float)g / 255 blue:(float)b / 255 alpha:(float)a / 255];
}

UIColor* DCColorFromRGB(int r, int g, int b) {
    
    return [UIColor colorWithRed:(float)r / 255 green:(float)g / 255 blue:(float)b / 255 alpha:1];
}
