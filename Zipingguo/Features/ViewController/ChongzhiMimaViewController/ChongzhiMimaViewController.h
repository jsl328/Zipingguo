//
//  ChongzhiMimaViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentsViewController.h"

@interface ChongzhiMimaViewController : ParentsViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isXiugaiMima;
@property (weak, nonatomic) IBOutlet UIImageView *tubiao;
@property (weak, nonatomic) IBOutlet UILabel *miaoshu;
@property (weak, nonatomic) IBOutlet UIView *daView;
@property (weak, nonatomic) IBOutlet UIView *daView2;
@property (weak, nonatomic) IBOutlet UITextField *yuanMima;
@property (weak, nonatomic) IBOutlet UITextField *xinmima;
@property (weak, nonatomic) IBOutlet UITextField *xinmima2;
@property (weak, nonatomic) IBOutlet UITextField *mima;
@property (weak, nonatomic) IBOutlet UIButton *qunrenbtn;

- (IBAction)buttonClick:(UIButton *)sender;
@end
