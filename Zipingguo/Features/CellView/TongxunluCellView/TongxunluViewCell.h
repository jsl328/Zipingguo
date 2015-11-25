//
//  TongxunluViewCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TongxunluModel.h"
#import "JZScrollView.h"

@interface TongxunluViewCell : UITableViewCell<UIScrollViewDelegate>{
    
    __weak IBOutlet FXBlurView *fxView;
    __weak IBOutlet JZScrollView *sc;
    __weak IBOutlet UIView *huadongView;
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) TongxunluModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bumen;
@property (weak, nonatomic) IBOutlet UIButton *duanxin;
@property (weak, nonatomic) IBOutlet UIButton *dianhua;
@property (weak, nonatomic) IBOutlet UIButton *liaotian;
@property (weak, nonatomic) IBOutlet UIButton *guanbi;

- (IBAction)buttonClick:(UIButton *)sender;

@end
