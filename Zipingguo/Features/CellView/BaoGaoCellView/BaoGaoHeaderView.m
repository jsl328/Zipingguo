//
//  BaoGaoHeaderView.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/28.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoHeaderView.h"

@implementation BaoGaoHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BaoGaoHeaderView" owner:self options:nil]lastObject];
        
    }
    return self;
}

-(void)awakeFromNib{

    [_shuZiLabel setCircle];
}

-(void)setModel:(BaoGaoHeaderViewModel *)model{

    _model = model;
    _titleLabel.text = model.title;
    _shuZiLabel.text = model.shuzi;
    if ([model.shuzi intValue] > 0) {
        _shuZiLabel.hidden = NO;
    }else{
        _shuZiLabel.hidden = YES;
    }
    
    if (model.isZhanKai) {
//        _jianTouImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        _jianTouImageView.image = [UIImage imageNamed:@"箭头向下"];
        _xiaFenGeImageView.hidden = NO;
        
    }else{
//        _jianTouImageView.transform = CGAffineTransformMakeRotation(0);
        _jianTouImageView.image = [UIImage imageNamed:@"右箭头"];
        _xiaFenGeImageView.hidden = YES;


    }
    
}


- (IBAction)buttonClick:(UIButton *)sender {
//    if([_delegate respondsToSelector:@selector(baoGaoHeaderViewSelected)]){
//        [_delegate baoGaoHeaderViewSelected];
//    }
    
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:[NSNumber numberWithInteger:_index] afterDelay:0.0];
    }
    
}
@end

@implementation BaoGaoHeaderViewModel


@end
