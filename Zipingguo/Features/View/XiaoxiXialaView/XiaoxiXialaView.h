//
//  XiaoxiXialaView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XiaoxiXialaViewDelegate <NSObject>

- (void)xinjianLiaotian;

- (void)kuansuDaka;

- (void)xinjianRibao;

- (void)xinjianRenwu;

@end

@interface XiaoxiXialaView : UIView
{
    __weak IBOutlet UIButton *liaotian;
    __weak IBOutlet UIButton *daka;
    __weak IBOutlet UIButton *ribao;
    __weak IBOutlet UIButton *renwu;
}

@property (nonatomic, strong) id <XiaoxiXialaViewDelegate> delegate;

@end
