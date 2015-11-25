//
//  ChangGuiDaKaJiLuHeaderView.m
//  Zipingguo
//
//  Created by sunny on 15/10/19.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ChangGuiDaKaJiLuHeaderView.h"

@implementation ChangGuiDaKaJiLuHeaderView

+ (ChangGuiDaKaJiLuHeaderView *)headerForTableView:(UITableView *)tableView{
    ChangGuiDaKaJiLuHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ChangGuiDaKaJiLuHeaderView"];
    if (!header) {
        header = [[[NSBundle mainBundle] loadNibNamed:@"ChangGuiDaKaJiLuHeaderView" owner:self options:nil] lastObject];
    }
    return header;
}
- (void)setModel:(ChangGuiDaKaJiLuheaderModel *)model{
    if (model) {
        riLabel.text = model.ri;
        zhouLabel.text = model.weekDay;
        yueLabel.text = [NSString stringWithFormat:@"%@ %@",model.year,model.month];
        yueFenLabel.text = [NSString stringWithFormat:@"%@月",model.month];
        yearLabel.text = [NSString stringWithFormat:@"%@ ",model.year];
//        if (model.isTop == YES) {
//            yueFenLabel.hidden = NO;
//            yearLabel.hidden = NO;
//        }else{
//            yueFenLabel.hidden = YES;
//            yearLabel.hidden = YES;
//        }
    }
}
@end
