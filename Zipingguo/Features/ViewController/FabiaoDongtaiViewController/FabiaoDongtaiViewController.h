//
//  FabiaoDongtaiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "CustomActionSheet.h"
#import "YuyinView.h"
#import "TupianView.h"
#import "WeizhiView.h"
#import "UIPlaceHolderTextView.h"

@interface FabiaoDongtaiViewController : ParentsViewController<UITextViewDelegate,CustomActionSheetDelegate,TupianViewDelegate,WeizhiViewDelegate,YuyinViewDelegate>
{
    __weak IBOutlet UIView *dibuView;
    __weak IBOutlet UIButton *yuyinBtn;
    __weak IBOutlet UIButton *yaoqingBtn;
    __weak IBOutlet UIButton *tupianBtn;
    __weak IBOutlet UIButton *weizhiBtn;
    __weak IBOutlet UIView *fabiaoView;
    __weak IBOutlet UIPlaceHolderTextView *fabiaoWenzi;
    __weak IBOutlet UIView *yuyinView;
    __weak IBOutlet UIButton *anzhuBtn;
    __weak IBOutlet UIButton *guanbiBtn;
    __weak IBOutlet UIScrollView *xinxiScrollView;
}

@property (nonatomic ,strong) void (^passValueFromFabiao)(int start);

@end
