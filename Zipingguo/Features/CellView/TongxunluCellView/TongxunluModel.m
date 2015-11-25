//
//  TongxunluModel.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TongxunluModel.h"

@implementation TongxunluModel

- (void)setPersonsSM:(DeptPersonsSM *)personsSM{
    _personsSM = personsSM;
    
    NSString *s = [NSString stringWithFormat:@"%@   %@",personsSM.name,personsSM.position.length ? personsSM.position : @""];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:s];
    if (personsSM.position.length) {
        NSRange pRange = [s rangeOfString:personsSM.position];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:pRange];
        [mStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(160, 160, 162, 1) range:pRange];
    }
    self.showName = mStr;
    
}

@end
