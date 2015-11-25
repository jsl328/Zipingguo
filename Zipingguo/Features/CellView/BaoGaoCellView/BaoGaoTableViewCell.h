//
//  BaoGaoTableViewCell.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaoGaoTableViewCellVM;

@interface BaoGaoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *shijian;

@property (weak, nonatomic) IBOutlet UIImageView *leixing;

@property (weak, nonatomic) IBOutlet UILabel *isRead;

+ (id)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) BaoGaoTableViewCellVM *model;



@end


/**
 *  数据模型
 */
@interface BaoGaoTableViewCellVM : NSObject

@property(nonatomic,retain)NSString*ID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isCaogao;
@property (nonatomic) int leixing;//1-日报 2-周报 3-月报
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,assign) BOOL isRead;//是否已阅

@end
