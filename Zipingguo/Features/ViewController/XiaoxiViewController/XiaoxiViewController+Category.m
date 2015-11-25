//
//  XiaoxiViewController+Category.m
//  Zipingguo
//
//  Created by jiangshilin on 15/11/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiViewController+Category.h"

@implementation XiaoxiViewController (Category)

- (void)registerBecomeActive{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
- (void)didBecomeActive{
    [self reloadData];
}

#pragma mark @人员数据
- (void)RenyuanShuju:(NSNotification *)noto{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    
    self.xuanzhongArray = [@[] mutableCopy];
    NSDictionary *dict = [noto userInfo];
    self.xuanzhongArray = [dict objectForKey:@"xuanzhongArray"];
    NSString *groupid = [dict objectForKey:@"groupId"];
    if (self.xuanzhongArray.count == 1) {
        [self chuangjianDanliao];
    }else{
        [self chuangjianQunzuWithGroupid:groupid];
    }
}

#pragma mark 创建单聊
- (void)chuangjianDanliao{
    //发起聊天
    for (XuanzeRenyuanModel *renyuanModel in self.xuanzhongArray) {
        ChatViewController *chatView =[[ChatViewController alloc]initWithChatter:[renyuanModel.personsSM.userid substringToIndex:20] isGroup:NO];
        chatView.name = renyuanModel.personsSM.name;
        chatView.isLiaotian = YES;
        chatView.hidesBottomBarWhenPushed = YES;
        chatView.Renyuanid = renyuanModel.personsSM.userid;
        chatView.phonto = renyuanModel.personsSM.imgurl;
        [self.navigationController pushViewController:chatView animated:YES];
    }
}

#pragma mark 创建群聊
- (void)chuangjianQunzuWithGroupid:(NSString *)groupid{
    NSMutableArray *Nametemp =[@[] mutableCopy];
    NSMutableArray *IDtemp=[@[] mutableCopy];
    NSMutableArray *touxiangArray=[@[] mutableCopy];
    NSMutableArray *temp =[NSMutableArray arrayWithCapacity:0];
    for (XuanzeRenyuanModel *renyuanModel in self.xuanzhongArray) {
        //name
        [Nametemp addObject:renyuanModel.personsSM.name.length?renyuanModel.personsSM.name:@"AA"];
        //id number
        [touxiangArray addObject:renyuanModel.personsSM.imgurl];
        [IDtemp addObject:[[renyuanModel.personsSM.userid substringToIndex:20] lowercaseString]];
        //移除掉自己
        if (![renyuanModel.personsSM.userid isEqualToString:[AppStore getYongHuID]]) {
            //移除掉自己
            [temp addObject:renyuanModel.personsSM.name.length?renyuanModel.personsSM.name:@"AA"];
        }
    }
    
    ChatViewController *chat=[[ChatViewController alloc]initWithChatter:groupid isGroup:YES];
    chat.name = [Nametemp componentsJoinedByString:@"、"];
    chat.hidesBottomBarWhenPushed = YES;
    chat.idArray =IDtemp;
    chat.nameArray = Nametemp;
    chat.imageUrlArray = touxiangArray;
    //移除掉自己
    [chat sendTextMessage:[NSString stringWithFormat:@"%@邀请%@加入了群聊", [AppStore getYongHuMing],[temp componentsJoinedByString:@","]] withCreate:YES];
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark 得到最后消息的发送状态
-(MessageDeliveryState )lastMessageDeliverState:(EMConversation *)conversation
{
    EMMessage *lastMessage = [conversation latestMessage];
    MessageDeliveryState state = lastMessage.deliveryState;
    return state;
}

#pragma mark - 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return ret;
}

#pragma mark - 得到最后消息时间矬
-(long long)lastMessageTimestampByConversation:(EMConversation *)conversation
{
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage){
        return  lastMessage.timestamp;
    }
    return -1;
}

#pragma mark - 未读消息
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = [conversation unreadMessagesCount];
    return  ret;
}

#pragma mark  - 得到最后留言消息
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[语音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    return ret;
}

#pragma mark 数据排序
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSMutableArray *conSessions = [NSMutableArray array];
    NSArray *conversations =[[EaseMob sharedInstance].chatManager conversations];
    //内存中的sessions
    for (EMConversation *em  in conversations) {
        [conSessions addObject:em];
    }
    
    //数据库中的seesions
    NSArray *dbCons = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    for (EMConversation *db in dbCons) {
        if (![conSessions containsObject:db]) {
            [conSessions addObject:db];
        }
    }
    
    NSArray* sorte = [conSessions sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

#pragma mark 信息model
- (WeixinQunzuCellVM *)xinxiMokuai:(WeixinQunzuCellVM *)model EM:(EMConversation *)em{
    if ([em.chatter isEqualToString:@"00000100000000000000"]) {
        model.name = @"审批";
        model.touxiangStr = @"审批icon2.png";
    }
    if ([em.chatter isEqualToString:@"00000200000000000000"]) {
        model.name = @"资讯";
        model.touxiangStr = @"资讯icon2.png";
    }
    if ([em.chatter isEqualToString:@"00000300000000000000"]) {
        model.name = @"通知";
        model.touxiangStr = @"通知icon2.png";
    }
    if ([em.chatter isEqualToString:@"00000400000000000000"]) {
        model.name = @"任务";
        model.touxiangStr = @"任务icon2.png";
    }
    if ([em.chatter isEqualToString:@"00000500000000000000"]) {
        model.name = @"工件报告";
        model.touxiangStr = @"工作报告icon2.png";
    }
    model.chatter =em.chatter;
    model.renshu =@"1";
    model.xinxi = YES;
    return model;
}

#pragma mark 单聊数据库model
- (void)danliaoShujukuMokuai:(WeixinQunzuCellVM *)model EM:(EMConversation *)em{
    for (YonghuInfoDB *db in self.yonghuArray) {
        if ([[[db.userid substringToIndex:20] lowercaseString] isEqualToString:em.chatter]) {
            model.userid =db.userid;
            model.chatter =em.chatter;
            model.chatType = eConversationTypeChat;
            model.renshu =@"1";
            model.name = db.name;
            
            if (!db.imgurl||!db.imgurl.length) {
                model.touxiangStr = @"头像80.png";
            }else{
                model.touxiangStr = db.imgurl;
            }
            [model.imageArr addObject:db.imgurl];
            [model.nameArr addObject:db.name];
            
            [model.idArr addObject:db.userid];
            
            [self tihuanMaopaoPaixu:model EMConversation:em];
        }
    }
}

#pragma mark 单聊网络model
- (void)danliaoWangluoMokuai:(WeixinQunzuCellVM *)model EM:(EMConversation *)em{
    [ServiceShell getUserinfoByHxnameWithAppIds:em.chatter usingCallback:^(DCServiceContext *serverLet, ResultModelOfUserinfoByHxnameSM *results) {
        for (UserinfoByHuanxinSM *sm in results.data) {
            
            UserinfoByHuanxinSM *SM  = [[UserinfoByHuanxinSM alloc]init];
            
            model.userid = SM._id;
            model.chatter =em.chatter;
            model.chatType = eConversationTypeChat;
            model.renshu =@"1";
            model.name =!sm.name.length?@"iOS开发":sm.name;
            
            //jsl..
            SM._id= sm._id;
            SM.name = !sm.name.length?@"iOS开发者":sm.name;
            SM.phone = sm.phone;
            if (!sm.imgurl||!sm.imgurl.length) {
                SM.imgurl =@"头像80.png";
                model.touxiangStr = @"头像80.png";
            }else{
                SM.imgurl = sm.imgurl;
                model.touxiangStr = sm.imgurl;
            }
            
            //jsl
            [model.imageArr addObject:SM.imgurl];
            
            [model.nameArr addObject:SM.name];
            [model.idArr addObject:SM._id];
            [self tihuanMaopaoPaixu:model EMConversation:em];
        }
        //
        [_tableView reloadData];
    }];
}

#pragma mark 群聊数据库model
- (void)qunliaoShujukuMokuai:(WeixinQunzuCellVM *)model EMGroup:(EMGroup *)group EM:(EMConversation *)em{
    
    for (YonghuInfoDB *db in self.yonghuArray) {
        for (NSString *chatter in group.occupants) {
            if ([[[db.userid substringToIndex:20] lowercaseString] isEqualToString:[chatter lowercaseString]]) {
                model.chatter =em.chatter;
                model.groupid =em.chatter;
                model.chatType = eConversationTypeGroupChat;
                model.chatter =em.chatter;
                model.groupid = em.chatter;
                model.userid =nil;
                model.renshu =[NSString stringWithFormat:@"%d",(int)group.occupants.count];
                
                if (!db.imgurl||!db.imgurl.length) {
                    model.touxiangStr = @"头像80.png";
                }else{
                    model.touxiangStr = db.imgurl;
                }
                
                [model.imageArr addObject:db.imgurl];
                [model.nameArr addObject:db.name];
                [model.idArr addObject:db.userid];
                
                model.name = !group.groupSubject||!group.groupSubject.length?[model.nameArr componentsJoinedByString:@"、"]:group.groupSubject;
                
                break;
            }
        }
    }
}

#pragma mark 群聊网络model
- (void)qunliaoWangluoMokuai:(WeixinQunzuCellVM *)model EMGroup:(EMGroup *)group EM:(EMConversation *)em{
    [ServiceShell getUserinfoByHxnameWithAppIds:[group.occupants componentsJoinedByString:@","] usingCallback:^(DCServiceContext *service, ResultModelOfUserinfoByHxnameSM *results) {
        for (UserinfoByHuanxinSM *sm in results.data) {
            
            model.chatter =em.chatter;
            model.groupid =em.chatter;
            model.userid =nil;
            model.chatType = eConversationTypeGroupChat;
            model.renshu =[NSString stringWithFormat:@"%d",(int)group.occupants.count];
            //jsl...
            if (!sm.imgurl||!sm.imgurl.length) {
                model.touxiangStr = @"头像80.png";
            }else{
                model.touxiangStr = sm.imgurl;
            }
            
            [model.imageArr addObject:model.touxiangStr];
            
            [model.nameArr addObject:sm.name];
            
            [model.idArr addObject:sm._id];
            
            model.name = [model.nameArr componentsJoinedByString:@"、"];
            
        }
        [self tihuanMaopaoPaixu:model EMConversation:em];
        [_tableView reloadData];
    }];
}

@end
