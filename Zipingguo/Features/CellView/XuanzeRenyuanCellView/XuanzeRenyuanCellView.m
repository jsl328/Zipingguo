//
//  XuanzeRenyuanCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XuanzeRenyuanCellView.h"

@implementation XuanzeRenyuanCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(XuanzeRenyuanModel *)model{
    if (model) {
        _model = model;
        [touxiang setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.personsSM.imgurl] fileName:@"头像80.png" Width:touxiang.frame.size.width];
        //        self.name.text = model.personsSM.name;
        name.attributedText = model.showName;
        zuming.text = model.personsSM.deptname;
        if (model.xuanzhong) {
            xuanzhongBtn.selected = YES;
        }else{
            xuanzhongBtn.selected = NO;
        }
        
        if (model.endure) {
            [xuanzhongBtn setImage:[UIImage imageNamed:@"已选icon.png"] forState:UIControlStateNormal];
        }else{
            [xuanzhongBtn setImage:[UIImage imageNamed:@"未选icon.png"] forState:UIControlStateNormal];
        }
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)xuanzhongClick:(UIButton *)sender {
}

@end
