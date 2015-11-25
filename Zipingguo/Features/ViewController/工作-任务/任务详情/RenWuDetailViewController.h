//
//  RenWuDetailViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "UIPlaceHolderTextView.h"

@interface RenWuDetailViewController : ParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIView *riQiView;
    __weak IBOutlet UIDatePicker *choseTimePickerView;
    __weak IBOutlet UIPlaceHolderTextView *messageTF;
    __weak IBOutlet UIView *toolView;
    __weak IBOutlet UITableView *baseTableView;
    __weak IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *toolViewBottomConst;
}

@property (nonatomic,assign) BOOL isMyRenWu;/**<是不是我的任务 yes是我的任务，no我分配的任务*/
@property (nonatomic,assign) BOOL isFinish;/**<任务是否已完成  yes已完成 no 未完成*/
@property (nonatomic, assign) BOOL tongzhiRili;/**<通知与日历进入*/

@property (nonatomic,strong) void (^finishRenWu)(NSString *renWuId);/**<完成任务的回调*/
@property (nonatomic,strong) void (^deleteRenWu)(NSString *renWuId);/**<删除任务的回调*/

@property (nonatomic,strong) void (^updataRenWu)(NSString *renWuId);/**<更新任务的回调*/

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,copy) NSString *renWuID;

@end
