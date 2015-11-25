//
//  WeixinQunzuVM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCCellHeightDataSource.h"
#import "UserinfoByHuanxinSM.h"
#import "DCListBoxItemDataSource.h"
@protocol ListBoxDeleteCellDelegate <NSObject>
-(void)deleteCell;
@end

@interface WeixinQunzuCellVM : NSObject
@property (nonatomic) float cellHeight;
@property (nonatomic, assign) id <ListBoxDeleteCellDelegate> delegate;
@property (nonatomic, assign) MessageDeliveryState messageState;
@property (nonatomic, assign) EMConversationType chatType;
@property (nonatomic, strong) NSString *userid;//单聊的用户id;
@property (nonatomic, strong) NSString *groupid;//群组id;
@property (nonatomic, strong) NSString *touxiangStr;//单聊的用户头像;

@property (nonatomic, strong) NSArray *huanxinSM;//成员信息
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *idArr;
@property (nonatomic, strong) NSString *chatter;//会话唯一标示

@property (nonatomic, strong) NSString *name;//最后一条消息由谁发出
@property (nonatomic, strong) NSString *lastLiuyan;//最后一跳留言
@property (nonatomic, strong) NSString *shijian;//最后一跳留言时间
@property (nonatomic,assign) int liuyanCount;//未读消息数量
@property (nonatomic,strong) NSString *renshu;//人数

@property (nonatomic, assign) BOOL xinxi;

/*!
 @property
 @brief 消息发送或接收的时间
 */
@property (nonatomic) long long timestamp;

@end
