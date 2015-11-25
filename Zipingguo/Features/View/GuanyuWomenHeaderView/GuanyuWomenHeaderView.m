//
//  GuanyuWomenHeaderView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "GuanyuWomenHeaderView.h"

@implementation GuanyuWomenHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GuanyuWomenHeaderView" owner:self options:nil]lastObject];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
     _icon.frame = CGRectMake((self.frame.size.width-90)/2, 20, 90, 90);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
