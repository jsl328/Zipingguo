//
//  ServiceShell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LService.h"
#import "DengluSM.h"
#import "ResultMode.h"
#import "ResultModelOfCompanyDeptsSM.h"
#import "ResultModelOfSubDeptAndMemberUserSM.h"
#import "ResultModelOfDeptPersonsSM.h"
#import "ResultModelOfCompanyPersonsSM.h"
#import "ResultModelOfUserinfoByHxnameSM.h"
#import "ResultModelShangchuanWenjianSM.h"
#import "ResultModelOfApplyApprovalSM.h"
#import "ResultModelOfApplyDetailSM.h"
#import "ResultMode.h"
#import "ResultModelOfGetApplicationformSM.h"
#import "ResultModelOfAllFlowSM.h"
#import "CreateApplySM.h"
#import "MapsTiaoXiuRSM.h"
#import "ResultModelOfIListOfNoticeSM.h"
#import "ResultModelOfNoticeDetailSM.h"
#import "ResultModelOfatMeNoticeSM.h"
#import "ResultModelOfGetOptionSM.h"
#import "PublishDynamicSM.h"
#import "ResultModelOfPersonDetailSM.h"
#import "ResultModelOfIListOfDynamicSM.h"
#import "ResultModelOfGetCodeSM.h"
#import "HPResultSM.h"
#import "ResultModelOfFeedbackSM.h"
#import "HomeContentVSM.h"
#import "Denglu2SM.h"
#import "ResultModelOfcheckUpdateCompanyPersonsSM.h"
#import "YaoqingYuangongSM.h"
#import "FirstLoginPerfectInfoSM.h"
#import "UpdateCompanyPersonsSM.h"
@interface ServiceShell : NSObject
//正式登录
+ (void)DengLu:(NSString *)phoneNumber Password:(NSString *)pwd LoginType:(NSString *)type NetType:(NSString *)netType Version:(NSString *)version usingCallback:(void (^)(DCServiceContext*, Denglu2SM*))callback;


/*!
 登录
 */
+ (void)DengLu:(NSString *)phoneNumber Password:(NSString *)pwd Companyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, DengluSM*))callback;

/*!
 获取用户详情
 */
+(void) getUserDetailWithYonghuID:(NSString *) ID Sessionid:(NSString *)sessionid usingCallback:(void (^)(DCServiceContext*, DengluSM*)) callback;

/*!
 修改个人信息
 */
+(void) getupdateUserAttrWithKey:(NSString *)key Value:(NSString *)value Id:(NSString *)id usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 重置密码-设置新密码
 */
+(void) getResetPwdWithID:(NSString *)id Password:(NSString *)password oldPassword:(NSString *)oldPassword usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 验证码
 */
+(void) employeeGetCodeWithPhone:(NSString *)phone Status:(NSString *)status usingCallback:(void (^)(DCServiceContext*, ResultModelOfGetCodeSM*)) callback;


/*!
 验证老密码
 */
+(void) getResetPwdCheckOldPwdWithID:(NSString *)_id oldPassword:(NSString *)oldPassword usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 检验手机验证码
 */
+(void) employeeGetCodeWithPhone:(NSString *)phone Code:(NSString *)code usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 重置手机号
 */
+(void) getResetPhoneWithID:(NSString *)id Phone:(NSString *)phone OldPassword:(NSString *)oldPassword usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 通讯录列表
 */
+(void) getCompanyPersonsWithCompanyid:(NSString*)companyid Start:(int)start Count:(int)count Priorityyouxianji:(BOOL)youxianji usingCallback:(void (^)(DCServiceContext*, ResultModelOfCompanyPersonsSM*)) callback;

/*!
 部门列表
 */
+(void) getCompanyDeptsWithCompanyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfCompanyDeptsSM*)) callback;

/*!
 全部部门列表
 */
+(void) getCompanyDeptsListWithCompanyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfCompanyDeptsSM*)) callback;

/*!
 判断通讯录是否要更新
 */
+ (void)getcheckUpdateCompanyPersonsWithUpdateCompanyPersonsSM:(UpdateCompanyPersonsSM *)personsSM Priorityyouxianji:(BOOL)youxianji usingCallback:(void(^)(DCServiceContext*,ResultModelOfcheckUpdateCompanyPersonsSM*))callback;

/*!
 子部门&成员接口
 */
+(void) getCompanyDeptlistWithParid:(NSString *)parid Memo:(int)memo usingCallback:(void (^)(DCServiceContext*, ResultModelOfSubDeptAndMemberUserSM*)) callback;

/*!
 部门下的同事列表
 */
+(void) getDeptPersonsWithID:(NSString *)_id usingCallback:(void (^)(DCServiceContext*, ResultModelOfDeptPersonsSM*)) callback;

/*!
 获取ids的个人资料信息
 */
+(void) getUserinfoByHxnameWithAppIds:(NSString *) ids usingCallback:(void (^)(DCServiceContext*, ResultModelOfUserinfoByHxnameSM*)) callback;

/*!
 上传文件
 */
+(void) getUploadWithImgNmae:(NSString *) imgName ImgStr:(NSString *)imgStr usingCallback:(void (^)(DCServiceContext*, ResultModelShangchuanWenjianSM*)) callback;

/*!
 审批列表
 */
+(void) getApplyApprovalWithStart:(int)start Count:(int)count Dealid:(NSString *)dealid usingCallback:(void (^)(DCServiceContext*, ResultModelOfApplyApprovalSM*)) callback;

/*!
 申请列表
 */
+(void) getApplyListWithStart:(int)start Count:(int)count Dealid:(NSString *)dealid usingCallback:(void (^)(DCServiceContext*, ResultModelOfApplyApprovalSM*)) callback;

/*!
 申请详情与审批详情
 */
+(void) getApplyListWithID:(NSString *)id usingCallback:(void (^)(DCServiceContext*, ResultModelOfApplyDetailSM*)) callback;

/*!
 创建申请列表
 */
+(void) getAllFlowWithCompanyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfAllFlowSM*)) callback;

/*!
 批准和不批准
 */

+(void) getPassWithdealid:(NSString *)dealid withStatus:(int )status withApplyid:(NSString *)applyid  withcontent:(NSString *)content  withhandwriteurl:(NSString *)url withapssid:(NSString *)passid usingCallback:(void (^)(DCServiceContext *, ResultMode *))callback;

/*!
 批准转交给其他人
 */
+(void) getPassWithdealid:(NSString *)dealid withStatus:(int)status1 withApplyid:(NSString *)applyid  withcontent:(NSString *)content withIDarray:(NSString*)idString withPeopleImageUrl:(NSString *)urlStr usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 申请类型列表
 */
+(void) getAllFlowWithflowid:(NSString *)flowid usingCallback:(void (^)(DCServiceContext*, ResultModelOfGetApplicationformSM*)) callback;

/*!
 提交请假申请
 */
+(void) getApplyListWithCreateApply:(CreateApplySM *)apply usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;
/*!
 提交调休申请
 */
+(void) getApplyListWithCreateApplyTiaoXiu:(MapsTiaoXiuRSM *)apply usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 删除申请
 */
+(void)DeleteApplyWithApplyid:(NSString *)applyid usingCallback:(void (^)(DCServiceContext*,ResultMode *))callback;

/*!
 通知列表
 */
+(void) getNoticeWithCompanyid:(NSString *)companyid Userid:(NSString *)userid Start:(int) start Count:(int)count  usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfNoticeSM*)) callback;

/*!
 获取提交我的
 */
+(void) getNoticeWithUserid:(NSString *)userid Start:(int) start Count:(int)count usingCallback:(void (^)(DCServiceContext*, ResultModelOfatMeNoticeSM*)) callback;

/*!
 通知详情
 */
+(void) getNoticeDetailWithID:(NSString *)id Userid:(NSString *)userid usingCallback:(void (^)(DCServiceContext*, ResultModelOfNoticeDetailSM*)) callback;

/*!
 获得新消息提醒设置
 */
+(void) getOptionWithUserid:(NSString *)userid UserCompanyid:(NSString *)usercompanyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfGetOptionSM*)) callback;

/*!
 新消息提醒设置
 */
+(void) getUsermsgOptionWithUserid:(NSString *)userid Msgoptionid:(NSString *)msgoptionid Status:(NSString *)status usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 发表动态
 */
+(void) getPublishDynamicWithCreateid:(PublishDynamicSM *)publishDynamicSN usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 部门下的联系人信息
 */
+(void) getPersonDetailWithUserid:(NSString *)userid usingCallback:(void (^)(DCServiceContext*, ResultModelOfPersonDetailSM*)) callback;

/*!
 动态列表
 */
+(void) getDynamicWithstart:(int) start Count:(int)count companyid:(NSString *)companyid Createid:(NSString *)createid Groupid:(NSString *)groupid Type:(int)dongtaiType usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 @我的动态
 */
+(void) getAtMeDynamicWithstart:(int) start Count:(int)count Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 我关注的动态
 */
+(void) getMyAttentionDynDynamicWithstart:(int) start Count:(int)count Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 我的动态
 */
+(void) getCompanyOrMyDynamicWithstart:(int) start Count:(int)count  Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 我收藏的动态列表
 */
+(void) getCollectionDynamicListWithstart:(int) start Count:(int)count  Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 关注
 */
+(void) getAttentionWithCreateid:(NSString *)createid Relid:(NSString *)relid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 取消关注
 */
+(void) getCancelAttentionWithCreateid:(NSString *)createid Relid:(NSString *)relid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;


/*!
 赞动态
 */
+(void) getDypraiseDynamicWithDynamicid:(NSString *)dynamicid Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 取消赞动态
 */
+(void) getDypraiseDynamicWithCancelPraiseDynamicid:(NSString *)dynamicid Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 评论动态
 */
+(void) getDycommentDynamicWithCreateid:(NSString *)createid Content:(NSString *)content Dynamicid:(NSString *)dynamicid Isreply:(NSString *)isreply Topparid:(NSString *)topparid IDS:(NSString *)ids usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 删除动态
 */
+(void) getDelMyDynamicWithID:(NSString *)Id Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;


/*!
 动态详情
 */
+(void) getDynamicDetailWithID:(NSString *) Id Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;

/*!
 收藏动态
 */
+(void) getCollectDynamicWithUserid:(NSString *)userid Dynamicid:(NSString *)dynamicid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 取消收藏动态
 */
+(void) getCancelcollectCollectDynamicWithUserid:(NSString *)userid Dynamicid:(NSString *)dynamicid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

/*!
 动态删除评论
 */

+(void)DydelWithCreateid:(NSString *)createid ID:(NSString *)id Dynamicid:(NSString *)dynamicid  usingCallback:(void (^)(DCServiceContext*,ResultMode *))callback;

/*!
 是否是管理员
 */
+ (void)grIsAdminWithID:(NSString *)ID Ext3:(NSString *)ext3 usingCallback:(void (^)(DCServiceContext*, HPResultSM*))callback;

/*!
 意见反馈
 */
+ (void)getCreateFeedbackWithID:(NSString *)userid ConTent:(NSString *)content usingCallback:(void(^)(DCServiceContext*,ResultModelOfFeedbackSM*))callback;

/*!
1.17.1	获取消息或工作的最新消息
 */
+ (void)getHomeContentVWithUserid:(NSString *)userid Companyid:(NSString *)companyid Apitype:(NSString*)apitype usingCallback:(void(^)(DCServiceContext*,HomeContentVSM*))callback;

/*!
 1.17.3	查看一条消息提醒数减一
 */
+ (void)getDecreaseReddotWithUserid:(NSString *)userid Key:(NSString *)key usingCallback:(void(^)(DCServiceContext*serviceContext,ResultMode*sm))callback;

/*!
1.17.2	删除消息
 */
+ (void)getMsgToRedWithUserid:(NSString *)userid Module:(NSString*)module usingCallback:(void(^)(DCServiceContext*,ResultMode*))callback;

/*!
 1.17.2	删除通知
 */
+ (void)getMarkNoticeDelWithUserid:(NSString *)userid Noticeid:(NSString*)noticeid usingCallback:(void(^)(DCServiceContext*,ResultMode*))callback;

/*!
 1.17.2	删除@我的通知
 */
+ (void)getAtMeNoticeDelWithcommantatID:(NSString *)commantatid usingCallback:(void(^)(DCServiceContext*,ResultMode*))callback;

/*!
 1.7.11	获取上/下一条审批/申请
 */
+ (void)getPreOrNextApplyWithUserid:(NSString *)userid Createtime:(NSString*)createtime PrveOrNext:(int)prveOrNext Type:(int)type Companyid:(NSString *)companyid usingCallback:(void(^)(DCServiceContext*,ResultModelOfApplyDetailSM*))callback;

@end
