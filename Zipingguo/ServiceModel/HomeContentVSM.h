//
//  HomeContentVSM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/1.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeContentVDataSM;
@interface HomeContentVSM : NSObject<IAnnotatable>

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSArray *data;

@end

@interface HomeContentVDataSM : NSObject<IAnnotatable>
//模块标识
@property (nonatomic, strong) NSString *module;
//对应模块未读消息数
@property (nonatomic, assign) int unreadnum;
//对应模块最新消息内容
@property (nonatomic, strong) NSString *latestcontent;
//对应模块最新消息产生时间
@property (nonatomic, strong) NSString *latesttime;

@end