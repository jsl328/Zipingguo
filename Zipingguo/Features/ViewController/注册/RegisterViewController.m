//
//  RegisterViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RegisterViewController.h"
#import "IQKeyboardManager.h"
#import "GetYanZhengMaViewController.h"
#import "UIKeyboardCoView.h"
#import "ZuZhiKuangJiaViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
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
    phoneTF.keyboardType = UIKeyboardTypePhonePad;
    miMaTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    viewHeight.constant = ScreenHeight+1-64;

}
- (IBAction)registerButtonClick:(UIButton *)sender {
    if (phoneTF.text.length!=11) {
        [ToolBox Tanchujinggao:@"请正确填写手机号，手机号码为11位数字" IconName:nil];
        return;
    }
   
    if (miMaTF.text.length<6) {
        [ToolBox Tanchujinggao:@"密码不得少于6个字符，数字、字母组合" IconName:nil];
        return;
    }
    [LDialog showWaitBox:@"注册中"];
    [ZhuceServiceShell getRegCorpCheckWithPhone:phoneTF.text PassWord:[miMaTF.text MD5Hash]  Companyname:companyNameTF.text UsingCallback:^(DCServiceContext *context, ResultMode *sm) {
        [LDialog closeWaitBox];
        if (!context.isSucceeded) {
            return ;
        }
        if (sm.status == 0) {
            [AppStore setYongHuShoujihao:phoneTF.text];
            [AppStore setCompanyname:companyNameTF.text];
            [AppStore setYongHuMima:[miMaTF.text MD5Hash]];
            GetYanZhengMaViewController *vc = [GetYanZhengMaViewController alloc].init;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [ToolBox Tanchujinggao:sm.msg IconName:nil];
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
