//
//  XingzuoVM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-9.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "XingzuoVM.h"

@implementation XingzuoVM

+ (NSString *)chuanzhiNum:(NSString *)num;{
    int Num = [num intValue];
    NSString *xingzuoStr;
    if (Num >= 120 && Num <= 218) {
        xingzuoStr = @"水瓶座";
    }else if (Num >= 219 && Num <= 320){
        xingzuoStr = @"双鱼座";
    }else if (Num >= 321 && Num <= 419){
        xingzuoStr = @"白羊座";
    }else if (Num >= 420 && Num <= 520){
        xingzuoStr = @"金牛座";
    }else if (Num >= 521 && Num <= 621){
        xingzuoStr = @"双子座";
    }else if (Num >= 622 && Num <= 722){
        xingzuoStr = @"巨蟹座";
    }else if (Num >= 723 && Num <= 822){
        xingzuoStr = @"狮子座";
    }else if (Num >= 823 && Num <= 922){
        xingzuoStr = @"处女座";
    }else if (Num >= 923 && Num <= 1023){
        xingzuoStr = @"天秤座";
    }else if (Num >= 1024 && Num <= 1122){
        xingzuoStr = @"天蝎座";
    }else if (Num >= 1123 && Num <= 1221){
        xingzuoStr = @"射手座";
    }else{
        xingzuoStr = @"摩羯座";
    }
    return xingzuoStr;
}

@end
