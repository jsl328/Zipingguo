//
//  UILabel+Extension.m
//  Zipingguo
//
//  Created by sunny on 15/9/25.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
- (void)addAttributeWithString:(NSString*)labelText andColorValue:(UIColor*)color andUIFont:(UIFont *)font andRangeString:(NSString *)rangeString{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
                                             initWithString:labelText];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:[labelText rangeOfString:rangeString]];
    
    [attrString addAttribute:NSFontAttributeName value:font
                       range:[labelText rangeOfString:rangeString]];
    self.attributedText = attrString;
}

- (CGSize)getLabelSizeWithLabelMaxWidth:(float)width MaxHeight:(float)height FontSize:(UIFont *)font LabelText:(NSString *)labelText{
    CGSize fSize;
    CGSize size =CGSizeMake(width ,height);
    if (IOSDEVICE) {
        fSize = [labelText boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
    }else{
        fSize = [labelText sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return fSize ;
}
@end
