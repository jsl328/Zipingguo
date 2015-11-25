//
//  ParentsViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+Customer.h"
#import "FXBlurView.h"

@interface ParentsViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UIView *titleViewSubview; //titleview的下拉子试图
}
// 高斯模糊View
@property (nonatomic,strong) FXBlurView *blurView;

@property (nonatomic, strong) UIButton *itemBtn;

@property (nonatomic, strong) UISegmentedControl *seg;

@property(nonatomic,assign) BOOL upArrowFlag; //下拉和上拉的标记
//设置Item(customBack)
- (void)customBackItemIsHidden:(BOOL)hidden;
//根据标题，设置titleView
- (void)addTitleViewWithTitle:(NSString *)title;

//设置Item(customView)
- (void)addItemWithTitle:(NSString *)title imageName:(NSString *)imageName selector:(SEL)selector location:(BOOL)isLeft;

//设置titleView(customView)
- (void)addSegmentedControlWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle selector:(SEL)selector;

//设置titleView(customView)
- (void)addXialaTitleViewWithTitle:(NSString *)title selector:(SEL)selector Dianji:(BOOL)dianji;

- (void)backSel;

/**
 *  创建高斯模糊的View
 *
 *  @param moHuHeight 模糊的高度
 */
- (void)setMoHuViewWithHeight:(float)moHuHeight;
- (void) showMoHuView;
- (void) hideMoHuView;
@end
