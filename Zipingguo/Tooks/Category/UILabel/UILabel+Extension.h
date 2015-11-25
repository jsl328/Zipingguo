//
//  UILabel+Extension.h
//  Zipingguo
//
//  Created by sunny on 15/9/25.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
/**
 *  改变label中某段字体的颜色和大小
 *
 *  @param labelText   label的text
 *  @param color       要改变字体的颜色
 *  @param font        要改变字体的大小
 *  @param rangeString 要改变的字符串
 */
- (void)addAttributeWithString:(NSString*)labelText andColorValue:(UIColor*)color andUIFont:(UIFont *)font andRangeString:(NSString *)rangeString;

/**
 *  获取label的大小
 *
 *  @param width     宽度
 *  @param height    高度
 *  @param font      字体大小
 *  @param labelText label内容
 *
 *  @return return  返回label的size
 */
- (CGSize)getLabelSizeWithLabelMaxWidth:(float)width MaxHeight:(float)height FontSize:(UIFont *)font LabelText:(NSString *)labelText;
@end
