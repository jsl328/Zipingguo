//
//  ShengqingHeshengpiView.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-13.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ShengPiCellView.h"

@implementation ShengPiCellView
+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setModel:(ShengPiCellVM *)model
{
    _model = model;
    
    float Tw = 0.0;
    float Th =0.0;
    if (_model.Leixing==1) {
        //审批通过
        _zhuangtaiTipian.image=[UIImage imageNamed:@"通过icon小.png"];
        Tw =_zhuangtaiTipian.image.size.width;
        Th =_zhuangtaiTipian.image.size.height;
    }else if (_model.Leixing==2){
        //审批未通过
        _zhuangtaiTipian.image=[UIImage imageNamed:@"未通过icon小.png"];
        Tw =_zhuangtaiTipian.image.size.width;
        Th =_zhuangtaiTipian.image.size.height;
    }else if(_model.Leixing == 3 || _model.Leixing == 4){
        //待审批。审核中 转交审核 抄送
        _zhuangtaiTipian.image=[UIImage imageNamed:@"待审批icon小.png"];
        Tw =_zhuangtaiTipian.image.size.width;
        Th =_zhuangtaiTipian.image.size.height;
        
    }else{
        // 已经阅读
    }
    
    if (_model.extendType ==1) {
        if (_model.Leixing ==shengpizhong) {
            _zhuangtaiTipian.frame =CGRectMake(ScreenWidth-15.-Tw,20,Tw,Th);
        }else{
            _zhuangtaiTipian.frame = CGRectMake(ScreenWidth-15-Tw, 5,Tw, Th);
        }
        //14:20
        _jitushijianLabel.text=model.jutushijian;
    }else if (_model.extendType ==2){
        //审批列表
        if (_model.Leixing ==5) {
            _zhuangtaiTipian.frame = CGRectMake(ScreenWidth-30-Tw,25,Tw, Th);
        }else{
            _zhuangtaiTipian.frame = CGRectMake(ScreenWidth-15-Tw,(self.frame.size.height-Th)/2-10,Tw, Th);
        }
        
        _jitushijianLabel.text =model.jutushijian;
    }else if (_model.extendType ==3){
        //申请列表
        if (_model.Leixing ==5) {
            _zhuangtaiTipian.frame = CGRectMake(ScreenWidth-30-Tw,25,Tw, Th);
        }else{
            _zhuangtaiTipian.frame = CGRectMake(ScreenWidth-15-Tw,(self.frame.size.height-Th)/2-10,Tw, Th);
        }
        
        _jitushijianLabel.text =model.jutushijian;
    }
    _shengqingrenLabel.text=[NSString stringWithFormat:@"申请人:%@",model.shengqingRen?model.shengqingRen:@""];
    _shengpileixingLabel.text =model.shengpiNeiXing;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(0, 64, ScreenWidth, 1);
}

@end
