//
//  GongzuoViewCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GongzuoModel.h"
@interface GongzuoViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UIImageView *weidu;
    __weak IBOutlet UILabel *biaoti;
    __weak IBOutlet UILabel *neirong;
    
}
+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) GongzuoModel *model;

@end
