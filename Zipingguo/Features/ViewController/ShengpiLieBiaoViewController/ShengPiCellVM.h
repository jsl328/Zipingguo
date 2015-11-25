//
//  ShengPiCellVM.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//
@class ShengPiCellVM;
@protocol ShengPiCellVMDelegate <NSObject>
@optional
- (void)shengpiVm:(ShengPiCellVM *)vm;
@end
#import <Foundation/Foundation.h>
#import "DCCellHeightDataSource.h"

typedef enum : NSUInteger {
    shengpitongguo=1,
    shengpiweitongguo,
    shengpizhong,
    zhuanjiaodaisheng,
    chaosong,
} shengpiLeixing;

@interface ShengPiCellVM : NSObject
@property(nonatomic,strong)NSString *flowName;
@property(nonatomic,strong)NSString *dealid;
@property(nonatomic,strong)NSString *dealName;
@property(nonatomic,strong)NSString *dealTime;
@property(nonatomic,strong)NSString *createid;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *chname;
@property (nonatomic) float cellHeight;
@property(nonatomic,strong)NSString*_ID;
@property(nonatomic,strong)NSString*shengpizhuangtai;
@property(nonatomic,strong)NSString*shengpiNeiXing;
@property(nonatomic,strong)NSString*shengqingRen;
@property(nonatomic,strong)NSString*jutushijian;
@property(nonatomic,strong)NSString*riqiStr;
@property(nonatomic,strong)NSString*zongshijianStr;
@property(nonatomic,assign)shengpiLeixing Leixing;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)int Subtype; // ==2 判断是body的最后一个;
@property(nonatomic,strong)NSString *flowid;
@property (nonatomic,assign)int extendType; // 1 审批列表  2 审批详情 3 申请详情
@property(nonatomic,assign)BOOL iszhuanJiao;

@property (nonatomic,assign)id<ShengPiCellVMDelegate>delegate;
//
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content1;
@property(nonatomic,assign)BOOL istime;
@property(nonatomic,assign)BOOL islast;//最后一个
@property(nonatomic,assign)BOOL isfirst;//最开始一个
@property(nonatomic,assign)BOOL isSelected;//是否选中
@end
