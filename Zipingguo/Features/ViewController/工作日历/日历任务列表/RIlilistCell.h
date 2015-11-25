//
//  RIlilistCell.h
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIlilistCellVM.h"
@interface RIlilistCell : UITableViewCell
{
    RIlilistCellVM*VM;
}
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UILabel *shijian;
@property (strong, nonatomic) IBOutlet UIImageView *tixingimage;
@property (strong, nonatomic) IBOutlet UILabel *fengexian;
@property(nonatomic,retain)RIlilistCellVM*vm;
-(void)bind:(RIlilistCellVM*)vm;
@end
