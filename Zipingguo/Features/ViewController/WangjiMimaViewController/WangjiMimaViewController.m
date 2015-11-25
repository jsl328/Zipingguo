//
//  WangjiMimaViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WangjiMimaViewController.h"
#import "ZhaohuiMimaViewController.h"
@interface WangjiMimaViewController ()

@end

@implementation WangjiMimaViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
}

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == tijiaoBtn) {
        if (![ToolBox checkPhoneNumInput:shoujihao.text]) {
            [ToolBox Tanchujinggao:@"请正确填写手机号，手机号码为11位数字" IconName:nil];
            return;
        }
        ZhaohuiMimaViewController *zhaohuiMima = [[ZhaohuiMimaViewController alloc] init];
        zhaohuiMima.shoujihaoHaoma = shoujihao.text;
        [self.navigationController pushViewController:zhaohuiMima animated:YES];
    }
}

@end
