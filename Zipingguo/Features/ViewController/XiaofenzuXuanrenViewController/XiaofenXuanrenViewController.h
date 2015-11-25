//
//  XiaofenXuanrenViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"

@interface XiaofenXuanrenViewController : RootViewController

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *Title;

@property (nonatomic, strong) NSMutableArray *endureArray;
@property (nonatomic, strong) NSMutableArray *xuanzhongArray;
@property (nonatomic, strong) NSMutableArray *addArray;

@property (nonatomic ,strong) void (^passValueFromXuanzhong)(NSMutableArray* xuanzhong);

@property (nonatomic, assign) BOOL liaotian;//聊天

@property (nonatomic, assign) BOOL shengpi;//审批人与转交人只能一个

@property (nonatomic, assign) BOOL zhuanjiao;//转交人只能一个

@property (nonatomic, assign) BOOL chaosong;//抄送

@property (nonatomic, assign) BOOL isDetail;//是否从组信息进入

@property (nonatomic, assign) BOOL isAddMenbers;//是加人还是创建群组

@end
