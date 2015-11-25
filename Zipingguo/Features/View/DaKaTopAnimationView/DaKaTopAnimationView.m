//
//  DaKaTopAnimationView.m
//  Zipingguo
//
//  Created by sunny on 15/10/14.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "DaKaTopAnimationView.h"

@implementation DaKaTopAnimationView
@synthesize topAnimationTimer,bgImageView,topAnimationTimer2;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DaKaTopAnimationView" owner:self options:nil] lastObject];
        imageArray = [NSArray array];
    }
    return self;
}
- (void)showAnimationIsDay:(BOOL)isDay{
    [self invalidateTimer];
    if (isDay) {
        animationImageView.hidden = NO;
        animationImageView.alpha = 1;
        animationImageView.frame = CGRectMake(0, 0, ScreenWidth, animationImageView.height);
        animationImageView2.hidden = NO;
        animationImageView3.hidden = YES;
        animationImageView.alpha = 1;
        animationImageView2.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, animationImageView2.height);
        bgImageView.image = [UIImage imageNamed:@"背景白天.png"];
        topAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(animationStartDay) userInfo:nil repeats:YES];
    }else{
        animationImageView2.hidden = NO;
        animationImageView3.hidden = NO;
        animationImageView.hidden = NO;
        animationImageView.frame = CGRectMake(0, 0, ScreenWidth, animationImageView.height);
        animationImageView2.frame = CGRectMake(0, 0, ScreenWidth, animationImageView2.height);
        animationImageView3.frame = CGRectMake(0, 0, ScreenWidth, animationImageView3.height);
        animationImageView.image = [UIImage imageNamed:@"星星1.png"];
        animationImageView2.image = [UIImage imageNamed:@"星星2.png"];
        animationImageView3.image = [UIImage imageNamed:@"星星3.png"];
        animationImageView.alpha = 1;
        animationImageView2.alpha = 0.3;
        animationImageView3.alpha = 0.2;
        topAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.4f target:self selector:@selector(animationStartNight1) userInfo:nil repeats:YES];
        topAnimationTimer2 = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(animationStartNight2) userInfo:nil repeats:YES];
         bgImageView.image = [UIImage imageNamed:@"背景.png"];

    }
   
}
- (void)animationStartDay{
    animationImageView.image = [UIImage imageNamed:@"云.png"];
    animationImageView2.image = [UIImage imageNamed:@"云.png"];
    if (animationImageView.x >= ScreenWidth) {
        animationImageView.x = -ScreenWidth;
    }
    if (animationImageView2.x > ScreenWidth) {
        animationImageView2.x = -ScreenWidth;
    }
    animationImageView.x = animationImageView.x + 0.1;
    animationImageView2.x = animationImageView2.x + 0.1;


//    [UIView animateWithDuration:1 animations:^{
//        self.alpha = 0.1;
//    } completion:^(BOOL finished) {
//        
//    }];
}
- (void)animationStartNight1{
    animationImageView.image = [UIImage imageNamed:@"星星1.png"];
    animationImageView2.image = [UIImage imageNamed:@"星星2.png"];
    animationImageView3.image = [UIImage imageNamed:@"星星3.png"];
    animationImageView.alpha = 1;
    animationImageView2.alpha = 0.3;
    animationImageView3.alpha = 0.2;
    [UIView animateWithDuration:0.7 animations:^{
        animationImageView.alpha = 0.2;
        animationImageView2.alpha = 1;
        animationImageView3.alpha = 0.95;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 animations:^{
            animationImageView.alpha = 1;
            animationImageView2.alpha = 0.3;
            animationImageView3.alpha = 0.2;
        } completion:^(BOOL finished) {
            
        }];

    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        animationImageView2.alpha = 1;
//        animationImageView3.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 animations:^{
//            animationImageView2.alpha = 0.2;
//            animationImageView3.alpha = 0.2;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }];
//    //_imageView连续播放多张图片
//    //设置动画数组
//    animationImageView.animationImages = imageArray;
//    //设置播放周期（播放一组图片周期）
//    animationImageView.animationDuration = 2;
//    //设置播放的次数
//    animationImageView.animationRepeatCount = 0;
//    //启动动画
//    [animationImageView startAnimating];


//    [UIView animateWithDuration:1 animations:^{
//        self.alpha = 0.1;
//    } completion:^(BOOL finished) {
//        
//    }];
}
- (void)animationStartNight2{
    animationImageView.image = [UIImage imageNamed:@"星星1.png"];
    animationImageView2.image = [UIImage imageNamed:@"星星2.png"];
    animationImageView3.image = [UIImage imageNamed:@"星星3.png"];
    animationImageView.alpha = 0.5;
    animationImageView2.alpha = 1;
    animationImageView3.alpha = 0.5;
    [self performSelector:@selector(ss) withObject:nil afterDelay:0.5];
}
- (void)ss{
    [UIView animateWithDuration:0.5 animations:^{
        animationImageView.alpha = 1;
        animationImageView2.alpha = 0.5;
        animationImageView3.alpha = 0.25;
    } completion:^(BOOL finished) {
        
    }];

}
- (void)invalidateTimer{
    if (topAnimationTimer) {
        [topAnimationTimer invalidate];
        topAnimationTimer = nil;
    }
    if (topAnimationTimer2) {
        [topAnimationTimer2 invalidate];
        topAnimationTimer2 = nil;
    }
//    if (currentDay) {
//        animationImageView.hidden = NO;
//        animationImageView.alpha = 1;
//        animationImageView.frame = CGRectMake(0, 0, ScreenWidth, animationImageView.height);
//        animationImageView2.hidden = NO;
//        animationImageView3.hidden = YES;
//        animationImageView.alpha = 1;
//        animationImageView2.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, animationImageView2.height);
//        bgImageView.image = [UIImage imageNamed:@"背景白天.png"];
//    }else{
//        animationImageView2.hidden = NO;
//        animationImageView3.hidden = NO;
//        animationImageView.hidden = NO;
//        animationImageView.frame = CGRectMake(0, 0, ScreenWidth, animationImageView.height);
//        animationImageView2.frame = CGRectMake(0, 0, ScreenWidth, animationImageView2.height);
//        animationImageView3.frame = CGRectMake(0, 0, ScreenWidth, animationImageView3.height);
//        animationImageView.image = [UIImage imageNamed:@"星星1.png"];
//        animationImageView2.image = [UIImage imageNamed:@"星星2.png"];
//        animationImageView3.image = [UIImage imageNamed:@"星星3.png"];
//        animationImageView.alpha = 1;
//        animationImageView2.alpha = 0.3;
//        animationImageView3.alpha = 0.2;
//        bgImageView.image = [UIImage imageNamed:@"背景.png"];
//    }
}
@end
