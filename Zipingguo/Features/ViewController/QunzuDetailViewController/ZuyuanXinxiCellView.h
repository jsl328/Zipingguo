//
//  ZuyuanXinxiCellView.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCImageFrame.h"
#import "ZuyuanXinxiCellVM.h"

@interface ZuyuanXinxiCellView : UIView

@property (nonatomic, strong) ZuyuanXinxiCellVM *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageFrame;
@property (weak, nonatomic) IBOutlet UIButton *shanchuButton;
@property (weak, nonatomic) IBOutlet UIButton *tianjiaChengyuanButton;
@property (weak, nonatomic) IBOutlet UIButton *shanjianButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)buttonClick:(UIButton *)sender;
@end
