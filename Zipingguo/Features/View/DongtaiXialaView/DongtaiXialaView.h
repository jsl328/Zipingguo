//
//  DongtaiXialaView.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-6.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DongtaiXialaViewDelegate <NSObject>

- (void)quanbuDongtaiFangfa;

- (void)yaoQingWodeDongtaiFangfa;

- (void)wodeGuanzhuFangfa;

- (void)wodeDongtaiFangfa;

- (void)woshoucangdeFangfa;

@end
@interface DongtaiXialaView : UIView
@property (strong, nonatomic) id <DongtaiXialaViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *quanbudongtaiButton;

@property (weak, nonatomic) IBOutlet UIButton *yaoqingwodedongtaiButton;

@property (weak, nonatomic) IBOutlet UIButton *wodeguanzhuButton;

@property (weak, nonatomic) IBOutlet UIButton *wodedongtaiButton;

@property (weak, nonatomic) IBOutlet UIButton *woshoucangdeButton;

- (IBAction)buttonClick:(UIButton *)sender;
@end
