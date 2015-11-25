//
//  RenwuDB.h
//  Zipingguo
//
//  Created by miao on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "EntityBase.h"
#import "IAnnotatable.h"
#import <Foundation/Foundation.h>
@class RenwuLM;
@interface RenwuDB : EntityBase
@property(nonatomic,assign)int ISshangchuan;//是否上传,0上传1没有上传
@property(nonatomic,copy)NSString*title;/**<任务标题*/
@property(nonatomic,copy)NSString*content;/**<任务内容*/
@property(nonatomic,assign)int importance;/**<重要度  0-普通 1- 重要*/
@property(nonatomic,copy)NSString*memo;/**<备注*/
@property(nonatomic,copy)NSString*remindmsg;/**<提醒信息*/
@property(nonatomic,copy)NSString*endtime;/**<截止时间*/
@property (nonatomic, assign) int type; /**<区分是否普通1-普通任务 2- 快捷任务*/
@property(nonatomic,copy)NSString*participants;/**<参与人数组*/
@property(nonatomic,copy)NSString*leaders;/**<负责人数组*/
@property(nonatomic,copy)NSString*createid;/**<用户id*/
@property(nonatomic,copy)NSString*companyid;/**<公司id*/
@property(nonatomic,copy)NSString*ID;/**<自己生成的uuid*/
@property(nonatomic,copy)NSString*updatetime;//更新时间字段
-(void)initWithLM:(RenwuLM*)lm;

@end
