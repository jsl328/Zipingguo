//
//  DaKaWaiChuSM.h
//  Zipingguo
//
//  Created by sunny on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface DaKaWaiChuRecordSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *createid;
 /// 图片数组
@property (retain, nonatomic) NSArray *imgstrs;
 /// 语音时长数组
@property (retain, nonatomic) NSArray *spendtimes;
 /// 语音数组
@property (retain, nonatomic) NSArray *sounds;
@property (nonatomic,assign)int  positionx;
@property (nonatomic,assign)int positiony;
@property (retain, nonatomic) NSString *companyid;

@end