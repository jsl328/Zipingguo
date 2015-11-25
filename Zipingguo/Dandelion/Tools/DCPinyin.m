//
//  DCPinyin.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCPinyin.h"

@implementation DCPinyin



/**
 * @author gnuhpc email: warmbupt@gmail.com blog: http://gnuhpc.info
 * @date 2010-1-22
 * @bugs 不支持多音字处理
 */

    // 简体中文的编码范围从B0A1（45217）一直到F7FE（63486）
  //  private static int BEGIN = 45217;
  //  private static int END = 63486;

#define BEGIN 45217
#define END 63486
    
    // 按照声母表示，这个表是在GB2312中的出现的第一个汉字，也就是说“啊”是代表首字母a的第一个汉字。
    // i, u, v都不做声母, 自定规则跟随前面的字母
/*private static char[] chartable = { '啊', '芭', '擦', '搭', '蛾', '发', '噶', '哈',
'哈', '击', '喀', '垃', '妈', '拿', '哦', '啪', '期', '然', '撒', '塌', '塌',
'塌', '挖', '昔', '压', '匝' };
*/

static NSStringEncoding _gb2312Encoding;

    // 二十六个字母区间对应二十七个端点
    // GB2312码汉字区间十进制表示
static int table[27];

    // 对应首字母区间表
static char initialtable[26];

    // 初始化
    +(void) load {
        
        _gb2312Encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        for (int i = 0; i <= 25; i++) {
            initialtable[i] = 'a' + i;
        }
        
        
        NSArray* chartable = @[ @"啊", @"芭", @"擦", @"搭", @"蛾", @"发", @"噶", @"哈",
            @"哈", @"击", @"喀", @"垃", @"妈", @"拿", @"哦", @"啪", @"期", @"然", @"撒", @"塌", @"塌",
            @"塌", @"挖", @"昔", @"压", @"匝" ];

        for (int i = 0; i <= chartable.count - 1; i++) {
            NSString* s = [chartable objectAtIndex:i];
            table[i] = [self gbValue:[s characterAtIndex:0]];
        }
        
        // 得到GB2312码的首字母区间端点表，十进制。
        
        table[26] = END;// 区间表结尾
    }
    
    // ------------------------public方法区------------------------
    /**
     * 根据一个包含汉字的字符串返回一个汉字拼音首字母的字符串 最重要的一个方法，思路如下：一个个字符读入、判断、输出
     */
+(char) initialAlphabetFromCharacter:(unichar) c {
    
    return [DCPinyin Char2Initial:c];
}
    
    // ------------------------private方法区------------------------
    /**
     * 输入字符,得到他的声母,英文字母返回对应的大写字母,其他非简体汉字返回 '0'
     *
     */
+(char) Char2Initial:(unichar) ch {

        // 对英文字母的处理：小写字母转换为大写，大写的直接返回
        if (ch >= 'a' && ch <= 'z')
            return (char) (ch - 'a' + 'A');
        if (ch >= 'A' && ch <= 'Z')
            return ch;
        
        // 对非英文字母的处理：转化为首字母，然后判断是否在码表范围内，
        // 若不是，则直接返回。
        // 若是，则在码表内的进行判断。
    int gb = [DCPinyin gbValue:ch];// 汉字转换首字母
        
        if ((gb < BEGIN) || (gb > END))// 在码表区间之前，直接返回
            return ch;
        
        int i;
        for (i = 0; i < 26; i++) {// 判断匹配码表区间，匹配到就break,判断区间形如“[,)”
            if ((gb >= table[i]) && (gb < table[i+1]))
                break;
        }
        
        if (gb==END) {//补上GB2312区间最右端
            i=25;
        }
        return initialtable[i]; // 在码表区间中，返回首字母
    }
    
    /**
     * 取出汉字的编码 cn 汉字
     */
+(int) gbValue:(unichar) ch {// 将一个汉字（GB2312）转换为十进制表示。
    
    NSMutableString* s = [[NSMutableString alloc] init];
    [s appendFormat:@"%C", ch];
    
    NSData* data = [s dataUsingEncoding:_gb2312Encoding];
    unsigned char *bytes = (unsigned char *)[data bytes];
    
            if (data.length < 2)
                return 0;
            return (bytes[0] << 8 & 0xff00) + (bytes[1] & 0xff);

    }

@end
