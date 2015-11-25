//
//  ServiceShell.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ServiceShell.h"

@implementation ServiceShell

+ (void)DengLu:(NSString *)phoneNumber Password:(NSString *)pwd LoginType:(NSString *)type NetType:(NSString *)netType Version:(NSString *)version usingCallback:(void (^)(DCServiceContext*, Denglu2SM*))callback{
    [LService request:@"login.action2" with:@[phoneNumber,pwd,type,netType,version] returns:[Denglu2SM class] whenDone:callback];
}

+ (void)DengLu:(NSString *)phoneNumber Password:(NSString *)pwd Companyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, DengluSM*))callback{
    [LService request:@"login.action" with:@[phoneNumber,pwd,companyid] returns:[DengluSM class] whenDone:callback];
}

+(void) getCompanyPersonsWithCompanyid:(NSString*)companyid Start:(int)start Count:(int)count Priorityyouxianji:(BOOL)youxianji usingCallback:(void (^)(DCServiceContext*, ResultModelOfCompanyPersonsSM*)) callback{
    [LService request:@"getCompanyPersons.action" with:@[companyid,[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],[NSNumber numberWithBool:youxianji]] returns:[ResultModelOfCompanyPersonsSM class] whenDone:callback];
}

+(void) getCompanyDeptsWithCompanyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfCompanyDeptsSM*)) callback{
    [LService request:@"getCompanyDepts.action" with:@[companyid] returns:[ResultModelOfCompanyDeptsSM class] whenDone:callback];
}
+(void) getCompanyDeptsListWithCompanyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfCompanyDeptsSM*)) callback{
    [LService request:@"getCompanyDeptlist.action" with:@[companyid] returns:[ResultModelOfCompanyDeptsSM class] whenDone:callback];
}
+ (void)getcheckUpdateCompanyPersonsWithUpdateCompanyPersonsSM:(UpdateCompanyPersonsSM *)personsSM Priorityyouxianji:(BOOL)youxianji usingCallback:(void(^)(DCServiceContext*,ResultModelOfcheckUpdateCompanyPersonsSM*))callback{
    [LService request:@"updateCompanyPersons.action" with:@[personsSM,[NSNumber numberWithBool:youxianji]] returns:[ResultModelOfcheckUpdateCompanyPersonsSM class] whenDone:callback];
}

+(void) getCompanyDeptlistWithParid:(NSString *)parid Memo:(int)memo usingCallback:(void (^)(DCServiceContext*, ResultModelOfSubDeptAndMemberUserSM*)) callback{
    [LService request:@"getSubDeptAndMemberUser.action" with:@[parid,[NSNumber numberWithInt:memo]] returns:[ResultModelOfSubDeptAndMemberUserSM class] whenDone:callback];
}

+(void) getDeptPersonsWithID:(NSString *)_id usingCallback:(void (^)(DCServiceContext*, ResultModelOfDeptPersonsSM*)) callback{
    [LService request:@"getDeptPersons.action" with:@[_id] returns:[ResultModelOfDeptPersonsSM class] whenDone:callback];
}

+(void) getUserinfoByHxnameWithAppIds:(NSString *) ids usingCallback:(void (^)(DCServiceContext*, ResultModelOfUserinfoByHxnameSM*)) callback{
    [LService request:@"getUserinfoByHxuname.action" with:@[ids] returns:[ResultModelOfUserinfoByHxnameSM class] whenDone:callback];
}

+(void) getUploadWithImgNmae:(NSString *) imgName ImgStr:(NSString *)imgStr usingCallback:(void (^)(DCServiceContext*, ResultModelShangchuanWenjianSM*)) callback{
    [LService request:@"Base64UploadServlet" with:@[imgName,imgStr] returns:[ResultModelShangchuanWenjianSM class] whenDone:callback];
}

//jsl...
+(void) getApplyApprovalWithStart:(int)start Count:(int)count Dealid:(NSString *)dealid usingCallback:(void (^)(DCServiceContext*, ResultModelOfApplyApprovalSM*)) callback{
    [LService request:@"getMyApplyApproval.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],dealid] returns:[ResultModelOfApplyApprovalSM class] whenDone:callback];
}


+(void) getApplyListWithStart:(int)start Count:(int)count Dealid:(NSString *)dealid usingCallback:(void (^)(DCServiceContext*, ResultModelOfApplyApprovalSM*)) callback{
    [LService request:@"getMyApplyList.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],dealid] returns:[ResultModelOfApplyApprovalSM class] whenDone:callback];
}

+(void) getApplyListWithID:(NSString *)id usingCallback:(void (^)(DCServiceContext*, ResultModelOfApplyDetailSM*)) callback{
    [LService request:@"getApplyDetail.action" with:@[id] returns:[ResultModelOfApplyDetailSM class] whenDone:callback];
}

+(void) getAllFlowWithCompanyid:(NSString *)companyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfAllFlowSM*)) callback{
    [LService request:@"getAllFlow.action" with:@[companyid] returns:[ResultModelOfAllFlowSM class] whenDone:callback];
}

+(void) getAllFlowWithflowid:(NSString *)flowid usingCallback:(void (^)(DCServiceContext*, ResultModelOfGetApplicationformSM*)) callback
{
    [LService request:@"getReqNote.action" with:@[flowid] returns:[ResultModelOfGetApplicationformSM class] whenDone:callback];
}

+(void) getApplyListWithCreateApply:(CreateApplySM *)apply usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback
{
    [LService request:@"create.action" with:@[apply] returns:[ResultMode class] whenDone:callback];
}

+(void) getPassWithdealid:(NSString *)dealid withStatus:(int )status withApplyid:(NSString *)applyid  withcontent:(NSString *)content  withhandwriteurl:(NSString *)url withapssid:(NSString *)passid usingCallback:(void (^)(DCServiceContext *, ResultMode *))callback
{
    
    if (url ==nil) {
        [LService request:@"operateFlowRecord.action" with:@[dealid,[NSNumber numberWithInt:status],applyid,content,passid,@""] returns:[ResultMode class] whenDone:callback];
    }else{
        [LService request:@"operateFlowRecord.action" with:@[dealid,[NSNumber numberWithInt:status],applyid,content,passid,url] returns:[ResultMode class] whenDone:callback];
    }
}

//转交 批准 不批准
+(void) getPassWithdealid:(NSString *)dealid withStatus:(int)status1 withApplyid:(NSString *)applyid  withcontent:(NSString *)content withIDarray:(NSString*)idString withPeopleImageUrl:(NSString *)urlStr usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    if (!urlStr) {
        [LService request:@"operateFlowRecord.action" with:@[dealid,[NSNumber numberWithInt:status1],applyid,content,idString,@""] returns:[ResultMode class] whenDone:callback];
    }else{
        [LService request:@"operateFlowRecord.action" with:@[dealid,[NSNumber numberWithInt:status1],applyid,content,idString,urlStr] returns:[ResultMode class] whenDone:callback];
    }
}

/*!
 提交调休申请
 */
+(void) getApplyListWithCreateApplyTiaoXiu:(MapsTiaoXiuRSM *)apply usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback
{
    [LService request:@"createApply.action" with:@[apply] returns:[ResultMode class] whenDone:callback];
}

+(void)DeleteApplyWithApplyid:(NSString *)applyid usingCallback:(void (^)(DCServiceContext*,ResultMode *))callback{
    [LService request:@"deleteApply.action" with:@[applyid] returns:[ResultMode class] whenDone:callback];
}

+(void) getUserDetailWithYonghuID:(NSString *) ID Sessionid:(NSString *)sessionid usingCallback:(void (^)(DCServiceContext*, DengluSM*)) callback{
    [LService request:@"getMyMsg.action" with:@[ID,sessionid] returns:[DengluSM class] whenDone:callback];
}

+(void) getupdateUserAttrWithKey:(NSString *)key Value:(NSString *)value Id:(NSString *)_id usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"updateUserAttr.action" with:@[key,value,_id] returns:[ResultMode class] whenDone:callback];
}

+(void) getResetPwdWithID:(NSString *)id Password:(NSString *)password oldPassword:(NSString *)oldPassword usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"resetPwd.action" with:@[id,password,oldPassword] returns:[ResultMode class] whenDone:callback];
}

+(void) employeeGetCodeWithPhone:(NSString *)phone Status:(NSString *)status usingCallback:(void (^)(DCServiceContext*, ResultModelOfGetCodeSM*)) callback{

    [LService request:@"getCode.action" with:@[phone,status] returns:[ResultModelOfGetCodeSM class] whenDone:callback];
}

+(void) getResetPwdCheckOldPwdWithID:(NSString *)_id oldPassword:(NSString *)oldPassword usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;{
    [LService request:@"resetPwdCheckOldPwd.action" with:@[_id,oldPassword,oldPassword] returns:[ResultMode class] whenDone:callback];
}

+(void) employeeGetCodeWithPhone:(NSString *)phone Code:(NSString *)code usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"checkCode.action" with:@[phone,code] returns:[ResultMode class] whenDone:callback];
}

+(void) getResetPhoneWithID:(NSString *)id Phone:(NSString *)phone OldPassword:(NSString *)oldPassword usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"resetPhone.action" with:@[id,phone,oldPassword] returns:[ResultMode class] whenDone:callback];
}

+(void) getNoticeWithCompanyid:(NSString *)companyid Userid:(NSString *)userid Start:(int) start Count:(int)count usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfNoticeSM*)) callback{
    [LService request:@"getPage.action" with:@[companyid,userid,[NSNumber numberWithInt:start],[NSNumber numberWithInt:count]] returns:[ResultModelOfIListOfNoticeSM class] whenDone:callback];
}

+(void) getNoticeWithUserid:(NSString *)userid Start:(int) start Count:(int)count usingCallback:(void (^)(DCServiceContext*, ResultModelOfatMeNoticeSM*)) callback{
    [LService request:@"atMeNotice.action" with:@[userid,[NSNumber numberWithInt:start],[NSNumber numberWithInt:count]] returns:[ResultModelOfatMeNoticeSM class] whenDone:callback];
}

+(void) getNoticeDetailWithID:(NSString *)id Userid:(NSString *)userid usingCallback:(void (^)(DCServiceContext*, ResultModelOfNoticeDetailSM*)) callback{
    [LService request:@"noticeDetail.action" with:@[id,userid] returns:[ResultModelOfNoticeDetailSM class] whenDone:callback];
}

+(void) getOptionWithUserid:(NSString *)userid UserCompanyid:(NSString *)usercompanyid usingCallback:(void (^)(DCServiceContext*, ResultModelOfGetOptionSM*)) callback{
    [LService request:@"getOption.action" with:@[userid,usercompanyid] returns:[ResultModelOfGetOptionSM class] whenDone:callback];
}

+(void) getUsermsgOptionWithUserid:(NSString *)userid Msgoptionid:(NSString *)msgoptionid Status:(NSString *)status usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"setOption.action" with:@[userid,msgoptionid,status] returns:[ResultMode class] whenDone:callback];
}


+(void) getPublishDynamicWithCreateid:(PublishDynamicSM *)publishDynamicSN usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"publishDynamic.action" with:@[publishDynamicSN] returns:[ResultMode class] whenDone:callback];
}

+(void) getPersonDetailWithUserid:(NSString *)userid usingCallback:(void (^)(DCServiceContext*, ResultModelOfPersonDetailSM*)) callback{
    [LService request:@"getPersonDetail.action" with:@[userid] returns:[ResultModelOfPersonDetailSM class] whenDone:callback];
}

+(void) getDynamicWithstart:(int) start Count:(int)count companyid:(NSString *)companyid Createid:(NSString *)createid Groupid:(NSString *)groupid Type:(int)dongtaiType usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    if (dongtaiType == 1) {
        [LService request:@"getCompanyDynamic.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],companyid,createid,groupid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
    }else if(dongtaiType == 2){
        [LService request:@"atMe.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],createid,groupid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
    }else if(dongtaiType == 3){
        [LService request:@"myAttentionDyn.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],createid,groupid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
    }else if(dongtaiType == 4){
        [LService request:@"collectionDynamicList.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],createid,groupid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
    }else if(dongtaiType == 5){
        [LService request:@"getMyDynamic.action" with:@[[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],createid,groupid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
    }
}

+(void) getAtMeDynamicWithstart:(int) start Count:(int)count Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    
}

+(void) getMyAttentionDynDynamicWithstart:(int) start Count:(int)count Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    
}

+(void) getCompanyOrMyDynamicWithstart:(int) start Count:(int)count Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    
}

+(void) getCollectionDynamicListWithstart:(int) start Count:(int)count  Createid:(NSString *)createid Groupid:(NSString *)groupid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    
}

+(void) getAttentionWithCreateid:(NSString *)createid Relid:(NSString *)relid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"attentionPerson.action" with:@[createid,relid] returns:[ResultMode class] whenDone:callback];
}

+(void) getCancelAttentionWithCreateid:(NSString *)createid Relid:(NSString *)relid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"cancelAttention.action" with:@[createid,relid] returns:[ResultMode class] whenDone:callback];
}

+(void) getDypraiseDynamicWithDynamicid:(NSString *)dynamicid Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    [LService request:@"praiseDynamic.action" with:@[dynamicid,createid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
}

+(void) getDypraiseDynamicWithCancelPraiseDynamicid:(NSString *)dynamicid Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback;{
    [LService request:@"cancelPraiseDynamic.action" with:@[dynamicid,createid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
}

+(void) getDycommentDynamicWithCreateid:(NSString *)createid Content:(NSString *)content Dynamicid:(NSString *)dynamicid Isreply:(NSString *)isreply Topparid:(NSString *)topparid IDS:(NSString *)ids usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"commentDynamic.action" with:@[createid,content,dynamicid,isreply,topparid,ids] returns:[ResultMode class] whenDone:callback];
}

+(void) getDelMyDynamicWithID:(NSString *)Id Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"delMyDynamic.action" with:@[Id,createid] returns:[ResultMode class] whenDone:callback];
}

+(void) getDynamicDetailWithID:(NSString *) Id Createid:(NSString *)createid usingCallback:(void (^)(DCServiceContext*, ResultModelOfIListOfDynamicSM*)) callback{
    [LService request:@"getDynamicDetail.action" with:@[Id,createid] returns:[ResultModelOfIListOfDynamicSM class] whenDone:callback];
}

+(void) getCollectDynamicWithUserid:(NSString *)userid Dynamicid:(NSString *)dynamicid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"collectDynamic.action" with:@[userid,dynamicid] returns:[ResultMode class] whenDone:callback];
}

+(void) getCancelcollectCollectDynamicWithUserid:(NSString *)userid Dynamicid:(NSString *)dynamicid usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"cancelcollect" with:@[userid,dynamicid] returns:[ResultMode class] whenDone:callback];
}

+(void)DydelWithCreateid:(NSString *)createid ID:(NSString *)id Dynamicid:(NSString *)dynamicid usingCallback:(void (^)(DCServiceContext*,ResultMode *))callback{
    [LService request:@"dyDel.action" with:@[createid,id,dynamicid] returns:[ResultMode class] whenDone:callback];
}

+ (void)grIsAdminWithID:(NSString *)ID Ext3:(NSString *)ext3 usingCallback:(void (^)(DCServiceContext*, HPResultSM*))callback{
    [LService request:@"judgePower.action" with:@[ID,ext3] returns:[HPResultSM class] whenDone:callback];
}

+ (void)getCreateFeedbackWithID:(NSString *)userid ConTent:(NSString *)content usingCallback:(void(^)(DCServiceContext*,ResultModelOfFeedbackSM*))callback;{
    [LService request:@"createFeedback.action" with:@[userid,content] returns:[ResultModelOfFeedbackSM class] whenDone:callback];
}

+ (void)getHomeContentVWithUserid:(NSString *)userid Companyid:(NSString *)companyid Apitype:(NSString*)apitype usingCallback:(void(^)(DCServiceContext*,HomeContentVSM*))callback{
    [LService request:@"getMsgList.action" with:@[userid,companyid,apitype] returns:[HomeContentVSM class] whenDone:callback];
}

+ (void)getDecreaseReddotWithUserid:(NSString *)userid Key:(NSString *)key usingCallback:(void(^)(DCServiceContext*serviceContext,ResultMode*sm))callback{
    [LService request:@"decreaseReddot.action" with:@[userid,key] returns:[ResultMode class] whenDone:callback];
}

+ (void)getMsgToRedWithUserid:(NSString *)userid Module:(NSString*)module usingCallback:(void(^)(DCServiceContext*,ResultMode*))callback{
    [LService request:@"setMsgToRead.action" with:@[userid,module] returns:[ResultMode class] whenDone:callback];
}

+ (void)getMarkNoticeDelWithUserid:(NSString *)userid Noticeid:(NSString*)noticeid usingCallback:(void(^)(DCServiceContext*,ResultMode*))callback{
    [LService request:@"markNoticeDel.action" with:@[userid,noticeid] returns:[ResultMode class] whenDone:callback];
}

+ (void)getAtMeNoticeDelWithcommantatID:(NSString *)commantatid usingCallback:(void(^)(DCServiceContext*,ResultMode*))callback{
    [LService request:@"atMeNoticeDel.action" with:@[commantatid] returns:[ResultMode class] whenDone:callback];
}

+ (void)getPreOrNextApplyWithUserid:(NSString *)userid Createtime:(NSString*)createtime PrveOrNext:(int)prveOrNext Type:(int)type Companyid:(NSString *)companyid usingCallback:(void(^)(DCServiceContext*,ResultModelOfApplyDetailSM*))callback{
    [LService request:@"getPrevOrNextApply.action" with:@[userid,createtime,[NSNumber numberWithInt:prveOrNext],[NSNumber numberWithInt:type],companyid] returns:[ResultModelOfApplyDetailSM class] whenDone:callback];
}

@end
