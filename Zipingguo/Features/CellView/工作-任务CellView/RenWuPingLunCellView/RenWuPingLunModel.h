//
//  RenWuPingLunModel.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenWuPingLunModel : NSObject

@property (nonatomic,copy) NSString *commentsID;/**<评论的ID*/
@property (nonatomic,copy) NSString *content;/**<评论内容*/
@property (nonatomic,copy) NSString *pingLunPersonName;/**<pingLun人的name*/
@property (nonatomic,copy) NSString *personID;/**<pingLun人的ID*/
@property (nonatomic,copy) NSString *headerUrl;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) NSString *isreply;
@property (nonatomic, copy) NSString *topparid;
@property (nonatomic,copy) NSString *bName;/**<被@的名字*/
@property (nonatomic, copy) NSString *reluserid;/**<被评论人的id*/

@end
