//
//  DaKaCell.h
//  Zipingguo
//
//  Created by sunny on 15/10/8.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaKaModel.h"

@interface DaKaCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;

@property (nonatomic, strong) DaKaModel *model;
+ (DaKaCell *)cellFortableView:(UITableView *)tableView;
@end
