//
//  ZiXunSingleCommentModel.m
//  Zipingguo
//
//  Created by sunny on 15/11/6.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunSingleCommentModel.h"

@implementation ZiXunSingleCommentModel
- (void)bindModelWithSM:(ZiXunSingleCommentSM *)sm{
    self.createname = sm.createname;
    self.relusername = sm.relusername;
    self.createid = sm.createid;
    self.content = sm.content;
    self.commentID = sm.commentID;
    self.ziXunID = sm.ziXunID;
    self.createtime = sm.createtime;
    self.isreply = sm.isreply;
    self.topparid = sm.topparid;
    self.createurl = sm.createurl;
    self.reluserid = sm.reluserid;
}

@end
