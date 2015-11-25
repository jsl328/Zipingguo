//
//  ResultModelOfIListOfNoticeSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-2.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class NoticeSM;
@class NoticeAnnexsSM;
@interface ResultModelOfIListOfNoticeSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) NSArray *data1;

@end

@interface NoticeSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *createtime;
@property (retain, nonatomic) NSString *createtid;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *companyid;
@property (nonatomic) int deleteflay;
@property (retain, nonatomic) NSArray *noticeAnnexs;
@property (nonatomic) int isRead;
@property (nonatomic) int isCollect;
@property (nonatomic, strong) NSString *adminnotice;
@property (nonatomic,strong) NSString* time;

@end

@interface NoticeAnnexsSM : NSObject<IAnnotatable>
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *noticeid;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *fileurl;
@property (nonatomic, strong) NSString *formatsize;
@property (nonatomic) float filesize;
@property (nonatomic) int deleteflag;
@end