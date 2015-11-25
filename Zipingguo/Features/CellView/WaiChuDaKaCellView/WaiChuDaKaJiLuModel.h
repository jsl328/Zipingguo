//
//  WaiChuDaKaModel.h
//  Zipingguo
//
//  Created by sunny on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaKaJiLuSM.h"

@interface WaiChuDaKaJiLuModel : NSObject
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSArray *yuYinArray;
@property (nonatomic,strong) NSArray *tuPianArray;
@end

@interface YuyinModel : NSObject
/// 打卡记录ID
@property (nonatomic,copy) NSString *attdid;
/// 图片/语音
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

- (void)setYuYinModelWithSM:(DaKaImageSoundSM *)sm;
@end

@interface TupianModel : NSObject
/// 打卡记录ID
@property (nonatomic,copy) NSString *attdid;
/// 图片/语音
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

- (void)setTuPianModelWithSM:(DaKaImageSoundSM *)sm;
@end
