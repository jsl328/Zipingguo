//
//  ChongzhiShoujihaoViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface ChongzhiShoujihaoViewController : ParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIImageView *tubiao;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UILabel *haomaTishiLabel;
    __weak IBOutlet UIView *daView;
    __weak IBOutlet UITextField *shoujihaoTextField;
    __weak IBOutlet UITextField *yanzhengmaTextField;
    __weak IBOutlet UIButton *yanzhengmaBtn;
    __weak IBOutlet UIButton *querenBtn;
    
    __weak IBOutlet UILabel *daojishi;
    NSTimer *time;
    int index;
    
}

@property (nonatomic, strong) NSString *oldPassword;

@end
