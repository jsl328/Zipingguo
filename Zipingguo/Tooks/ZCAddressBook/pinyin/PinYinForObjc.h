//
//  PinYinForObjc.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"
#import "pinyin.h"

@interface PinYinForObjc : NSObject

+ (NSString*)chineseConvertToPinYin:(NSString*)chinese;//转换为拼音
+ (NSString*)chineseConvertToPinYinHead:(NSString *)chinese;//转换为拼音首字母
+ (BOOL)isIncludeChineseInString:(NSString*)str;//判断是否有汉字
@end