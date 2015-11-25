//
//  WaiweiParentsViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface WaiweiParentsViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *backbtn;

@property (nonatomic,strong) FXBlurView *blurView;

@property (nonatomic, strong) UIButton *itemBtn;

//设置Item(customBack)
- (void)customBackItemWithImage:(NSString *)image Color:(UIColor *)color IsHidden:(BOOL)hidden;

//设置Item(customView)
- (void)addItemWithTitle:(NSString *)title imageName:(NSString *)imageName selector:(SEL)selector location:(BOOL)isLeft;

- (void)backSel;


/**
 *  创建高斯模糊的View
 *
 *  @param moHuHeight 模糊的高度
 */
- (void)setMoHuViewWithHeight:(float)moHuHeight;
- (void) showMoHuViewWithAnimationDuration:(float)duration;
- (void) hideMoHuViewWithAnimationDuration:(float)duration;
- (void) showMoHuView;
- (void) hideMoHuView;

@end
