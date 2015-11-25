//
//  DongtaiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"
#import "DongtaiXialaView.h"
#import "DongtaiXiangqingViewController.h"
#import "PinglunKuangView.h"
#import "XuanzeRenyuanModel.h"
@class DongtaiModel;
@interface DongtaiViewController : RootViewController<DongtaiXialaViewDelegate,PinglunKuangViewDelegate>
{
    DongtaiXialaView *xialaView;
    BOOL isYaoqingWode;
    BOOL isGuanzhu;
    BOOL isDongtai;
    BOOL isQuanbu;
    BOOL isShoucang;
    
    BOOL YaoqingWode;
    BOOL Guanzhu;
    BOOL Dongtai;
    BOOL Quanbu;
    BOOL Shoucang;
    
    NSString *subTitle;
    
    NSString *typeTitle;
    
    PinglunKuangView *pinglunKuang;
    NSMutableArray *atusers;
    
    NSString *delPinglunid;
    DongtaiModel *dongtaiModel;
    
    BOOL showWaitBox;
    
}

@property (strong, nonatomic) MessageReadManager *messageReadManager;

@end
