//
//  ZiXunCommentModel.m
//  Zipingguo
//
//  Created by sunny on 15/11/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunCommentModel.h"
#import "ZiXunSingleCommentModel.h"
#import "NSDate+Compare.h"

@implementation ZiXunCommentModel


- (void)bindModelWithSM:(ZiXunCommentSM *)sm{
    self.createname = sm.createname;
    self.relusername = sm.relusername;
    self.createid = sm.createid;
    self.content = sm.content;
    self.commentID = sm.commentID;
    self.ziXunID = sm.ziXunID;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:sm.createtime];
    self.createtime = [date formatted];
    self.isreply = sm.isreply;
    self.topparid = sm.topparid;
    self.createurl = sm.createurl;
    self.reluserid = sm.reluserid;
    NSMutableArray *tempArray = [@[] mutableCopy];
    for (ZiXunSingleCommentSM *singleCommentSM in sm.childComments) {
        ZiXunSingleCommentModel *model = [[ZiXunSingleCommentModel alloc] init];
        [model bindModelWithSM:singleCommentSM];
        [tempArray addObject:model];
    }
    self.childComments = tempArray;
    
}
@end
