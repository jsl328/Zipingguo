//
//  TextViewTableViewCell.m
//  Zipingguo
//
//  Created by jiangshilin on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TextViewTableViewCell.h"

@implementation TextViewTableViewCell
+(TextViewTableViewCell *)cellForTableview:(UITableView *)tableview
{
    TextViewTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:[[self class] description]];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[UIColor clearColor];
        cell.contentView.backgroundColor =[UIColor clearColor];
    }
    return cell;
}

- (void)awakeFromNib {
    //设置输入框的内容填充边距
    _shuruTextView.textContainerInset = UIEdgeInsetsMake(15., 15.f, 15.f, 15.f);
    _shuruTextView.returnKeyType = UIReturnKeyDone;
}

-(void)setBiaodanModel:(BiaoDanModel *)biaodanModel{
    _shuruTextView.delegate =self;
    _shuruTextView.tag =biaodanModel.indexFlag;
    if (biaodanModel) {
        _biaodanModel = biaodanModel;
        _titleNameLabel.text =biaodanModel.title;
        if (!_biaodanModel.content.length&&!_biaodanModel.content) {
            _shuruTextView.placeholder =[NSString stringWithFormat:@"请在此编辑%@",biaodanModel.title];
        }else{
             _shuruTextView.text =biaodanModel.content;
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    _shuruTextView =(UIPlaceHolderTextView*)textView;
    if (textView ==_shuruTextView) {
        if (textView.text.length) {
            _biaodanModel.content = textView.text;
            [_biaodanModel.delegate biaodanWithModel:_biaodanModel withIndex:_shuruTextView.tag];
        }
    }
}
@end
