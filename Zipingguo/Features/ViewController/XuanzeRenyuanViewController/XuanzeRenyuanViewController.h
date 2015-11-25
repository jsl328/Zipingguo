//
//  XuanzeRenyuanViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"
#import "ShengPiCellVM.h"
@interface XuanzeRenyuanViewController : RootViewController
//不显示人员数组ID
@property (nonatomic, strong) NSMutableArray *endureArray;
//传值数组model
@property (nonatomic, strong) NSMutableArray *xuanzhongArray;
//加人数组ID
@property (nonatomic, strong) NSMutableArray *addArray;

@property (nonatomic, assign) BOOL liaotian;

@property (nonatomic, assign) BOOL shengpi;//审批人只能一个

@property (nonatomic, assign) BOOL zhuanjiao;//转交人只能一个

@property (nonatomic, assign) BOOL chaosong;//抄送

@property (nonatomic, assign) BOOL isDetail;//是否从组信息进入

@property (nonatomic, assign) BOOL isAddMenbers;//是加人还是创建群组

@end
