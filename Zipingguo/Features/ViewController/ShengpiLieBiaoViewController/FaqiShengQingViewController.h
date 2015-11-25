//
//  FaqiShengQingViewController.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaqishengqingCellVM.h"
#import "AllFlowsSM.h"
#import "RootViewController.h"
//#import "KaiShiShengPiViewController.h"

@protocol FaqiShengqingDelegate <NSObject>

-(void)shuaxinFanhui;

@end

@interface FaqiShengQingViewController : RootViewController

@property (assign, nonatomic)id<FaqiShengqingDelegate>delagate;
@property (weak, nonatomic) IBOutlet UIImageView *fengexianImageView;
@end
