//
//  ZanPingShanView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZanPingShanViewDelegate <NSObject>

@optional
- (void)shanchuFangfa;

- (void)dianzanFangfa;

- (void)quxiaoDianzanFangfa;

- (void)pinglunFangfa;

@end

@interface ZanPingShanView : UIView
@property (nonatomic, strong) id <ZanPingShanViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *shanchuBtn;
@property (weak, nonatomic) IBOutlet UILabel *addles;
@property (weak, nonatomic) IBOutlet UIButton *dianzanBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinglunBtn;

@end
