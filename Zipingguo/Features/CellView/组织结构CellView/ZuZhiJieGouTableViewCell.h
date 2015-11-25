//
//  ZuZhiJieGouTableViewCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZuZhiJieGouModel.h"

@protocol ZuZhiJieGouTableViewCellDelegate <NSObject>
@optional
- (void)zheDieButtonClick:(ZuZhiJieGouModel *)model isClose:(BOOL)close;
- (void)deleteButtonClick:(ZuZhiJieGouModel *)model;

@end



@interface ZuZhiJieGouTableViewCell : UITableViewCell<UITextFieldDelegate>
{
    __weak IBOutlet NSLayoutConstraint *TFLeftWidth;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *finishButton;
    __weak IBOutlet UIButton *rightButton;
    __weak IBOutlet UITextField *messgeTF;
    __weak IBOutlet NSLayoutConstraint *leftWidth;
}
+ (instancetype)cellWithtableView:(UITableView *)tableView withCellName:(NSString *)cellName;
@property (nonatomic,assign) id<ZuZhiJieGouTableViewCellDelegate>delegate;

- (void)bindDataWith:(ZuZhiJieGouModel *)model;
- (void)bindSelectCengJiData:(ZuZhiJieGouModel *)model;


@end
