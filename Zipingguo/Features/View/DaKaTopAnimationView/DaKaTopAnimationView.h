//
//  DaKaTopAnimationView.h
//  Zipingguo
//
//  Created by sunny on 15/10/14.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaKaTopAnimationView : UIView{
    NSArray *imageArray;
    IBOutlet UIImageView *animationImageView;
    IBOutlet UIImageView *animationImageView2;
    IBOutlet UIImageView *animationImageView3;
//    /// YES 白天 NO 晚上
//    BOOL currentDay;
}
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic,strong) NSTimer *topAnimationTimer;
@property (nonatomic,strong) NSTimer *topAnimationTimer2;

/**
 *  根据是白天还是晚上显示不同的动画
 *
 *  @param isDay YES是白天，NO是晚上
 */
- (void)showAnimationIsDay:(BOOL)isDay;

- (void)invalidateTimer;
@end
