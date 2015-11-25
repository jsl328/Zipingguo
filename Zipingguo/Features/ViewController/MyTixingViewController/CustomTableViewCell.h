//
//  CustomTableViewCell.h
//  Zipingguo
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *Textlabel;
@property(nonatomic,strong) UILabel *Timelabel;

@property(assign,nonatomic)NSString *labelText;
@property(assign,nonatomic)NSString *labelTime;

@end
