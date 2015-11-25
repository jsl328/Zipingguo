//
//  XiaoxiViewController+Category.h
//  Zipingguo
//
//  Created by jiangshilin on 15/11/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiViewController.h"
#import "XuanzeRenyuanModel.h"
#import "ChatViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "EMCDDeviceManager+Remind.h"
@interface XiaoxiViewController (Category)

- (void)registerBecomeActive;
- (void)didBecomeActive;

- (void)RenyuanShuju:(NSNotification *)not;
- (void)chuangjianDanliao;//创建单聊
- (void)chuangjianQunzuWithGroupid:(NSString *)groupid;//创建群聊
- (NSMutableArray *)loadDataSource;
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation;
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation;
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation;
-(MessageDeliveryState )lastMessageDeliverState:(EMConversation *)conversation;
-(long long)lastMessageTimestampByConversation:(EMConversation *)conversation;
- (WeixinQunzuCellVM *)xinxiMokuai:(WeixinQunzuCellVM *)model EM:(EMConversation *)em;
#pragma mark 群聊数据库model
- (void)qunliaoShujukuMokuai:(WeixinQunzuCellVM *)model EMGroup:(EMGroup *)group EM:(EMConversation *)em;
#pragma mark 群聊网络model
- (void)qunliaoWangluoMokuai:(WeixinQunzuCellVM *)model EMGroup:(EMGroup *)group EM:(EMConversation *)em;

#pragma mark 单聊数据库model
- (void)danliaoShujukuMokuai:(WeixinQunzuCellVM *)model EM:(EMConversation *)em;

#pragma mark 单聊网络model
- (void)danliaoWangluoMokuai:(WeixinQunzuCellVM *)model EM:(EMConversation *)em;

@end
