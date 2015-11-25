//
//  DaKaJiLuSM.h
//  Zipingguo
//
//  Created by sunny on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class SingleDaySM;
@class SingleDayListSM;
@class DaKaImageSoundSM;

@interface DaKaJiLuSM : NSObject<IAnnotatable>
@property (nonatomic,assign) int status;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy) NSString *data1;
@end

/// 一天的打卡记录
@interface SingleDayListSM : NSObject<IAnnotatable>
/// 创建时间
@property (nonatomic,copy) NSString *datetime;
/// 星期几
@property (nonatomic,copy) NSString *week;
/// 打卡记录
@property (nonatomic,strong) NSArray *list;
@end

/// 每天的打卡记录
@interface SingleDaySM : NSObject <IAnnotatable>
/// 地址
@property (nonatomic,copy) NSString *attdaddr;
/// 记录ID
@property (nonatomic,copy) NSString *attdid;
/// 打卡时间
@property (nonatomic,copy) NSString *attdtime;
/// 打卡类型 1-常规  2-外出
@property (nonatomic,assign) int attdtype;
/// 公司ID
@property (nonatomic,copy) NSString *companyid;
/// 外出内容
@property (nonatomic,copy) NSString *content;
/// 创建日期
@property (nonatomic,copy) NSString *createdate;
/// 用户ID
@property (nonatomic,copy) NSString *createid;
/// 删除标记，0-有效记录-1-已删除的无效记录
@property (nonatomic,assign) int deleteflag;
/// 纬度
@property (nonatomic,assign) int positionx;
/// 经度
@property (nonatomic,assign) int positiony;
/// 星期几
@property (nonatomic,copy) NSString *week;
/// 声音
@property (nonatomic,strong) NSArray *sounds;
/// 图片
@property (nonatomic,strong) NSArray *imgs;

@end

@interface DaKaImageSoundSM : NSObject <IAnnotatable>
/// 打卡记录ID
@property (nonatomic,copy) NSString *attdid;
/// 图片/语音ID
@property (nonatomic,copy) NSString *attdresid;
/// 图片/语音名
@property (nonatomic,copy) NSString *resname;
/// 图片/语音类型
@property (nonatomic,assign) int restype;
/// 图片/语音地址
@property (nonatomic,copy) NSString *resurl;
/// 图片/语音 排序
@property (nonatomic,copy) NSString *sortnum;
/// 图片/语音 时间
@property (nonatomic,copy) NSString *spendtime;
@property (nonatomic,copy) NSString *bigImgUrl;
@end

