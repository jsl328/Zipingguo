//
//  ResultModelOfIListOfDynamicSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-1.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class AllDynamicSM;
@class DynamicSM;
@class DypraisesSM;
@class DycommentsSM;
@class DyimgsSM;
@class DyaboutusrsSM;
@class DysoundsSM;
@interface ResultModelOfIListOfDynamicSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSArray *data;
@property (nonatomic, strong) AllDynamicSM *dynamicSM;

@property (nonatomic) int data1;
@property (nonatomic) int status;
@property (nonatomic, strong) NSString *msg;

@end

@interface AllDynamicSM : NSObject<IAnnotatable>
@property (retain, nonatomic) DynamicSM *dynamic;
@property (retain, nonatomic) NSArray *dypraises;
@property (retain, nonatomic) NSArray *dycomments;
@property (retain, nonatomic) NSArray *dyimgs;
@property (retain, nonatomic) NSArray *dyaboutusrs;
@property (retain, nonatomic) NSArray *dysounds;
@property (nonatomic) int commentscount;
@property (nonatomic, assign) int iscollect;
@end

@interface DynamicSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *  _id;
@property (retain, nonatomic) NSString *  content;
@property (retain, nonatomic) NSString *  address;
@property (nonatomic) int  positionx;
@property (nonatomic) int  positiony;
@property (retain, nonatomic) NSString *  createid;
@property (retain, nonatomic) NSString *  createurl;
@property (retain, nonatomic) NSString *  createname;
@property (retain, nonatomic) NSString *  createtime;
@property (retain, nonatomic) NSString *  sound;
@property (retain, nonatomic) NSString *  compannyid;
@property (nonatomic) int  deleteflag;
@property (retain, nonatomic) NSString *  imgstrs;
@property (retain, nonatomic) NSString *  atusers;
@property (retain, nonatomic) NSString *  sounds;
@property (nonatomic) int isrelation;
@property (nonatomic) int ispraise;
@property (retain, nonatomic) NSString *  loginId;
@property (retain, nonatomic) NSString *  time;
@end

@interface DypraisesSM : NSObject
@property (retain, nonatomic) NSString *  _id;
@property (retain, nonatomic) NSString *  dynamicid;
@property (retain, nonatomic) NSString *  createid;
@property (retain, nonatomic) NSString *  createtime;
@property (retain, nonatomic) NSString *  createname;
@end

@interface DycommentsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *  _id;
@property (retain, nonatomic) NSString *  content;
@property (retain, nonatomic) NSString *  dynamicid;
@property (retain, nonatomic) NSString *  createid;
@property (retain, nonatomic) NSString *  createtime;
@property (retain, nonatomic) NSString *  createname;
@property (retain, nonatomic) NSString *  createimg;
@property (retain, nonatomic) NSString *  isreply;
@property (retain, nonatomic) NSString *  topparid;
@property (retain, nonatomic) NSString *  reluserid;
@property (retain, nonatomic) NSString *  relusername;
@property (retain, nonatomic) NSString *  time;
@end

@interface DyimgsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *dynamicid;
@property (retain, nonatomic) NSString *imgurl;
@property (retain, nonatomic) NSString *name;
@end

@interface DyaboutusrsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *dynamicid;
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *username;
@end

@interface DysoundsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *dynamicid;
@property (retain, nonatomic) NSString *soundurl;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *spendtime;
@end
