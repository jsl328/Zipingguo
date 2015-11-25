//
//  RIlilistCellVM.h
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIlilistCellVM : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *Name;
@property(nonatomic,copy)NSString *shijian;
@property(nonatomic,copy)NSString *beizhu;
@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *Tingxingzhi;
@property(nonatomic,assign)int tixianghzuangtai;
@property(nonatomic,assign)BOOL istixing;
//1是任务0是日历备注
@property(nonatomic,assign)int isrenwu;

@property(nonatomic,assign) int isfinish;//是否完成
@end
