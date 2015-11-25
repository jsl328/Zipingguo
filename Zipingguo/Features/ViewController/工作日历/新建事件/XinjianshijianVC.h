//
//  XinjianshijianVC.h
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentsViewController.h"
@protocol ShijianDelegate<NSObject>
-(void)shijianshuanxin;


@end


@interface XinjianshijianVC : ParentsViewController
@property (nonatomic,weak)id<ShijianDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *BiaotiVIew;

@property (strong, nonatomic) IBOutlet UIView *riqiVIew;
@property (strong, nonatomic) IBOutlet UIView *tixingVIew;
@property (strong, nonatomic) IBOutlet UIView *beizhuView;
@property (strong, nonatomic) IBOutlet UITextView *biaotishurukuang;
@property (strong, nonatomic) IBOutlet UIButton *riribtn;
- (IBAction)riqiAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *riqiLable;

@property (strong, nonatomic) IBOutlet UIButton *tixingbtn;
- (IBAction)tixingbtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *tixingLable;
@property (strong, nonatomic) IBOutlet UITextView *beishushurukuang;
@property (strong, nonatomic) IBOutlet UIImageView *fengexian;
@property (strong, nonatomic) IBOutlet UIImageView *tixingtupian;
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString*biaoti;
@property (nonatomic,strong)NSString*beizhu;
@property(nonatomic,copy)NSString *shijian;
@property(nonatomic,copy)NSString*tixingzhi;
@end
