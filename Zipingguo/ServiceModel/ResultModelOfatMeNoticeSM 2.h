//
//  ResultModelOfatMeNoticeSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ResultModelOfatMeNoticeSM : NSObject<IAnnotatable>
@property (nonatomic) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end

@interface AtMeNoticeSM : NSObject<IAnnotatable>

@property (nonatomic) NSString *_id;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic) int moduletype;
@property (nonatomic, strong) NSString *baseid;
@property (nonatomic, strong) NSString *commentid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createid;
@property (nonatomic, strong) NSString *createname;
@property (nonatomic, strong) NSString *createurl;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic) int havepower;
@property (nonatomic) int papertype;
@property (nonatomic, strong) NSString * time;
@end