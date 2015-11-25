//
//  WodexinxiViewCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WodexinxiViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *neirong;
@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

@property (weak, nonatomic) IBOutlet UIImageView *xian;
+ (id)cellForTableView:(UITableView *)tableView;
@end
