//
//  WeixinQunzuVM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WeixinQunzuCellVM.h"
@implementation WeixinQunzuCellVM

-(id)init
{
    self =[super init];
    if (self) {
        self.nameArr = [[NSMutableArray alloc]init];
        self.idArr =[[NSMutableArray alloc]init];
        self.imageArr =[[NSMutableArray alloc]init];
    }
    return self;
}
@end
