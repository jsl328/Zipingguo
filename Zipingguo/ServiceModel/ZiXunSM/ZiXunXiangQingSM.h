//
//  ZiXunXiangQingSM.h
//  Zipingguo
//
//  Created by sunny on 15/10/30.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class ZiXunContentSM;

@interface ZiXunXiangQingSM : NSObject<IAnnotatable>
@property (nonatomic,strong) ZiXunContentSM *data;

@end

@interface ZiXunContentSM : NSObject <IAnnotatable>
@property (nonatomic,retain) NSString * companyid;
@property (nonatomic,retain) NSString * ziXunID;
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * content;
@property (nonatomic,retain) NSString * createid;
@property (nonatomic,retain) NSString * createtime;
@property (nonatomic,assign) int status;
@property (nonatomic,retain) NSString * imgurl;
@property (nonatomic,retain) NSString * infotypeid;

@property (nonatomic,assign) int ishomepage;
@property(nonatomic,assign)int readamount;
/// 注：
@property(nonatomic,retain)NSString*memo;
@property(nonatomic,retain)NSString*source;
@property (nonatomic,assign) int iscollect;
@property(nonatomic,assign)int ispraise;
@property(nonatomic,assign)int praisecount;

@property(nonatomic,assign)int Quduliang;






@property(nonatomic,retain)NSString*time;
@end
