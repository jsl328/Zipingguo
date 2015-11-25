//
//  SDialog.h
//  Lvpingguo
//
//  Created by 阿布都沙拉木吾斯曼 on 15/3/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface SDialog : NSObject<MBProgressHUDDelegate>
/**
 * @brief 单例
 * @param N/A
 * @return 返回单例
 */
+(SDialog*)sharedDialog;

/**
 * @brief 显示提示信息，经过seconds后，自动消失
 * @param text    提示信息的内容
 * @param seconds 提示信息，持续显示的秒数
 * @return N/A
 */
+(void)showTipViewWithText:(NSString*)text hideAfterSeconds:(NSTimeInterval)seconds;

/**
 * @brief 显示提示信息，经过seconds后，自动消失
 * @param text    提示信息的内容
 * @param seconds 提示信息，持续显示的秒数
 * @param delegate 当提示窗口消失后，被调用
 * @return N/A
 */
+(void)showTipViewWithText:(NSString*)text hideAfterSeconds:(NSTimeInterval)seconds delegate:(id<MBProgressHUDDelegate>)delegate;

/**
 * @brief 显示正在加载进度视图
 * @param N/A
 * @return N/A
 */
+(void)showloadingProgressView;

/**
 * @brief 隐藏加载进度视图
 * @param N/A
 * @return N/A
 */
+(void)hideloadingProgressView;

/**
 *  显示带菊花和文字的提示
 *
 *  @param message 文字
 *  @param view    要显示的view
 */
+ (void )showMessage:(NSString *)message toView:(UIView *)view;

/**
 * @brief 显示提示信息，经过seconds后，自动消失
 * @param text    提示信息的内容
 * @param seconds 提示信息，持续显示的秒数
 * @param callBack 弹框消失完成后的回调
 * @return N/A
 */
+(void)showTipViewWithText:(NSString*)text hideAfterSeconds:(NSTimeInterval)seconds finishCallBack:(void(^)())callBack;
@property (nonatomic,strong) void (^finishCallBack)(void);/**<弹框消失完成后的回调*/
@end
