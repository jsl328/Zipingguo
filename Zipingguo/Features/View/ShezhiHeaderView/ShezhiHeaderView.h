//
//  ShezhiHeaderView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShezhiHeaderViewDelegate <NSObject>

- (void)gerenxinTiaozhuan;

@end

@interface ShezhiHeaderView : UIView
@property (nonatomic, strong) id <ShezhiHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *zhiwei;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonClick:(UIButton *)sender;
@end
