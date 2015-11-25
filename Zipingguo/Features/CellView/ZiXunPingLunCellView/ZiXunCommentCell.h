//
//  ZiXunCommentCell.h
//  Zipingguo
//
//  Created by sunny on 15/11/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiXunCommentModel.h"
#import "ZiXunSingleCommentCell.h"

@class ZiXunCommentCell;
typedef void(^ZiXunSingleCommentCellClick)(ZiXunCommentModel *,ZiXunSingleCommentModel *);
typedef void(^ZiXunSingleCommentChaKanMoreClick)(ZiXunCommentModel *,ZiXunSingleCommentModel *);
typedef void (^ZiXunSingleCommentCellDelete)(ZiXunCommentModel *,ZiXunSingleCommentModel *);

@interface ZiXunCommentCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIView *topView;
    IBOutlet UIImageView *touXiangImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *contentLabel;

    
    NSMutableArray *singleHeightArray;
   
    
}
@property (strong, nonatomic) IBOutlet UITableView *huiFuTableView;
@property (nonatomic,strong)  NSMutableArray *huiFuDataArray;

+ (ZiXunCommentCell *)cellForTableView:(UITableView *)tableView;

@property (nonatomic,strong) ZiXunCommentModel *model;

@property (nonatomic,strong) ZiXunSingleCommentCellClick ziXunSingleCommentCellClick;
@property (nonatomic,strong) ZiXunSingleCommentChaKanMoreClick chaKanMoreClick;
@property (nonatomic,strong) ZiXunSingleCommentCellDelete ziXunSingleCommentCellDelete;

@end
