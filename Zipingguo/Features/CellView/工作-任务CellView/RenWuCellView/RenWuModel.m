//
//  RenWuModel.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuModel.h"

@implementation RenWuModel
- (void)bindData:(RenwuData *)data{
    self.renWuID = data.ID;
    self.isFinish = data.isfinish;
    self.isZhongYao = data.importance;
    self.renWuName = data.title;
    self.renWuNeiRong = data.content;
    self.personName = data.createname;
    self.type = data.type;
}
@end
