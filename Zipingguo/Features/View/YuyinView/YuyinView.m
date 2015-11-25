//
//  YuyinView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YuyinView.h"
#import "EMChatAudioBubbleView.h"

@implementation YuyinView
- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YuyinView" owner:self options:nil]lastObject];
    }
    _recevierAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
    _yinliangImageView.animationDuration = ANIMATION_IMAGEVIEW_SPEED;
    _yinliangImageView.animationImages = _recevierAnimationImages;
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonClick:(UIButton *)sender {
    
    [self.delegate ShanchuYuyin:self];
}

- (IBAction)bofangClick:(id)sender {
    
    [self.delegate bofangFangfa:self.bofangBtn.tag Yuyin:self];
    
//    [self.delegate BofangYuyin:self];
    
}

-(void)startAudioAnimation
{
    [_yinliangImageView startAnimating];
}

-(void)stopAudioAnimation
{
    [_yinliangImageView stopAnimating];
}

@end
