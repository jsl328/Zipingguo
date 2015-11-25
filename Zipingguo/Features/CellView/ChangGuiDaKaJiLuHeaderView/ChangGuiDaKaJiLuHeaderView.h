//
//  ChangGuiDaKaJiLuHeaderView.h
//  Zipingguo
//
//  Created by sunny on 15/10/19.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangGuiDaKaJiLuheaderModel.h"

@interface ChangGuiDaKaJiLuHeaderView : UITableViewHeaderFooterView
{

    IBOutlet UILabel *riLabel;
    IBOutlet UILabel *zhouLabel;
    IBOutlet UILabel *yueLabel;
    IBOutlet UILabel *yueFenLabel;
    IBOutlet UILabel *yearLabel;
}
@property (nonatomic,strong) ChangGuiDaKaJiLuheaderModel *model;
+ (ChangGuiDaKaJiLuHeaderView *)headerForTableView:(UITableView *)tableView;
@end
