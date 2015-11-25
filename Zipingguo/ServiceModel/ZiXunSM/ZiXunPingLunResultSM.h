//
//  ZiXunPingLunResultSM.h
//  Zipingguo
//
//  Created by sunny on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class ZiXunCommentSM;
@class ZiXunSingleCommentSM;

@interface ZiXunPingLunResultSM : NSObject<IAnnotatable>
/// 返回是否成功 0-成功 1-失败
@property (nonatomic,assign) int status;
/// 成功失败提示消息
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,strong) NSArray *data;
@end

@interface ZiXunCommentSM : NSObject<IAnnotatable>
/// 资讯评论ID
@property (nonatomic,copy) NSString *commentID;
/// 资讯ID
@property (nonatomic,copy) NSString *ziXunID;
/// 评论内容
@property (nonatomic,copy) NSString *content;
/// 创建人id
@property (nonatomic,copy) NSString *createid;
/// 创建时间
@property (nonatomic,copy) NSString *createtime;
/// 上级评论id，首次评论为0
@property (nonatomic,copy) NSString *isreply;
/// 顶级评论id，首次评论与当前评论id相等
@property (nonatomic,copy) NSString *topparid;
/// 创建人姓名
@property (nonatomic,copy) NSString *createname;
@property (nonatomic,copy) NSString *createurl;
@property (nonatomic,copy) NSString *reluserid;
@property (nonatomic,copy) NSString *relusername;
/// 顶级评论的所有子评论
@property (nonatomic,strong) NSMutableArray *childComments;
@end

@interface ZiXunSingleCommentSM : NSObject <IAnnotatable>
/// 资讯评论ID
@property (nonatomic,copy) NSString *commentID;
/// 资讯ID
@property (nonatomic,copy) NSString *ziXunID;
/// 评论内容
@property (nonatomic,copy) NSString *content;
/// 创建人id
@property (nonatomic,copy) NSString *createid;
/// 创建时间
@property (nonatomic,copy) NSString *createtime;
/// 上级评论id，首次评论为0
@property (nonatomic,copy) NSString *isreply;
/// 顶级评论id，首次评论与当前评论id相等
@property (nonatomic,copy) NSString *topparid;
/// 创建人姓名
@property (nonatomic,copy) NSString *createname;
@property (nonatomic,copy) NSString *createurl;
@property (nonatomic,copy) NSString *reluserid;
@property (nonatomic,copy) NSString *relusername;
@end
