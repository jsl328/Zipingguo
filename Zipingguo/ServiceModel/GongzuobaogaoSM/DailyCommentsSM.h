//
//  DailyCommentsSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface DailyCommentsSM : NSObject<IAnnotatable>

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * content;//评论内容
@property (nonatomic, copy) NSString * createid;//评论人id
@property (nonatomic, copy) NSString * createtime;//评论时间
@property (nonatomic, copy) NSString * dailypaperid;
@property (nonatomic, copy) NSString * isreply;//0-首次评论，其他的是上级评论id
@property (nonatomic, copy) NSString * topparid;//顶级评论的id，首次评论记录与id相同
@property (nonatomic, copy) NSString * createname;//创建人姓名
@property (nonatomic, copy) NSString * createimgurl;//创建人头像
@property (nonatomic, copy) NSString * createimg;
@property (nonatomic, copy) NSString * relusername;

@end



