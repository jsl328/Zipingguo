//
//  DituCellView.h
//  CeshiOA
//
//  Created by jiangshilin on 14-8-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DituCellViewVM.h"
@interface DituCellView : UIView
{
    DituCellViewVM *viewVM;
}
@property (strong, nonatomic) IBOutlet UIImageView *tubiaoImageView;
@property (strong, nonatomic) IBOutlet UILabel *dizhiXinxiLabel;
@property (strong, nonatomic) IBOutlet UILabel *jutiXinxiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xianImageView;

@end
