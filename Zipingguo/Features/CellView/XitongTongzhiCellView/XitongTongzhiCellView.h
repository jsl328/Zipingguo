//
//  XitongTongzhiCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XitongTongzhiModel.h"
@interface XitongTongzhiCellView : UITableViewCell<UIWebViewDelegate>
{
    
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UIImageView *hongdian;
    __weak IBOutlet UILabel *shijian;
    __weak IBOutlet UILabel *neirong;
    __weak IBOutlet UIWebView *neirongWebView;
}

@property (nonatomic, strong) XitongTongzhiModel *model;

+ (id)cellForTableView:(UITableView *)tableView;

@end
