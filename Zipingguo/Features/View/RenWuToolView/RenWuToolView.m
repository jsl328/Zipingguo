//
//  RenWuToolView.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuToolView.h"

@implementation RenWuToolView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"RenWuToolView" owner:self options:nil].firstObject;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
