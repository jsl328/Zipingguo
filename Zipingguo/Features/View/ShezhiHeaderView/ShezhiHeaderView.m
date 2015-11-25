//
//  ShezhiHeaderView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShezhiHeaderView.h"

@implementation ShezhiHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShezhiHeaderView" owner:self options:nil]lastObject];
    }
    return self;
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self.delegate gerenxinTiaozhuan];
}
@end
