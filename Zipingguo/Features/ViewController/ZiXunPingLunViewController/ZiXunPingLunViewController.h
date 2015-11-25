//
//  ZiXunPingLunViewController.h
//  Zipingguo
//
//  Created by sunny on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ZiXunCellModel.h"

typedef void(^PingLunChange)(ZiXunCellModel *ziXunCellModel);
@interface ZiXunPingLunViewController : ParentsViewController
{
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *headerView;
    IBOutlet UIImageView *touXiangImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *neiRongLabel;
    IBOutlet UIView *bottomView;
    IBOutlet UIPlaceHolderTextView *shuRuTextView;
    IBOutlet UIButton *yaoQingBtn;
    IBOutlet UIButton *sendBtn;
    
}

@property (nonatomic,strong)PingLunChange pingLunChange;

@property (nonatomic, strong) NSString *ziXunID;
@property (nonatomic,strong) ZiXunCellModel *ziXunCellModel;

@end
