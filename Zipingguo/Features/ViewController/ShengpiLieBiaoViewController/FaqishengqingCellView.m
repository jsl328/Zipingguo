//
//  FaqishengqingCellView.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "FaqishengqingCellView.h"
#import "UILabel+Extension.h"
@implementation FaqishengqingCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(void)setModel:(FaqishengqingCellVM *)model
{
    if (model) {
        _model = model;
         _neibieLabel.text=[NSString stringWithFormat:@"%@",model.biaoti];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    _neibieLabel.frame=CGRectMake(15.f,11.f, ScreenWidth-30.f-15.f,_neibieLabel.frame.size.height);
//    _neibieLabel.textColor =[UIColor colorWithRed:53./255. green:55./255 blue:68./255 alpha:1];
//    _neibieLabel.font =[UIFont systemFontOfSize:14.f];
//    _neibieLabel.autoresizingMask =UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
}
@end
