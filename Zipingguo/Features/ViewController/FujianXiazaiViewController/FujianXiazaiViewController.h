//
//  FujianXiazaiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "ResultModelOfIListOfNoticeSM.h"
@interface FujianXiazaiViewController : ParentsViewController
{
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UIButton *xiazai;

}

@property(nonatomic,strong)NSMutableArray *arrayDict;
@property (nonatomic, strong) NoticeAnnexsSM *noticeAnnexsSM;

@end
