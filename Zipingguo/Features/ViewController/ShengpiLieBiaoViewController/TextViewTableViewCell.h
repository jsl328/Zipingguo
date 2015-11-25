//
//  TextViewTableViewCell.h
//  Zipingguo
//
//  Created by jiangshilin on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiaoDanModel.h"
#import "UIPlaceHolderTextView.h"

@interface TextViewTableViewCell : UITableViewCell<UITextViewDelegate>
+(TextViewTableViewCell *)cellForTableview:(UITableView *)tableview;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *shuruTextView;
@property (strong, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (strong, nonatomic)  BiaoDanModel *biaodanModel;
@property (strong, nonatomic) IBOutlet UIImageView *breakLineImageView;
@end
