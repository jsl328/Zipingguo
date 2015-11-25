//
//  WodexinxiHeaderView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WodexinxiHeaderViewDelegate <NSObject>

- (void)touxiangShangchuan;

@end

@interface WodexinxiHeaderView : UIView

@property (nonatomic, strong) id <WodexinxiHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *touxiang;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *touxiangBtn;

@end
