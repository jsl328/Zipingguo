//
//  DaKaServiceShell.m
//  Zipingguo
//
//  Created by sunny on 15/10/27.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DaKaServiceShell.h"

@implementation DaKaServiceShell



+ (void)daKaPostWithDaKaSM:(DaKaSM *)daKaSM UsingCallback:(void (^)(DCServiceContext *, ResultMode *))callback{
    [LService request:@"createAttd.action" with:@[daKaSM] returns:[ResultMode class] whenDone:callback];
}

+ (void)daKaGetRecordWithYongHuID:(NSString *)yongHuID DaKaType:(int)daKaType IsToday:(int)isToday Start:(int)start CountSize:(int)countSize UsingCallback:(void (^)(DCServiceContext *, DaKaJiLuSM *))callback{
    [LService request:@"attdList.action" with:@[yongHuID,[NSNumber numberWithInt:daKaType],[NSNumber numberWithInt:isToday],[NSNumber numberWithInt:start],[NSNumber numberWithInt:countSize]] returns:[DaKaJiLuSM class] whenDone:callback];
}

/************************************************************************/

+ (void) getTodayAttendanceRecordWithYongHuID:(NSString *)yongHuID UsingCallback:(void (^)(DCServiceContext *, JinRiJiLuListSM *))callback{
    [LService request:@"getAttendanceRecord.action_today" with:@[yongHuID,@"1"] returns:[JinRiJiLuListSM class] whenDone:callback];
}
+ (void) changGuiDaKaShangChuanWithYongHuID:(NSString *)yongHuID Address:(NSString *)address CompanyID:(NSString *)companyID UsingCallback:(void (^)(DCServiceContext *, ResultMode *))callback{
    [LService request:@"quickSign.action" with:@[yongHuID,address,companyID] returns:[ResultMode class] whenDone:callback];
}
+ (void) waiChuDaKaWithWaiChuRecordSM:(DaKaWaiChuRecordSM *)waiChuSM UsingCallback:(void (^)(DCServiceContext *, ResultMode *))callback{
    [LService request:@"save.action2" with:@[waiChuSM] returns:[ResultMode class] whenDone:callback];
}
+ (void) getChangGuiDaKaRecordWithYongHuID:(NSString *)yongHuID Start:(int)start CountSize:(int)countSize IsToday:(int)isToday usingCallback:(void (^)(DCServiceContext *, JinRiJiLuListSM *))callback{
    [LService request:@"getAttendanceRecord.action" with:@[yongHuID,[NSNumber numberWithInt:start],[NSNumber numberWithInt:countSize],[NSNumber numberWithInt:isToday]] returns:[JinRiJiLuListSM class] whenDone:callback];
}
@end
