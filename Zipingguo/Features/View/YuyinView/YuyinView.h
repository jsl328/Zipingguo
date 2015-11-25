//
//  YuyinView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YuyinView;

@protocol YuyinViewDelegate <NSObject>

- (void)BofangYuyin:(YuyinView *)luyinView;



@optional
- (void)ShanchuYuyin:(YuyinView *)luyinView;

- (void)bofangFangfa:(NSInteger)TAG Yuyin:(YuyinView *)luyinView;

@end

@interface YuyinView : UIView
{
    NSMutableArray *_recevierAnimationImages;
}
@property (nonatomic, strong) id <YuyinViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *yuyinBeijing;
@property (weak, nonatomic) IBOutlet UIButton *guanbiBtn;
@property (weak, nonatomic) IBOutlet UIImageView *yinliangImageView;
@property (weak, nonatomic) IBOutlet UILabel *miaoshuLabel;
@property (weak, nonatomic) IBOutlet UIButton *bofangBtn;

@property (retain, nonatomic) NSString *soundurl;
@property (nonatomic,copy) NSString *fileNameUrl;
-(void)startAudioAnimation;
-(void)stopAudioAnimation;

@end
