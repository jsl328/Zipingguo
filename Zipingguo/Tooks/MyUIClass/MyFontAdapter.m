//
//  MBFontAdapter.m
//  JinJiangDuCheng
//
//  Created by Perry on 15/4/8.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import "MyFontAdapter.h"

@implementation MyFontAdapter

+(UIFont *)adjustFont:(UIFont *)font{
    UIFont *newFont=nil;
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
    NSString *IphoneName = [CurrentDevice GetDeviceName];
     if([IphoneName isEqualToString:@"iPhone6"]){
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize+IPHONE6_INCREMENT];
    }else if([IphoneName isEqualToString:@"iPhone6Plus"]){
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize+IPHONE6PLUS_INCREMENT];
    }else{
        newFont = font;
    }

    return newFont;
}

@end
