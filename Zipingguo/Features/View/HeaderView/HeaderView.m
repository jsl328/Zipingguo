//
//  HeaderView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil]lastObject];
    }
    return self;
}

@end
