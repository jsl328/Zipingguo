//
//  PiYueRenTableViewCell.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PiYueRenTableViewCellModel;

@protocol PiYueRenTableViewCellDelegate <NSObject>

-(void)shouqiOrZhankaiChaoSongRen:(BOOL)isShouqi;

@end

@interface PiYueRenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *xingmingLabel;
@property (weak, nonatomic) IBOutlet UIButton *shouqiBtn;
- (IBAction)shouqiClick:(id)sender;

+ (id)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) PiYueRenTableViewCellModel *model;
@property (nonatomic,assign) id<PiYueRenTableViewCellDelegate> delegate;


@end

@interface PiYueRenTableViewCellModel : NSObject
@property (copy, nonatomic) NSString *title;
@property (nonatomic,strong) NSArray *name;
@property (nonatomic,assign) BOOL isCanShouQi;//是否有收起功能，即显示收起
@property (nonatomic,assign) BOOL _isShouQi;//收起还是展开？是否收起 yes-收起状态，显示展开 反之显示收起
@property (nonatomic,assign) BOOL shouquZhuangtai;
@property (nonatomic,assign) float cellHeight;


@end