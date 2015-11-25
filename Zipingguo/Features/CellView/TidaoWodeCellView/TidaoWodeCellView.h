//
//  TidaoWodeCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidaoWodeModel.h"
@interface TidaoWodeCellView : UITableViewCell
{
    
    __weak IBOutlet UIImageView *touxiang;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *neirong;
    __weak IBOutlet UILabel *shijian;
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) TidaoWodeModel *model;

@end
