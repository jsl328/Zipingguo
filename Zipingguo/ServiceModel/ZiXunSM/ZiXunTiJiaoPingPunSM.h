//
//  ZiXunTiJiaoPingPunSM.h
//  Zipingguo
//
//  Created by sunny on 15/11/5.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "ZiXunPingLunResultSM.h"


@interface ZiXunTiJiaoPingPunSM : NSObject<IAnnotatable>

@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,strong) ZiXunSingleCommentSM *data;

@end

//@interface ZiXunTiJiaoPingPunReturnSM : NSObject <IAnnotatable>
///// 资讯评论ID
//@property (nonatomic,copy) NSString *commentID;
///// 资讯ID
//@property (nonatomic,copy) NSString *ziXunID;
///// 评论内容
//@property (nonatomic,copy) NSString *content;
///// 创建人id
//@property (nonatomic,copy) NSString *createid;
///// 创建时间
//@property (nonatomic,copy) NSString *createtime;
///// 上级评论id，首次评论为0
//@property (nonatomic,copy) NSString *isreply;
///// 顶级评论id，首次评论与当前评论id相等
//@property (nonatomic,copy) NSString *topparid;
///// 创建人姓名
//@property (nonatomic,copy) NSString *createname;
//@property (nonatomic,copy) NSString *createurl;
//@property (nonatomic,copy) NSString *reluserid;
//@property (nonatomic,copy) NSString *relusername;
//
//
//@end
