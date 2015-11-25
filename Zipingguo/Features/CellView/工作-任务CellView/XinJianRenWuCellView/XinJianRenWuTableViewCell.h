//
//  XinJianRenWuTableViewCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinJianRenWuModel.h"
@interface XinJianRenWuTableViewCell : UITableViewCell<UITextViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *leftConstraint;
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UIImageView *lineImageView2;/**<间距15的分割线*/
    __weak IBOutlet UIImageView *lineImageView;
    __weak IBOutlet UILabel *valueLabel;
    __weak IBOutlet UILabel *titleNameLabel;
}
@property (nonatomic,copy) NSString *cellTypeName;
@property (nonatomic,copy) NSString *cellName;
@property (nonatomic,copy) NSString *cellValue;
@property (nonatomic,assign) CGFloat cellHeight;
- (void)bindDataWithModel:(XinJianRenWuModel *)model;
@end
