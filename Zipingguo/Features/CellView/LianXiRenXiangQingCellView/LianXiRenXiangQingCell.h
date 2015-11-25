//
//  LianXiRenXiangQingCell.h
//  Zipingguo
//
//  Created by sunny on 15/9/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LianXiRenModel.h"

@interface LianXiRenXiangQingCell : UITableViewCell{

    IBOutlet UIImageView *touXiangImage;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *detailLabel;
    IBOutlet UILabel *buMenLabel;
}
+ (LianXiRenXiangQingCell *)cellForTableView:(UITableView *)tableView;

@property (nonatomic,strong) LianXiRenModel *model;
@end
