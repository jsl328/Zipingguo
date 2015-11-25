//
//  ListView.m
//  Doris
//
//  Created by lilufeng on 15/11/23.
//  Copyright © 2015年 LF. All rights reserved.
//

#import "ListView.h"
#define ScreenWidth [[UIScreen mainScreen]bounds].size.width

#define ScreenHeight [[UIScreen mainScreen]bounds].size.height

#define NavHeight (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ?  64 : 44)
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


@implementation ListView

-(id)initWithItems:(NSArray *)items images:(NSArray *)images forAlignment:(ListViewAlignment)alignment Callback:(void (^)(int))buttonClickCallback{
    
    self = [super init];
    if (self) {
        _buttonClickCallback = buttonClickCallback;
        _items = items;
        _images = images;
        _alignment = alignment;
        _bgImages = @[];
        if(_alignment == ListViewAlignmentCenter){
            _bgImages = @[@"上bg-居中",@"中bg",@"下bg"];
        }else{
            _bgImages = @[@"上bg",@"中bg",@"下bg"];

        }


//        [self initUI];
    }
    return self;
}


-(void)show{
//    _bgView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView  = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);

    [(UIControl*)_bgView addTarget:self action:@selector(onMaskClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self btnViewConfig];
    
    AppDelegate * appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:_bgView];
    
    if (_alignment == ListViewAlignmentCenter) {
        btnView.center = CGPointMake(ScreenWidth / 2, NavHeight);
        btnView.layer.anchorPoint = CGPointMake(0.5, 0);
    }else{
        btnView.center = CGPointMake(ScreenWidth - 10, NavHeight);
        btnView.layer.anchorPoint = CGPointMake(1, 0);
    }
    
    btnView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    btnView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        btnView.transform = CGAffineTransformMakeScale(1, 1);
        btnView.alpha = 1;
    }];

}
- (void)selectedIndex:(NSInteger)index{

    _currentIndex = index;

}
- (void)btnViewConfig{
    btnView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 140 - 10, NavHeight, 140, 49 + 44 *(_items.count - 1))];
    if(_alignment == ListViewAlignmentCenter){
        btnView.frame = CGRectMake((ScreenWidth - 140)/2, NavHeight, 140, 49 + 44 *(_items.count - 1));
    }
    [_bgView addSubview:btnView];
    for (int i = 0 ; i < _items.count; i ++) {
        NSString *btnBgImageName = @"" ;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {//第一个
             btn.imageEdgeInsets = UIEdgeInsetsMake(5, -8, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
            btn.frame = CGRectMake(0, 0, btnView.width, 49);
            btnBgImageName = _bgImages[0];

        }else{
             btn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
            btn.frame = CGRectMake(0, 49 + 44 * (i - 1), btnView.width, 44);
            if (i == _items.count - 1) {//最后一个
                btnBgImageName = _bgImages[2];
            }else{
                btnBgImageName = _bgImages[1];
            }
        }
        
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-点击",btnBgImageName]]forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-点击",btnBgImageName]]forState:(UIControlStateHighlighted|UIControlStateSelected)];

        [btn setBackgroundImage:[UIImage imageNamed:btnBgImageName] forState:UIControlStateNormal];

        
        if(_images.count == _items.count){//有图
            [btn setImage:[UIImage imageNamed:_images[i]] forState:UIControlStateNormal];
        }
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:RGBACOLOR(53, 55, 68, 1) forState:UIControlStateNormal];
        if(_alignment == ListViewAlignmentCenter){
            [btn setTitleColor:RGBACOLOR(4, 175, 245, 1) forState:UIControlStateSelected];
        }
        if (i == _currentIndex) {
            btn.selected = YES;
        }

        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(listbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10000 + i;
        [btnView addSubview:btn];
        
    }
}

-(void)listbtnClick:(UIButton *)btn{

    UIButton *currentBtn = [btnView viewWithTag:_currentIndex + 10000];

    btn.selected = YES;
    
    currentBtn.selected = NO;
    _currentIndex = btn.tag - 10000;
    ((void (^)(NSInteger))_buttonClickCallback)(btn.tag - 10000);
    [self close];
}

-(void) onMaskClick:(id) sender {
    [self close];
}

-(void) close {
    
    [(UIControl*)_bgView removeTarget:self action:@selector(onMaskClick:) forControlEvents:UIControlEventTouchUpInside];

    [UIView animateWithDuration:0.3 animations:^{
        btnView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        btnView.alpha = 0;

    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        _bgView = nil;
        [self didClose];
    }];
}
-(void) onCloseComplete {
    
    [_bgView removeFromSuperview];
    _bgView = nil;
    [self didClose];
}
@end
