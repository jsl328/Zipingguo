//
//  DongtaiXiangqingViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/24.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "WeizhiView.h"
#import "TupianView.h"
#import "YuyinView.h"
#import "ZanPingShanView.h"
#import "ZanView.h"
#import "DongtaiPinglunCellVM.h"
#import "PinglunKuangView.h"
#import "XuanzeRenyuanModel.h"
#import "XuanzeRenyuanViewController.h"
@interface DongtaiXiangqingViewController : ParentsViewController<YuyinViewDelegate,TupianViewDelegate,ZanPingShanViewDelegate,ListBoxDelegate,UITextViewDelegate,PinglunKuangViewDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UIImageView *touxiang;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UIButton *guanzhuBtn;
    __weak IBOutlet UIButton *quxiaoGuanzhuBtn;
    __weak IBOutlet UILabel *neirong;
    
    YuyinView *yuyinView;
    WeizhiView *weizhiView;
    TupianView *tupianView;
    ZanPingShanView *zanpingShanView;
    ZanView *zanpingView;
    
    NSMutableArray *photos;
    NSMutableArray *tupianUrlArray;
    NSMutableArray *tupianArray;
    NSMutableArray *tpArray;
    
    __weak IBOutlet ListBox *listBox;
    
    AllDynamicSM *_model;
    
    NSMutableArray *dataArray;
    
    float viewHeight;
    
    PinglunKuangView *pinglunKuang;
    NSMutableArray *atusers;
    
    BOOL dianzan;
    BOOL quxiaoDianzan;
    BOOL pinglun;
    
    NSString *YaoqingRenName;
    
    NSMutableArray *modelArray;
    
    NSString *delPinglunid;
}

@property (nonatomic, strong) NSString *dongtaiId;;

@property (nonatomic, strong) AllDynamicSM *dynamicSM;

@property (nonatomic ,strong) void (^passValueFromxiangqing)(AllDynamicSM *model,int start);

@property (strong, nonatomic) MessageReadManager *messageReadManager;

@property (assign) BOOL tongzhi;

@end
