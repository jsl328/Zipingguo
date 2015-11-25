//
//  WanshanZiliaoViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface WanshanZiliaoViewController : WaiweiParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIButton *xiangjiBtn;
    __weak IBOutlet UIView *daView;
    __weak IBOutlet UITextField *gongsiName;
    __weak IBOutlet UITextField *name;
    __weak IBOutlet UITextField *bumen;
    __weak IBOutlet UITextField *zhiwei;
    __weak IBOutlet UITextField *gonghao;
    __weak IBOutlet UITextField *youxiang;
    __weak IBOutlet UIButton *wanchengBtn;
    __weak IBOutlet UIButton *bumenBtn;
}

@property (nonatomic, strong) UserDataSM *userdata;

@property (nonatomic, assign) BOOL isDenglu;

@end
