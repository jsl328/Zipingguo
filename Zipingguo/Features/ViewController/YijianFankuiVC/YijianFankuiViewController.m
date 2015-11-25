//
//  YijianFankuiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YijianFankuiViewController.h"

@interface YijianFankuiViewController ()

@end

@implementation YijianFankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    fankuiTextView.placeholder = @"您的建议是雅米前进的动力，有了您的帮助我们会更加完美产品，为您提供更好的服务";
    
    [self addItemWithTitle:@"提交" imageName:nil selector:@selector(rightSelector) location:NO];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)rightSelector{
    [ServiceShell getCreateFeedbackWithID:[AppStore getYongHuID] ConTent:fankuiTextView.text usingCallback:^(DCServiceContext *serviceContext, ResultModelOfFeedbackSM *feedbackSM) {
        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        if (feedbackSM.status == 0) {
            [self showHint:@"感谢您的反馈"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
