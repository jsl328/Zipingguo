//
//  ZiXunListSM.h
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class ZiXunListSubSM;

@interface ZiXunListSM : NSObject<IAnnotatable>
/// 轮播广告
@property (nonatomic,strong) NSArray *data;
/// 列表数据
@property (nonatomic,strong) NSArray * data1;
@end

@interface ZiXunListSubSM : NSObject<IAnnotatable>

@property (nonatomic,retain) NSString * ziXunID;
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * content;
@property (nonatomic,retain) NSString * createid;
@property (nonatomic,retain) NSString * createtime;
@property (nonatomic,assign) int status;
@property (nonatomic,retain) NSString * imgurl;
@property (nonatomic,retain) NSString * infotypeid;
@property (nonatomic,retain) NSString * companyid;
@property (nonatomic,assign) int ishomepage;
@property(nonatomic,assign)int readamount;

@property (nonatomic,retain) NSString * time;

@end