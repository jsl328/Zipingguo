//
//  DongtaiModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultModelOfIListOfDynamicSM.h"
@class DongtaiPinglunCellVM;
@class DongtaiModel;
@class YuyinView;
@protocol DongtaiModelDelegate <NSObject>

- (void)guanzhuFangfa:(NSString *)createid;

- (void)quxiaoguanzhuFangfa:(NSString *)createid;

- (void)shanchuFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel;

- (void)pinglunFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel;

- (void)zanFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel;

- (void)quxiaoZanFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel;

- (void)huofuPinglun:(DongtaiPinglunCellVM *)pinglunCellVM DongtaiModel:(DongtaiModel *)dtModel;

-(void)pengYouQuanCellView:(NSArray *)tupianArray DidSelectedWithIndex:(int)index;

- (void)bofangYuyin:(YuyinView *)yuyinUrl;

- (void)jinXiangqingWithAllDynamicSM:(AllDynamicSM *)dynamic DongtaiModel:(DongtaiModel *)dtModel;

- (void)tiaozhuanGerenxinxi:(NSString *)userid;

@end

@interface DongtaiModel : NSObject
@property (nonatomic, strong) id <DongtaiModelDelegate> delegate;
@property (nonatomic, strong) AllDynamicSM *dynamicSM;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) float height;

@end
