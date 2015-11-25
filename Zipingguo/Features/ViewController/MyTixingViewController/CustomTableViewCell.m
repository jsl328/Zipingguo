//
//  CustomTableViewCell.m
//  Zipingguo
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        [self initdata];
    }

    return self;
}
- (id)init
{
    self = [super init];

    if (self)
    {
        [self initdata];
    }

    return self;
}

- (void)initdata
{

    _Textlabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _Textlabel.textColor = [UIColor colorWithRed:53.0/255.0 green:55.0/255.0 blue:68.0/255.0 alpha:1.0];
    _Textlabel.font = [UIFont systemFontOfSize:14];
    _Timelabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _Timelabel.textColor = [UIColor colorWithRed:53.0/255.0 green:55.0/255.0 blue:68.0/255.0 alpha:1.0];
    _Timelabel.font = [UIFont systemFontOfSize:14];

    [self.contentView addSubview:_Textlabel];
    [self.contentView addSubview:_Timelabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.accessoryView !=nil){
        _Textlabel.frame = CGRectMake(15, 0, 150, 44);
        _Textlabel.text = _labelText;
    }else{
        _Textlabel.frame = CGRectMake(15, 0, 150, 44);
        _Textlabel.text = _labelText;
        _Timelabel.frame = CGRectMake(ScreenWidth-60, 0, 60, 44);
        _Timelabel.text = _labelTime;

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
