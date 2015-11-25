//
//  CustomTabbarController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface CustomTabbarController : UITabBarController<EMChatManagerDelegate,EMCallManagerDelegate>
{
    EMConnectionState _connectionState;
}
- (void)jumpToChatList;
- (void)setupUntreatedApplyCount;
- (void)networkChanged:(EMConnectionState)connectionState;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
@end
