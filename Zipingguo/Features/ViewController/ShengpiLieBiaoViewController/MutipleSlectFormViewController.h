//
//  MutipleSlectFormViewController.h
//  Lvpingguo
//
//  Created by jiangshilin on 15/6/5.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiaoDanModel.h"
#import "BiaoDanViewCopy.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import "ResultModelOfApplyDetailSM.h"
#import "RootViewController.h"
#import "FaqishengqingCellVM.h"
#import "TextViewTableViewCell.h"
typedef enum{
    timeConfirm = 100,
    textConfirm,
}confirmTag;

@protocol MutipleSlectFormViewControllerDelegate <NSObject>
- (void)fanhuiShuaxin;
@end

@interface MutipleSlectFormViewController : RootViewController<biaodanDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView *tableView;
    NSMutableArray *dataSoure;
    NSArray *xuanzeArr;
    UIDatePicker *_datePicker;
    UIView *_timeBackView;
    NSString *dealName;
}

@property (nonatomic, strong) id <MutipleSlectFormViewControllerDelegate> delegate;
@property (nonatomic, strong) FaqishengqingCellVM *transformModel;
@property (nonatomic, strong) NSString *defaultuserid;
@property (nonatomic, strong) NSString *defaultuserName;
@property (nonatomic, assign) BOOL isXiugai;
@property (nonatomic, strong) NSString *xiangqingID;
@property (nonatomic, strong) NSString *flowname;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *appcssArr;
@property (nonatomic, strong) NSString *apporveID;

@property (nonatomic,strong)NSString *flowid;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *miaoshuStr;

//表单体
@property (nonatomic,strong)NSArray *applicationsArr;

@property (nonatomic,strong)NSMutableArray *chnameArray;
@property (nonatomic,strong)NSMutableArray *idArray;
@end
