//
//  ZanPingView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/22.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZanView.h"

@implementation ZanView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZanView" owner:self options:nil]lastObject];
    }

    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _zanName.frame = CGRectMake(_zanName.frame.origin.x, (40-_zanName.frame.size.height)/2.0, self.width-_zanName.frame.origin.x-15, _zanName.frame.size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
