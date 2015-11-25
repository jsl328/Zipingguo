//
//  RenWuPingLunSM.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RenWuPingLunData;
@interface RenWuPingLunSM : NSObject<IAnnotatable>

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) RenWuPingLunData *data;

@end

@interface RenWuPingLunData : NSObject<IAnnotatable>

@property (nonatomic, copy) NSString *taskid;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createid;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *isreply;

@property (nonatomic, copy) NSString *createname;

@property (nonatomic, copy) NSString *createimg;

@property (nonatomic, copy) NSString *reluserid;

@property (nonatomic, copy) NSString *topparid;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *relusername;

@end
