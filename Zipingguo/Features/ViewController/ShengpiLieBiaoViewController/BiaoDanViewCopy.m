//
//  BiaoDanViewCopy.m
//  Lvpingguo
//
//  Created by jiangshilin on 15/6/5.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import "BiaoDanViewCopy.h"
typedef enum{
    timeConfirm1 = 100,
    textConfirm2,
}confirmTag1;
@implementation BiaoDanViewCopy
{
    UIDatePicker *_datePicker;
    UIPickerView *_picker;
    UIView *_timeBackView;
    CGRect titleRect;
    UIBarButtonItem *confirm;
    int dateFlag;
    int pickerFlag;
    UIView *backView;
}

+(BiaoDanViewCopy *)cellForTableview:(UITableView *)tableview
{
    BiaoDanViewCopy *cell = [tableview dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(float)getTitleHeight:(BiaoDanModel *)model
{
    CGSize Tt =[model.title sizeWithFont:[UIFont systemFontOfSize:12.0f] forWidth:self.frame.size.width-20 lineBreakMode:NSLineBreakByCharWrapping];
    return Tt.height;
}
-(float)getContentHeight:(BiaoDanModel *)model
{
    CGSize Tt =[model.content sizeWithFont:[UIFont systemFontOfSize:12.0f] forWidth:self.frame.size.width-20 lineBreakMode:NSLineBreakByCharWrapping];
    return Tt.height;
}

-(void)setModel:(BiaoDanModel *)model
{
    if (model) {
        _model = model;
        if (_model.title&&_model.title.length >0) {
            [self getHeightWithModel:_model];
        }
    }
    _title.text =[NSString stringWithFormat:@"%@:",_model.title];
    _contentlabel.text =_model.content;
    //_contentlabel.backgroundColor =[UIColor redColor];
    [self setNeedsDisplay];
}

//Redraw
-(void)getHeightWithModel:(BiaoDanModel *)model
{
    //CGSize titleW = [model.title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(ScreenWidth-45.f, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    //CGSize ContentW = [_model.content sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(ScreenWidth-45.f, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    if (model.type ==kchaoSong) {
//        if (titleW.width<=ScreenWidth-45.f&&titleW.width>100.f) {
//            _title.frame =CGRectMake(15, 0, ScreenWidth-45,titleW.height);
//        }else{
//            _title.frame =CGRectMake(15, 12,100.f,titleW.height);
//        }
//        
//        if (model.content.length>0) {
//            _contentlabel.frame =CGRectMake(15, 0,12+21,ContentW.height);
//        }
    }
    _contentlabel.backgroundColor =[UIColor clearColor];
}
- (IBAction)BtnOnClick:(UIButton *)sender {
    
}
// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
@end
