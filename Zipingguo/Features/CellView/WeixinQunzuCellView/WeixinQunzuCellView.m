//
//  WeixinQunzuCellView.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WeixinQunzuCellView.h"

@implementation WeixinQunzuCellView

+ (WeixinQunzuCellView *)cellForTableView:(UITableView *)tableView{
    WeixinQunzuCellView *cell =[tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeixinQunzuCellView" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(WeixinQunzuCellVM *)model
{
    if (model) {
        _model = model;
        NSString *image = URLKEY;
        
        if (model.messageState ==eMessageDeliveryState_Failure) {
            _deliverStateImageView.hidden = NO;
            _deliverStateImageView.image = [UIImage imageNamed:@"发送失败icon.png"];
            
        }else{
            _deliverStateImageView.hidden =YES;
            
        }
        NSLog(@"ee%d",(int)model.imageArr.count);
        if (model.liuyanCount >= 10) {
//            _weiduImaeView.hidden = YES;
//            _chaohuoShiImageView.hidden = NO;
//            _weiduLabel.hidden = NO;
            _weiduView2.hidden = NO;
            _weiduView1.hidden = YES;
            //NSLog(@"ff%d",model.liuyanCount);
            if (model.liuyanCount >= 100) {
                _liuyan2.text  = @"99+";
            }else{
                _liuyan2.text  = [NSString stringWithFormat:@"%d",model.liuyanCount];
            }
        }else if(model.liuyanCount == 0){
            _weiduView1.hidden = YES;
            _weiduView2.hidden = YES;
        }else{
            _weiduView1.hidden = NO;
            _weiduView2.hidden = YES;
            _weiduLabel.text  = [NSString stringWithFormat:@"%d",model.liuyanCount];
        }
        if ([_model.renshu isEqualToString:@"2"]) {
            _yirenTouxiangView.hidden = NO;
            _liangrenTouxiangView.hidden = YES;
            _sanrenTouxiangView.hidden = YES;
            _duoTouxiangView.hidden = YES;
            for (int i = 0; i < model.imageArr.count; i++) {
                if (i == 0) {
                    NSLog(@"=====%@",[model.imageArr objectAtIndex:i]);
                    [_touxiangimageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像80.png" Width:_touxiangimageFrame.frame.size.width];
                }
            }
        }else if ([model.renshu isEqualToString:@"1"]){
            _yirenTouxiangView.hidden = NO;
            _liangrenTouxiangView.hidden = YES;
            _sanrenTouxiangView.hidden = YES;
            _duoTouxiangView.hidden = YES;
            if (model.xinxi) {
                _touxiangimageFrame.image = [UIImage imageNamed:model.touxiangStr];
            }else{
                for (int i = 0; i < model.imageArr.count; i++) {
                    if (i == 0) {
                        [_touxiangimageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像80.png" Width:_touxiangimageFrame.frame.size.width];
                    }
                }
            }
        }else if ([model.renshu isEqualToString:@"3"]){
            _yirenTouxiangView.hidden = YES;
            _liangrenTouxiangView.hidden = NO;
            _sanrenTouxiangView.hidden = YES;
            _duoTouxiangView.hidden = YES;
            for (int i = 0; i < model.imageArr.count; i++) {
                if (i == 0) {
                    [_liangrenYiImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像60.png" Width:_liangrenYiImageFrame.frame.size.width];
                    
                    
                }else if (i == 1){
                    [_liangrenErImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像60.png" Width:_liangrenErImageFrame.frame.size.width];
                    
                }
                
            }
        }else if ([model.renshu isEqualToString:@"4"]){
            _yirenTouxiangView.hidden = YES;
            _liangrenTouxiangView.hidden = YES;
            _sanrenTouxiangView.hidden = NO;
            _duoTouxiangView.hidden = YES;
            for (int i = 0; i < model.imageArr.count; i++) {
                if (i == 0) {
                    [_sanrenYiImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sanrenYiImageFrame.frame.size.width];
                    
                }else if (i == 1){
                    [_sanrenErImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sanrenErImageFrame.frame.size.width];
                    
                    
                }else if (i == 2){
                    [_sanrenSanImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sanrenSanImageFrame.frame.size.width];
                }
                
            }
        }else if ([model.renshu isEqualToString:@"5"]){
            _yirenTouxiangView.hidden = YES;
            _liangrenTouxiangView.hidden = YES;
            _sanrenTouxiangView.hidden = YES;
            _duoTouxiangView.hidden = NO;
            for (int i = 0; i < model.imageArr.count; i++) {
                if (i == 0) {
                    [_sirenYiImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenYiImageFrame.frame.size.width];
                    
                }else if (i == 1){
                    [_sirenErImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenErImageFrame.frame.size.width];
                    
                }else if (i == 2){
                    [_sirenSanImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenSanImageFrame.frame.size.width];
                    
                }else if (i == 3){
                    [_sirenSiImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenSiImageFrame.frame.size.width];
                }
                
            }
            _renshuLabel.text = [NSString stringWithFormat:@"%@",model.renshu];
            _renshuLabel.hidden =YES;
        }else{
            _yirenTouxiangView.hidden = YES;
            _liangrenTouxiangView.hidden = YES;
            _sanrenTouxiangView.hidden = YES;
            _duoTouxiangView.hidden = NO;
            for (int i = 0; i < model.imageArr.count; i++) {
                if (i == 0) {
                    [_sirenYiImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenYiImageFrame.frame.size.width];
                    
                }else if (i == 1){
                    [_sirenErImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenErImageFrame.frame.size.width];
                    
                }else if (i == 2){
                    [_sirenSanImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenSanImageFrame.frame.size.width];
                    
                }else if (i == 3){
                    [_sirenSiImageFrame setUrl:[NSString stringWithFormat:@"%@%@",image,[model.imageArr objectAtIndex:i]]fileName:@"头像40.png" Width:_sirenSiImageFrame.frame.size.width];
                }
                
            }
            _renshuLabel.text = [NSString stringWithFormat:@"%@",model.renshu];
        }
        
        //?????
        if (!model.nameArr.count|| !model.imageArr) {
            _nameLabel.font =[UIFont systemFontOfSize:17.0f];
        }
       //jsl////
        if (_model.messageState ==eMessageDeliveryState_Failure) {
            _deliverStateImageView.hidden =NO;
            _liuyanLabel.frame = CGRectMake(95, _liuyanLabel.frame.origin.y, _liuyanLabel.frame.size.width, _liuyanLabel.frame.size.height);
        }else{
            _deliverStateImageView.hidden =YES;
            _liuyanLabel.frame = CGRectMake(70, _liuyanLabel.frame.origin.y, _liuyanLabel.frame.size.width, _liuyanLabel.frame.size.height);
        }
        _nameLabel.text = model.name;
        _liuyanLabel.text = model.lastLiuyan;
        _shijianLabel.text = model.shijian;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
	//[self updatesize];
}
@end
