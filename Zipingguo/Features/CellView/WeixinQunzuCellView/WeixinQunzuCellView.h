//
//  WeixinQunzuCellView.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeixinQunzuCellVM.h"
#import "DCImageFrame.h"
@interface WeixinQunzuCellView : UITableViewCell

//jsl..
+(WeixinQunzuCellView *)cellForTableView:(UITableView *)tableView;
@property (strong,nonatomic)WeixinQunzuCellVM *model;

@property (weak, nonatomic) IBOutlet UIView *yirenTouxiangView;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangimageFrame;

@property (weak, nonatomic) IBOutlet UIView *liangrenTouxiangView;
@property (weak, nonatomic) IBOutlet UIImageView *liangrenYiImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *liangrenErImageFrame;
@property (strong, nonatomic) IBOutlet UIImageView *deliverStateImageView;

@property (weak, nonatomic) IBOutlet UIView *sanrenTouxiangView;
@property (weak, nonatomic) IBOutlet UIImageView *sanrenYiImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *sanrenErImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *sanrenSanImageFrame;

@property (weak, nonatomic) IBOutlet UIView *duoTouxiangView;
@property (weak, nonatomic) IBOutlet UIImageView *sirenYiImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *sirenErImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *sirenSanImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *sirenSiImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *renshuBeijingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *duoRenshuBeijingImageView;
@property (weak, nonatomic) IBOutlet UILabel *renshuLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *liuyanLabel;
@property (weak, nonatomic) IBOutlet UILabel *shijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiduLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fengexianImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weiduImaeView;
@property (weak, nonatomic) IBOutlet UIImageView *chaohuoShiImageView;

@property (weak, nonatomic) IBOutlet UIView *weiduView1;
@property (weak, nonatomic) IBOutlet UIView *weiduView2;
@property (weak, nonatomic) IBOutlet UILabel *liuyan2;


@end
