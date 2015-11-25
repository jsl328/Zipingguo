//
//  ChuangjianRenwuSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "RenwuDB.h"

@interface ChuangjianRenwuSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*title;/**<任务标题*/
@property(nonatomic,retain)NSString*content;/**<任务内容*/
@property(nonatomic,assign)int importance;/**<重要度  0-普通 1- 重要*/
@property(nonatomic,retain)NSString*memo;/**<备注*/
@property(nonatomic,retain)NSString*remindmsg;/**<提醒信息*/
@property(nonatomic,retain)NSString*endtime;/**<截止时间*/
@property (nonatomic, assign) int type; /**<区分是否普通  1-普通任务 2- 快捷任务*/
@property(nonatomic,retain)NSArray*participants;/**<参与人数组*/
@property(nonatomic,retain)NSArray*leaders;/**<负责人数组*/
//@property(nonatomic,retain)NSArray*imgstrs;
//@property(nonatomic,retain)NSArray*taskitems;
@property(nonatomic,retain)NSString*createid;/**<用户id*/
@property(nonatomic,retain)NSString*companyid;/**<公司id*/
@property(nonatomic,retain)NSString*ID;/**<自己生成的uuid*/
- (void)setSMWithDB:(RenwuDB *)db;
@end
