//
//  NSString+Ext.h
//  v2ex
//
//  Created by Haven on 18/2/14.
//  Copyright (c) 2014 LF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ext)
/**
 *  计算大小
 *
 *  @param size 大小
 *  @param font 字体字号
 *
 *  @return 大小
 */
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

/**
 *  去空格和换行
 *
 *  @return 去掉空格后的字符串
 */
- (NSString *)quKongGe;

/**
 *  NSString转换为NSDate
 *
 *  @return 转换后的NSDate
 */
- (NSDate *)formatterTime:(NSString *)time;

@end
