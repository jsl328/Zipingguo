//
//  DaKaSM.h
//  Zipingguo
//
//  Created by sunny on 15/11/2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class DaKaSoundsSM;

@interface DaKaSM : NSObject<IAnnotatable>
/// 用户名 -- 不能为空
@property (nonatomic,copy) NSString *yongHuID;
/// 详细地址 -- 不能为空
@property (copy, nonatomic) NSString *address;
/// 维度
@property (nonatomic,assign) float  positionx;
/// 经度
@property (nonatomic,assign) float positiony;
/// 外出内容
@property (copy, nonatomic) NSString *content;
/// 打卡类型 -- 考勤类型，1-打卡考勤-2-外出记录
@property (nonatomic,assign) int daKaType;
/// 公司名 -- 不能为空
@property (copy, nonatomic) NSString *companyid;
/// 图片数组
@property (strong, nonatomic) NSArray *imagesStr;
/// 语音数组
@property (strong, nonatomic) NSArray *daKaSounds;

@end

@interface DaKaSoundsSM : NSObject <IAnnotatable>
/// 图片，语音链接地址
@property (nonatomic,copy) NSString *soundUrl;
/// 语音时长 单位秒
@property (nonatomic,assign) int soundTime;

@end
