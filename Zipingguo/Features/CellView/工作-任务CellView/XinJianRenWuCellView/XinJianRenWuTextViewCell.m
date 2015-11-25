//
//  XinJianRenWuTextViewCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XinJianRenWuTextViewCell.h"

@implementation XinJianRenWuTextViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] firstObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    _bianJiTF.font = [UIFont systemFontOfSize:13];
}
- (void)bindDataWithModel:(XinJianRenWuModel *)model{
    titleNameLabel.text = [NSString stringWithFormat:@"%@:",model.cellName];
    titleNameLabel.textColor = RGBACOLOR(140, 140, 140, 1);
    tipView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    if ([model.cellTypeName isEqualToString:@"xinJianNeiRong"]){
        _bianJiTF.text =  model.cellValue;
        titleNameLabel.text = @"任务内容";
        _bianJiTF.placeholder = @"在此编辑任务内容";
        _bianJiTF.tag = 1001;
    }else{
        _bianJiTF.text =  model.cellValue;
        titleNameLabel.text = @"备注";
        _bianJiTF.placeholder = @"在此编辑备注";
        _bianJiTF.tag = 1002;
    }
    _bianJiTF.delegate = self;
    
}
- (void)textViewDidChange:(UITextView *)textView{
    [self.delegate textViewText:textView.text tag:textView.tag];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
