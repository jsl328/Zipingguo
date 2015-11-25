//
//  DengluViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DengluViewController.h"
#import "CustomTabbarController.h"
#import "WangjiMimaViewController.h"
#import "XuanzeGongsiViewController.h"
#import "RegisterViewController.h"
#import "WanshanZiliaoViewController.h"
#import "ZuZhiKuangJiaViewController.h"
#import "ToolBox.h"
@interface DengluViewController ()

@end

@implementation DengluViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone = [defaults objectForKey:@"phone"];
    if (phone.length != 0) {
        shoujihao.text  = phone;
    }
    [self customBackItemWithImage:nil Color:nil IsHidden:YES];
    
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
    
    if (sender == dengluBtn) {
        [shoujihao resignFirstResponder];
        [mima resignFirstResponder];
        if (![ToolBox checkPhoneNumInput:shoujihao.text]) {
            [ToolBox Tanchujinggao:@"请正确填写手机号，手机号码为11位数字" IconName:nil];
            return ;

        }
        if (mima.text.length < 6 ) {
            [ToolBox Tanchujinggao:@"密码不得少于6个字符，数字/字母/组合" IconName:nil];
            return ;
        }
        [LDialog showWaitBox:@"登录中"];
        [ServiceShell DengLu:shoujihao.text Password:[mima.text MD5Hash] Companyid:@"" usingCallback:^(DCServiceContext *context, DengluSM *itemSM) {
            [LDialog closeWaitBox];
            if (!context.isSucceeded) {
                [ToolBox Tanchujinggao:@"服务器忙" IconName:nil];
                return ;
            }
            if (itemSM.status == 0) {
                
                if ([itemSM.data1.loginStatus isEqualToString:@"CHOOSE_CORP"]) {//多公司
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:shoujihao.text forKey:@"phone"];
                    [userDefaults synchronize];
                    XuanzeGongsiViewController *xuanzeGongsi = [[XuanzeGongsiViewController alloc] init];
                    xuanzeGongsi.isDenglu = YES;
                    xuanzeGongsi.shoujihao = shoujihao.text;
                    xuanzeGongsi.mima = [mima.text MD5Hash];
                    xuanzeGongsi.gongsiArray = (NSMutableArray *)itemSM.data2;
                    [self.navigationController pushViewController:xuanzeGongsi animated:YES];
                    
                }else if ([itemSM.data1.loginStatus isEqualToString:@"LOGIN_SUCCESS"]){//单公司
                    [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:[mima.text MD5Hash] IsWanshan:NO];
                    if (itemSM.data1.lackdeptinfo == 1) {//缺少组织架构
                        ZuZhiKuangJiaViewController *addGroup = [[ZuZhiKuangJiaViewController alloc] init];
                        [self.navigationController pushViewController:addGroup animated:YES];
                    }else if (itemSM.data1.lackdeptinfo == 0){//正常进入
                        
                        if (itemSM.data1.lackuserinfo == 1) {//缺少信息，进入完善信息
                            WanshanZiliaoViewController *ziliaoVC = [[WanshanZiliaoViewController alloc] init];
                            ziliaoVC.userdata = itemSM.data;
                            [self.navigationController pushViewController:ziliaoVC animated:YES];
                        }else if(itemSM.data1.lackuserinfo == 0){//正常进入，登录成功
                            
                     
                            
                            [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:[mima.text MD5Hash] IsWanshan:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                        }
                    }
                    
                }
                
                
            }else{
                [ToolBox Tanchujinggao:itemSM.msg IconName:nil];
//                shoujihao.clearsOnBeginEditing = YES;
//                mima.clearsOnBeginEditing = YES;
            }
        }];
        
    }else if (sender == zhuceBtn){
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if (sender == wangjiMimaBtn){
        WangjiMimaViewController *wangjiMimaVC = [[WangjiMimaViewController alloc] init];
        [self.navigationController pushViewController:wangjiMimaVC animated:YES];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    zhuceBtn.frame = CGRectMake(zhuceBtn.frame.origin.x, ScreenHeight-27-zhuceBtn.frame.size.height, zhuceBtn.frame.size.width, zhuceBtn.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == shoujihao) {
//        shoujihao.clearsOnBeginEditing = NO;
//    }else if (textField == mima){
//        mima.clearsOnBeginEditing = NO;
//    }
//}

@end
