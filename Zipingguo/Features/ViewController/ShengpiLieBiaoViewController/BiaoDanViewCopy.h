//
//  BiaoDanViewCopy.h
//  Lvpingguo
//
//  Created by jiangshilin on 15/6/5.
//  Copyright (c) 2015年 Linku. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BiaoDanModel.h"
@interface BiaoDanViewCopy : UITableViewCell<UITextFieldDelegate>
+(BiaoDanViewCopy *)cellForTableview:(UITableView *)tableview;
@property (nonatomic,strong)BiaoDanModel *model;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *contentlabel;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *downLineImageView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowBtnView;
- (IBAction)BtnOnClick:(UIButton *)sender;
@property (nonatomic)int index;
@end
