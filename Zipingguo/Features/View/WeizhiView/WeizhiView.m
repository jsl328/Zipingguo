//
//  WeizhiView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WeizhiView.h"

@implementation WeizhiView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WeizhiView" owner:self options:nil]lastObject];
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
- (IBAction)shanchuButtonClick:(UIButton *)sender {
    [self.delegate shanchuWeizhi:self];
}

@end
