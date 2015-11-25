//
//  ToolBox.m
//  Zipingguo
//
//  Created by lilufeng on 15/11/3.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ToolBox.h"
#import "UploadHelper.h"
#import "ServiceShell.h"
#import "Base64JiaJieMi.h"
#import "DCDialogManager.h"
@implementation ToolBox
@synthesize myDissmiss;
#pragma mark- 时间转化字符串
/**
 *  时间转化
 *
 *  @param date   时间date
 *  @param istime 是否是时间？yes-- @"yyyy-MM-dd HH:mm:ss"  no -- @"yyyy年MM月dd日"
 *
 *  @return 时间字符串
 */
+ (NSString *)shijianStringWith:(NSDate *)date isTime:(BOOL)istime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (istime) {//时间
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{//日期
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    return [dateFormatter stringFromDate: date];
    
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSString*) time
//
{
    NSDate *compareDate ;
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分前",temp];
    }
    
    else if((temp = temp/60) < 24){
        result = [NSString stringWithFormat:@"%d小前",temp];
    }
    
    else if((temp = temp/24) < 30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) < 12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
}

//保存数据
+ (void)baocunYonghuShuju:(UserDataSM *)sm data2:(DengluData1 *)data1 Password:(NSString *)password IsWanshan:(BOOL)wanshan{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:sm.companyid forKey:@"companyid"];
    [userDefaults setObject:sm.userid forKey:@"userid"];
    if (sm.imgurl != nil) {
        [userDefaults setObject:sm.imgurl forKey:@"imgurl"];
    }else{
        [userDefaults setObject:@"" forKey:@"imgurl"];
    }
    [userDefaults setObject:sm.name forKey:@"name"];
    [userDefaults setObject:sm.position forKey:@"position"];
    if (wanshan) {
        [userDefaults setObject:sm.sessionid forKey:@"sessionid"];
    }else{
        [userDefaults setObject:@"" forKey:@"sessionid"];
    }
    [userDefaults setObject:sm.phone forKey:@"phone"];
    [userDefaults setObject:sm.deptid forKey:@"deptid"];
    [userDefaults setObject:password forKey:@"password"];
    
    [userDefaults setObject:data1.role forKey:@"role"];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",data1.corpnum] forKey:@"corpnum"];
    
    [userDefaults synchronize];
    
    [self huoquShuju];
}

#pragma mark 获取数据
+ (void)huoquShuju{
    //读取数据，并进行判断
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *companyid = [defaults objectForKey:@"companyid"];
    NSString *userid = [defaults objectForKey:@"userid"];
    NSString *imgurl = [defaults objectForKey:@"imgurl"];
    NSString *name = [defaults objectForKey:@"name"];
    NSString *position = [defaults objectForKey:@"position"];
    NSString *sessionid = [defaults objectForKey:@"sessionid"];
    NSString *phone = [defaults objectForKey:@"phone"];
    NSString *password = [defaults objectForKey:@"password"];
    NSString *role = [defaults objectForKey:@"role"];
    NSString *deptid = [defaults objectForKey:@"deptid"];
    NSString *corpnum = [defaults objectForKey:@"corpnum"];
    [AppStore setGongsiID:companyid];
    [AppStore setYongHuID:userid];
    [AppStore setYonghuImageView:imgurl];
    [AppStore setYongHuMing:name];
    [AppStore setDeptid:deptid];
    [AppStore setZhiwei:position];
    [AppStore setSessionid:sessionid];
    [AppStore setYongHuShoujihao:phone];
    [AppStore setYongHuMima:password];
    if ([role isEqualToString:@"CORP_CREATOR"]) {
        [AppStore setIsAdmin:YES];
    }else{
        [AppStore setIsAdmin:NO];
    }
    
    if ([corpnum isEqualToString:@"1"]) {
        [AppStore setCorpnums:NO];
    }else{
        [AppStore setCorpnums:YES];
    }
}

+ (void)Tanchujinggao:(NSString *)msg IconName:(NSString *)iconName{
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    TixingView *tixingView = [[TixingView alloc] init];
    tixingView.frame = CGRectMake(0, -64, ScreenWidth, 64);

    [ShareApp.window addSubview:tixingView];
    if (iconName.length != 0) {
        tixingView.jinggaoIcon.image = [UIImage imageNamed:iconName];
    }
    tixingView.jinggaoWenzi.text = msg;
    [UIView animateWithDuration:1.0f animations:^{
        tixingView.frame = CGRectMake(0, 0, ScreenWidth, 64);
        
    } completion:^(BOOL finished) {
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:1.0f animations:^{
                 tixingView.frame = CGRectMake(0, -64, ScreenWidth, 64);
            } completion:^(BOOL finished) {
                [tixingView removeFromSuperview];
            }];
        });
    }];
}
+ (void)Tanchujinggao:(NSString *)msg IconName:(NSString *)iconName DissMiss:(Dissmiss)dismiss{
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    TixingView *tixingView = [[TixingView alloc] init];
    tixingView.frame = CGRectMake(0, -64, ScreenWidth, 64);
    
    [ShareApp.window addSubview:tixingView];
    if (iconName.length != 0) {
        tixingView.jinggaoIcon.image = [UIImage imageNamed:iconName];
    }
    tixingView.jinggaoWenzi.text = msg;
    [UIView animateWithDuration:1.0f animations:^{
        tixingView.frame = CGRectMake(0, 0, ScreenWidth, 64);
        
    } completion:^(BOOL finished) {
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:1.0f animations:^{
                tixingView.frame = CGRectMake(0, -64, ScreenWidth, 64);
            } completion:^(BOOL finished) {
                if (dismiss) {
                    dismiss();
                }
                [tixingView removeFromSuperview];
            }];
        });
    }];

}


//-------------------------------lilufeng代码留存--------------------------------------
//上传单张图片
+ (void)uploadImage:(UIImage *)image success:(void (^)(NSString *url))success failure:(void (^)())failure{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.0001);
    NSString * base64Str = Base64_bianMa_DataToString(imgData);

    if (!imgData) {
        if (failure) {
            failure();
        }
        return;
    }

    
    [ServiceShell getUploadWithImgNmae:@"fujian" ImgStr:base64Str usingCallback:^(DCServiceContext *sc, ResultModelShangchuanWenjianSM *sm) {
        if (sc.isSucceeded && sm.result == 0) {//上传成功
            //            model.url = sm.data.url;
            if (success) {
                success(sm.data.url);
            }
        }else {
            if (failure) {
                failure();
            }
        }
        
    }];
    
}
//上传多张图片
+ (void)uploadImageArray:(NSArray *)imageArray success:(void (^)(NSArray *))success failure:(void (^)())failure{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    __block NSUInteger currentIndex = 0;
    UploadHelper *uploadHelper = [UploadHelper sharedInstance];
        __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^(){
        failure();
        return ;
    };
    
    uploadHelper.singleSuccessBlock = ^(NSString *url){
        [array addObject:url];
        currentIndex ++ ;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }else{
            
            [self uploadImage:imageArray[currentIndex] success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }

    };
    
    [self uploadImage:imageArray[0] success:uploadHelper.singleSuccessBlock failure:uploadHelper.singleFailureBlock];
    
}
//---------------------end---------------------------------------------------------


+ (BOOL)checkPhoneNumInput:(NSString *)phoneNumber{
    NSString * LLF = @"^\\d{11}$";
    NSPredicate *regextestLLF = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", LLF];
    BOOL resLLF = [regextestLLF evaluateWithObject:phoneNumber];
    if (resLLF) {
        return YES;
    }else{
        
        return NO;
    }
}
+ (BOOL)checkYanZhengMaInput:(NSString *)number{
    NSString * LLF = @"^\\d{6}$";
    NSPredicate *regextestLLF = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", LLF];
    BOOL resLLF = [regextestLLF evaluateWithObject:number];
    if (resLLF) {
        return YES;
    }else{
        
        return NO;
    }

}
+ (NSString *)jiedangCompanyid:(NSString *)companyid{
    //时间解档
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentPath stringByAppendingString:[@"/nowTime" stringByAppendingFormat:@"%@",companyid]];
    NSString * time = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (time.length == 0) {
        time = [self chuliTime:@"2015-10-09 18:01:01" isArchive:YES companyid:companyid];
    }
    return time;
}

+ (NSString *)chuliTime:(NSString *)nowTime isArchive:(BOOL)isArchive companyid:(NSString *)companyid{
    
    if(isArchive){
        //归档时间--- 拼接GongsiID
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path=[documentPath stringByAppendingString:[@"/nowTime" stringByAppendingFormat:@"%@",companyid]];
        BOOL success;
        if (nowTime.length == 0) {
            success =[NSKeyedArchiver archiveRootObject:@"2015-10-09 18:01:01" toFile:path];
        }else{
            success =[NSKeyedArchiver archiveRootObject:nowTime toFile:path];
        }
        if (success) {
            NSLog(@"时间归档成功");
        }
    }
    
    return nowTime;
}
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(void) showList:(NSArray *)items images:(NSArray *)images forAlignment:(ListViewAlignment)alignment callback:(void (^)(int index)) buttonClickCallback {

    ListView *listView = [[ListView alloc]initWithItems:items images:images forAlignment:alignment Callback:buttonClickCallback];
    [[DCDialogManager defaultManager] addDialog:listView];
}

+(void) showList:(NSArray *)items selectedIndex:(NSInteger)index forAlignment:(ListViewAlignment)alignment callback:(void (^)(int index)) buttonClickCallback {
    
    ListView *listView = [[ListView alloc]initWithItems:items images:@[] forAlignment:alignment Callback:buttonClickCallback];
    [listView selectedIndex:index];
    [[DCDialogManager defaultManager] addDialog:listView];
}
+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
