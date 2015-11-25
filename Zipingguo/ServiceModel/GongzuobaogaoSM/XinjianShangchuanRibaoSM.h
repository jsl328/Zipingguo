//
//  XinjianShangchuanRibaoSM.h
//  Lvpingguo
//
//  Created by linku on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class FujianDataModel;
@interface XinjianShangchuanRibaoSM : NSObject<IAnnotatable>
@property (copy, nonatomic) NSString *papername;//工作报告名称标题
@property (nonatomic) int papertype;//工作报告类型，1-日报-2-周报-3-月报
@property (copy, nonatomic) NSString *createtime;//创建日期，可为空，为空默认为今天，且该日期不可以大于今天
@property (copy, nonatomic) NSString *summary;//当期总结
@property (copy, nonatomic) NSString *plan;//下期计划
@property(nonatomic,retain)NSArray*approveruserids;//批阅人的编号数组
@property(nonatomic,retain)NSArray*ccuserids;//抄送人的编号数组
@property (copy, nonatomic) NSString *createid;//创建人

@property (copy, nonatomic) NSString *companyid;//创建人所在公司id
@property (copy, nonatomic) NSString *deptid;//创建人所在部门id


//@property (retain, nonatomic) NSArray *dailyUsers;

@property (nonatomic,retain)NSArray * annexlist;//附件列表
@end


@interface FujianDataModel : NSObject<IAnnotatable>
@property (copy, nonatomic) NSString *filename;//文件名称，若上传附件该字段不为空
@property (copy, nonatomic) NSString *fileurl;//文件url地址，若上传附件改字段不为空
@property (copy, nonatomic) NSString *filesize;//文件大小，若上传附件改字段不为空


@end