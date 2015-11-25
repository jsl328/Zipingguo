//
//  SDialog.m
//  Lvpingguo
//
//  Created by 阿布都沙拉木吾斯曼 on 15/3/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "SDialog.h"

@implementation SDialog

static SDialog *_sharedDialog;
bool _isFromSelf;
/**
 * @brief 单例
 * @param N/A
 * @return 返回单例
 */
+(SDialog*)sharedDialog
{
    static dispatch_once_t onceTokenForS;
    dispatch_once(&onceTokenForS, ^{
        _isFromSelf = YES;
        _sharedDialog = [[SDialog alloc]init];
        _isFromSelf = NO;
    });
    return _sharedDialog;
}

+ (id)alloc
{
    if(_isFromSelf)
        return [super alloc];
    else
        return [self sharedDialog];
}

/**
 * Called after the HUD was fully hidden from the screen.
 */
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    UIView* containerView = hud.parentView;
    [containerView removeFromSuperview];
    if (_finishCallBack) {
        _finishCallBack();
    }
}

/**
 * @brief 显示提示信息，经过seconds后，自动消失
 * @param text    提示信息的内容
 * @param seconds 提示信息，持续显示的秒数
 * @return N/A
 */
+(void)showTipViewWithText:(NSString*)text hideAfterSeconds:(NSTimeInterval)seconds
{
    // 放到containerView上显示，防止多次显示提示框时，后面显示的框，不显示了;
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    [window addSubview:containerView];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:containerView animated:YES];
    hud.parentView = containerView;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont=[UIFont systemFontOfSize:15];
    hud.margin = 20.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = [SDialog sharedDialog]; //nil;
    [hud hide:YES afterDelay:seconds];
    return;
}
/**
 * @brief 显示提示信息，经过seconds后，自动消失
 * @param text    提示信息的内容
 * @param seconds 提示信息，持续显示的秒数
 * @param callBack 弹框消失完成后的回调
 * @return N/A
 */
+ (void)showTipViewWithText:(NSString*)text hideAfterSeconds:(NSTimeInterval)seconds finishCallBack:(void(^)())callBack{
    // 放到containerView上显示，防止多次显示提示框时，后面显示的框，不显示了;
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    [window addSubview:containerView];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:containerView animated:YES];
    hud.parentView = containerView;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont=[UIFont systemFontOfSize:15];
    hud.margin = 20.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = [SDialog sharedDialog]; //nil;
    [self sharedDialog].finishCallBack = callBack;;
    [hud hide:YES afterDelay:seconds];
    return;
}
/**
 * @brief 显示提示信息，经过seconds后，自动消失
 * @param text    提示信息的内容
 * @param seconds 提示信息，持续显示的秒数
 * @param delegate MBProgressHUDDelegate类型，当提示窗口消失后，被调用
 * @return N/A
 */
+(void)showTipViewWithText:(NSString*)text hideAfterSeconds:(NSTimeInterval)seconds delegate:(id<MBProgressHUDDelegate>)delegate
{
    // 放到containerView上显示，防止多次显示提示框时，后面显示的框，不显示了;
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    [window addSubview:containerView];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:containerView animated:YES];
    hud.parentView = containerView;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 20.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = delegate;
    [hud hide:YES afterDelay:seconds];
    
    return;
}

/**
 * @brief 显示正在加载进度视图
 * @param N/A
 * @return N/A
 */
+(void)showloadingProgressView
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    hud.delegate = nil;
}

/**
 * @brief 隐藏加载进度视图
 * @param N/A
 * @return N/A
 */
+(void)hideloadingProgressView
{
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
}
+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}
@end
