//
//  YulanViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YulanViewController.h"

@interface YulanViewController ()

@end

@implementation YulanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查看附件";
    // Do any additional setup after loading the view from its nib.
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
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
}
@end
