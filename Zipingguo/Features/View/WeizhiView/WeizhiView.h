//
//  WeizhiView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeizhiView;
@protocol WeizhiViewDelegate <NSObject>

@optional

- (void)shanchuWeizhi:(WeizhiView *)address;

@end

@interface WeizhiView : UIView

@property (nonatomic, strong) id <WeizhiViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *shanchuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shuxian;

@property (weak, nonatomic) IBOutlet UILabel *weizhi;
@end
