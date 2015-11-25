//
//  KaiShiShengPiViewController.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaqiShengQingViewController.h"
#import "HuaTuView.h"
#import "UIPlaceHolderTextView.h"
@protocol tijiaoDelegate <NSObject>

-(void)tijiaofanhuifangfa:(int)type;

@end
@interface KaiShiShengPiViewController : ParentsViewController
{
    NSMutableArray *idArray;
    NSMutableArray *nameArray;
    HuaTuView *shouxieBan;
    NSMutableArray *photoArray;
}
@property (nonatomic) int index;
@property (assign,nonatomic) BOOL  isShuxieshiyou;
@property (assign, nonatomic) id<tijiaoDelegate> delegate;
@property (strong, nonatomic) NSString *ID;

@property (assign,nonatomic) int isPass;
@property (assign,nonatomic) int  status;
@property (strong,nonatomic) NSString  *applyid;
@property (strong, nonatomic) IBOutlet UIButton *qingkongBtn;
@property (strong, nonatomic) IBOutlet UIButton *shangchuanBtn;
@property (strong, nonatomic) IBOutlet UIView *shurukuangView;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *neirongTextView;
@property (strong, nonatomic) IBOutlet UIView *dibuView;
@property (strong, nonatomic) IBOutlet HuaTuView *huatuBanView;

- (IBAction)buttonOnclick:(UIButton *)sender;


@property (nonatomic ,strong) void (^passValueFromShengpi)(int start);

@end
