//
//  TixingView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TixingView.h"

@implementation TixingView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TixingView" owner:self options:nil]lastObject];
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

- (void)layoutSubviews{
    [super layoutSubviews];
    self.jinggaoWenzi.frame = CGRectMake(43, 18, self.frame.size.width-43, 28);
}

@end
