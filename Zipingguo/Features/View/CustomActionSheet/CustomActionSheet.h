//
//  CustomActionSheet.h
//  ZYActionSheet
//
//  Created by sunny on 15/9/30.
//  Copyright © 2015年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomActionSheet;
@protocol CustomActionSheetDelegate <NSObject>

/**
 *  点击对应的按钮
 *
 *  @param indexButton 从1开始 0是取消按钮或者背景点击
 */
- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton customActionView:(CustomActionSheet *)customActionSheet;
- (void)CustomActionSheetDelegateDidClickCancelButton:(CustomActionSheet *)customActionSheet;

@end

typedef void(^ActionSheetClickIndex)(NSInteger index);
typedef void(^ActionSheetCancle)();

@interface CustomActionSheet : UIView
@property (nonatomic,strong) ActionSheetClickIndex actionClick;
@property (nonatomic,strong) ActionSheetCancle actionCancle;

@property (nonatomic,assign) float actionSheetHeight;
@property (nonatomic, assign) id<CustomActionSheetDelegate>delegate;

/**
 *  创建actionSheet
 *
 *  @param titleName  标题名 （不传为空）
 *  @param array      按钮数组
 *  @param cancleName 取消按钮名字（默认取消）
 *  @param rect       弹出框view大小
 *
 *  @return return value description
 */
- (instancetype)initWithTitle:(NSString *)titleName OtherButtons:(NSArray *)array CancleButton:(NSString *)cancleName Rect:(CGRect)rect;

/**
 *  默认0.4s显示
 */
- (void)show;

- (void)showWithAnimationDuration:(float)duration;

/**
 *  默认0.4s消失
 */
- (void)dismiss;
/**
 *  动画多少秒消失
 *
 *  @param second <#second description#>
 */
- (void)dismissWithAnimationDuration:(float)duration;

- (void)showButtons:(ActionSheetClickIndex)buttonIndex cancle:(ActionSheetCancle)cancle;
@end
