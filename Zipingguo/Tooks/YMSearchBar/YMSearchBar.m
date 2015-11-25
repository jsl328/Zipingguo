//
//  YMSearchBar.m
//  Zipingguo
//
//  Created by lilufeng on 15/11/25.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "YMSearchBar.h"

@implementation YMSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"搜索输入框"] forState:UIControlStateNormal];
        [self setBackgroundImage:[ToolBox imageWithColor:RGBACOLOR(243, 243, 243, 1)]];
        [self setImage:[UIImage imageNamed:@"搜索icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"搜索输入框"] forState:UIControlStateNormal];
        [self setBackgroundImage:[ToolBox imageWithColor:RGBACOLOR(243, 243, 243, 1)]];
        [self setImage:[UIImage imageNamed:@"搜索icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    }
    return self;
}
@end
