//
//  ZiXunLeiBieSM.h
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

#define ZiXun_zuiXinID @"ziXun_zuiXinID"
#define ZiXun_shouCangID @"ziXun_shouCangID"

@interface ZiXunLeiBieSM : NSObject <IAnnotatable>
@property (nonatomic,retain) NSString * titleID;
/// 标题
@property (nonatomic,retain) NSString * title;
///状态，启用或不启用
@property (nonatomic,assign) int status;
@property (nonatomic,retain) NSString * createid;
@property (nonatomic,retain) NSString * createtime;
@property (nonatomic,retain) NSString * companyid;
@property (nonatomic,copy) NSString *sort;

+ (ZiXunLeiBieSM *)getZiXunSMWithTitle:(NSString *)titleName;
@end
