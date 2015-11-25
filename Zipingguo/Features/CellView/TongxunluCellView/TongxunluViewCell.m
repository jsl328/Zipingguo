//
//  TongxunluViewCell.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TongxunluViewCell.h"
#import "FXBlurView.h"
static NSString *nowScrollCellID = nil;

static NSString *TongXunLunCellScrollNotification = @"kTongXunLunCellScrollNotification";
static NSString *TongXunLunCellScrollKey = @"kTongXunLunCellScrollKey";

@interface TongxunluViewCell ()

@end

@implementation TongxunluViewCell

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScroll:) name:TongXunLunCellScrollNotification object:nil];
}

- (void)didScroll:(NSNotification *)noc{
    if (![[noc.userInfo objectForKey:TongXunLunCellScrollKey] isEqual:self]) {
        [sc setContentOffset:CGPointZero];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(TongxunluModel *)model{
    if (model) {
        _model = model;
        [self.touxiang setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.personsSM.imgurl] fileName:@"头像80.png" Width:self.touxiang.frame.size.width];
//        self.name.text = model.personsSM.name;
        self.name.attributedText = model.showName;
        self.bumen.text = model.personsSM.deptname;
        if ([model.personsSM.userid isEqualToString:[AppStore getYongHuID]]) {
            _liaotian.enabled = NO;
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:TongXunLunCellScrollNotification object:nil userInfo:@{TongXunLunCellScrollKey : self}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:TongXunLunCellScrollNotification object:nil userInfo:@{TongXunLunCellScrollKey : self}];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    fxView.dynamic = YES;
    fxView.blurRadius = 30;//高斯模糊度
    fxView.tintColor = [UIColor clearColor];
    sc.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    sc.contentSize = CGSizeMake(self.bounds.size.width * 2, 0);
    huadongView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.frame.size.height);
    fxView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.frame.size.height);
    
    _liaotian.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width/3, self.frame.size.height);
    
    _duanxin.frame = CGRectMake(_liaotian.frame.size.width+_liaotian.frame.origin.x, 0, self.frame.size.width/3, self.frame.size.height);
    
    _dianhua.frame = CGRectMake(_duanxin.frame.size.width+_duanxin.frame.origin.x, 0, self.frame.size.width/3, self.frame.size.height);
    
    _guanbi.frame = CGRectMake(_liaotian.frame.size.width+_liaotian.frame.origin.x, 0, self.frame.size.width/4, self.frame.size.height);
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == _dianhua) {
        [_model.delegate callNumber:_model];
    }else if (sender == _duanxin){
        [_model.delegate smsMessage:_model];
    }else if (sender == _liaotian){
        [_model.delegate chatMessage:_model];
    }else if (sender == _guanbi){
        [sc setContentOffset:CGPointZero];
    }
}
@end
