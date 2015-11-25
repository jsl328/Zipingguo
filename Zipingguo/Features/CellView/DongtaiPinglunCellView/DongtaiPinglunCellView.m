//
//  DongtaiPinglunCellView.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-6.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DongtaiPinglunCellView.h"
#import "UILabel+Extension.h"
@implementation DongtaiPinglunCellView

- (void)bind:(DongtaiPinglunCellVM *)model{
    cellVM = model;
    
    if (model.isIcon) {
        icon.hidden = NO;
    }
    
    content.text = model.content;
 
    CGSize size2 = [model.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth-2*15-79, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    content.frame = CGRectMake(79, 5, size2.width, size2.height);
    
    NSMutableAttributedString *attrString;
    
    if (model.model.relusername != nil && model.content != nil) {
        attrString = [[NSMutableAttributedString alloc]
                                                 initWithString:model.content];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:RGBACOLOR(95, 115, 154, 1)
                           range:[model.content rangeOfString:model.model.createname]];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:RGBACOLOR(95, 115, 154, 1)
                           range:[model.content rangeOfString:model.model.relusername]];
    }else if ([model.model.isreply isEqualToString:@"0"]) {
        attrString = [[NSMutableAttributedString alloc]
                      initWithString:model.content];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:RGBACOLOR(95, 115, 154, 1)
                           range:[model.content rangeOfString:model.model.createname]];
    }else{
        if (model.content != nil) {
            attrString = [[NSMutableAttributedString alloc]
                          initWithString:model.content];
        }
    }
    
    content.attributedText = attrString;

}
- (void)layoutSubviews{
    [super layoutSubviews];

    
}

@end
