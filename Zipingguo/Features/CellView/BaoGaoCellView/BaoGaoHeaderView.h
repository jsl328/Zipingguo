//
//  BaoGaoHeaderView.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/28.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaoGaoHeaderViewModel;

@protocol BaoGaoHeaderViewDelegate <NSObject>

-(void)baoGaoHeaderViewSelected;

@end

@interface BaoGaoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jianTouImageView;
@property (weak, nonatomic) IBOutlet UILabel *shuZiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shangFenGeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *xiaFenGeImageView;
@property (weak, nonatomic) id<BaoGaoHeaderViewDelegate>delegate;
- (IBAction)buttonClick:(UIButton *)sender;


@property (nonatomic, strong) BaoGaoHeaderViewModel *model;


//目标动作机制
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
//用于记录，是哪一个
@property (nonatomic,assign) NSInteger index;


@end


@interface BaoGaoHeaderViewModel : NSObject

@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * ID;

@property (copy, nonatomic) NSString * shuzi;
@property (assign, nonatomic) BOOL isZhanKai;//是否展开

@end