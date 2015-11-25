//
//  ZuZhiJieGouModel.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZuZhiJieGouModel.h"

@implementation ZuZhiJieGouModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray alloc].init;
        self.tempChildren = [NSMutableArray alloc].init;
    }
    return self;
}
@end
