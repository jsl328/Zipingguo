//
//  RenWuModel.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenwuData.h"

@interface RenWuModel : NSObject
@property (nonatomic,assign) int isZhongYao;/**<重要度1为普通 2为重要的*/
@property (nonatomic,copy) NSString *renWuName;
@property (nonatomic,copy) NSString *renWuTime;
@property (nonatomic,copy) NSString *renWuNeiRong;
@property (nonatomic,copy) NSString *personName;
@property (nonatomic,copy) NSString *renWuID;
@property (nonatomic,assign) int type;/**<1-正常任务 2-快捷任务*/
@property (nonatomic,assign) BOOL isFinish;/**<任务是否已完成  yes已完成 no 未完成*/
@property (nonatomic,assign) BOOL isMyRenWu;/**<是不是我的任务 yes是我的任务，no我分配的任务*/
- (void)bindData:(RenwuData *)data;
@end
