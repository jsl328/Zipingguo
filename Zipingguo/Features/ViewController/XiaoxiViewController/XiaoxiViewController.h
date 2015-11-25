//
//  XiaoxiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"
#import "XiaoxiCell.h"
#import "XiaoxiModel.h"
#import "EaseMob.h"
@class WeixinQunzuCellVM;
@interface XiaoxiViewController : RootViewController<UIAlertViewDelegate,EMChatManagerDelegate>

@property (nonatomic, strong) NSMutableArray *xuanzhongArray;//选中array
@property (nonatomic, strong) NSMutableArray *yonghuArray;//用户数组

@property (nonatomic, strong) NSMutableArray *subuidArray;;

-(void)reloadData;
- (void)chushihua;
- (void)loadLiaotian;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)ConnectionState;
- (void)tihuanMaopaoPaixu:(WeixinQunzuCellVM *)model EMConversation:(EMConversation *)em;
@end
