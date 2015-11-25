//
//  ZuZhiJieGouTableViewCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZuZhiJieGouTableViewCell.h"
@implementation ZuZhiJieGouTableViewCell
{
    ZuZhiJieGouModel *mo;
}
+ (instancetype)cellWithtableView:(UITableView *)tableView withCellName:(NSString *)cellName{
    ZuZhiJieGouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ZuZhiJieGouTableViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}
- (void)bindDataWith:(ZuZhiJieGouModel *)model{
    messgeTF.delegate = self;
    mo = model;
    messgeTF.text = mo.name;
    if (mo.isEditing){
        deleteButton.hidden = NO;
        deleteButton.selected = !mo.canDelete;
        rightButton.hidden = YES;
        deleteButton.userInteractionEnabled = mo.canDelete;
    }else{
        deleteButton.hidden = YES;
        if (mo.children.count!=0||mo.tempChildren.count!=0) {
            rightButton.hidden = NO;
        }else {
            rightButton.hidden = YES;
        }
    }
    TFLeftWidth.constant = mo.isEditing?43+15*mo.cengJi:15+15*mo.cengJi;
    leftWidth.constant = 15+15*mo.cengJi;
    messgeTF.userInteractionEnabled = mo.isEditing;
    rightButton.selected = mo.children.count;
    finishButton.hidden = YES;
}
- (IBAction)finishButton:(UIButton *)sender {
    finishButton.hidden = YES;
    [messgeTF resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    finishButton.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    finishButton.hidden = YES;
    if (![textField.text length]) {
        [SDialog showTipViewWithText:@"组织名称不能为空" hideAfterSeconds:1 finishCallBack:^(){
            [messgeTF becomeFirstResponder];
        }];
    }else{
        mo.name = messgeTF.text;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    mo.name = messgeTF.text;
    NSLog(@"%@",messgeTF.text);
    return YES;
}
- (IBAction)rightButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate zheDieButtonClick:mo isClose:sender.selected];
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    [self.delegate deleteButtonClick:mo];
}
- (void)awakeFromNib {
    // Initialization code
    [rightButton setImage:[UIImage imageNamed:@"ZC右箭头.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"箭头向下.png"] forState:UIControlStateSelected];
 
}
- (void)bindSelectCengJiData:(ZuZhiJieGouModel *)model{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    rightButton.hidden = YES;
    deleteButton.hidden = YES;
    finishButton.hidden = !model.isShowIcon;
    finishButton.userInteractionEnabled = NO;
    messgeTF.userInteractionEnabled = NO;
    if (model.isShowIcon) {
        messgeTF.textColor = DCColorFromRGB(4, 175, 245);
    }else{
        messgeTF.textColor = DCColorFromRGB(53, 55, 68);
    }
    messgeTF.text = model.name;
    TFLeftWidth.constant = model.isEditing?43+15*model.cengJi:15+15*model.cengJi;
    leftWidth.constant = 15+15*(model.cengJi+1);
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
