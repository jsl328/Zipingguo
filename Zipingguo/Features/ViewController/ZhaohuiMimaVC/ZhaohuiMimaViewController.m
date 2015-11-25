//
//  ZhaohuiMimaViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZhaohuiMimaViewController.h"
#import "CustomTabbarController.h"
#import "WanshanZiliaoViewController.h"
#import "XuanzeGongsiViewController.h"
#import "ZuZhiKuangJiaViewController.h"
@interface ZhaohuiMimaViewController (){
    // 倒计时
    int index;
    NSTimer *timer;
}

@end

@implementation ZhaohuiMimaViewController

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
    shoujihao.text = _shoujihaoHaoma;
    // Do any additional setup after loading the view from its nib.
    countLabel.centerX = self.view.centerX;
    [self fasongYanzhengma];
    
    
}

- (void)fasongYanzhengma{
    [ServiceShell employeeGetCodeWithPhone:self.shoujihaoHaoma Status:@"2" usingCallback:^(DCServiceContext *context, ResultModelOfGetCodeSM *sm) {
        if (!context.isSucceeded) {
            return ;
        }
        if (sm.status == 0) {
            [ToolBox Tanchujinggao:@"验证码已发送,请注意查收" IconName:@"提醒_成功icon.png"];
            index = 60;
            countLabel.hidden = NO;
            countLabel.text = [NSString stringWithFormat:@"%d秒后重新获取验证码",index];
            chongxinHuoquBtn.hidden = YES;
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishiTime) userInfo:nil repeats:YES];
        }else{
            countLabel.hidden = YES;
            chongxinHuoquBtn.hidden = NO;
            [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(UIButton *)sender {

    if (sender == chongzhiBtn) {
        
        if (yanzhengma.text.length == 0) {
            [ToolBox Tanchujinggao:@"请输入验证码" IconName:nil];
            return;
        }
        if (xinmima.text.length < 6 || zaicimima.text.length < 6) {
            [ToolBox Tanchujinggao:@"密码不得少于6个字符，数字/字母/组合" IconName:nil];
            return ;
        }
        if (![xinmima.text isEqualToString:zaicimima.text]) {
            [ToolBox Tanchujinggao:@"两次密码不一致" IconName:nil];
            return ;
        }
        [LDialog showWaitBox:@"找回密码中"];
        [ZhuceServiceShell employeeFindlostPsdWithPhone:self.shoujihaoHaoma Password:[xinmima.text MD5Hash] Code:yanzhengma.text usingCallback:^(DCServiceContext *context, ResultMode *sm) {
            [LDialog closeWaitBox];
            if (!context.isSucceeded) {
                return ;
            }
            if (sm.status == 0) {
                [ToolBox Tanchujinggao:@"密码修改成功" IconName:nil DissMiss:^{
                    [ServiceShell DengLu:self.shoujihaoHaoma Password:[xinmima.text MD5Hash] Companyid:@"" usingCallback:^(DCServiceContext *context, DengluSM *itemSM) {
                        
                        if (!context.isSucceeded) {
                            return ;
                        }
                        if (itemSM.status == 0) {
                            
                            if ([itemSM.data1.loginStatus isEqualToString:@"CHOOSE_CORP"]) {//多公司
                                XuanzeGongsiViewController *xuanzeGongsi = [[XuanzeGongsiViewController alloc] init];
                                xuanzeGongsi.isDenglu = YES;
                                xuanzeGongsi.shoujihao = shoujihao.text;
                                xuanzeGongsi.mima = [xinmima.text MD5Hash];
                                xuanzeGongsi.gongsiArray = (NSMutableArray *)itemSM.data2;
                                [self.navigationController pushViewController:xuanzeGongsi animated:YES];
                                
                            }else if ([itemSM.data1.loginStatus isEqualToString:@"LOGIN_SUCCESS"]){//单公司
                                [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:[xinmima.text MD5Hash] IsWanshan:NO];
                                if (itemSM.data1.lackdeptinfo == 1) {//缺少组织架构
                                    ZuZhiKuangJiaViewController *addGroup = [[ZuZhiKuangJiaViewController alloc] init];
                                    [self.navigationController pushViewController:addGroup animated:YES];
                                }else if (itemSM.data1.lackdeptinfo == 0){//正常进入
                                    
                                    if (itemSM.data1.lackuserinfo == 1) {//缺少信息，进入完善信息
                                        WanshanZiliaoViewController *ziliaoVC = [[WanshanZiliaoViewController alloc] init];
                                        ziliaoVC.userdata = itemSM.data;
                                        [self.navigationController pushViewController:ziliaoVC animated:YES];
                                    }else if(itemSM.data1.lackuserinfo == 0){//正常进入，登录成功
                                        [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:[xinmima.text MD5Hash] IsWanshan:YES];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                    }
                                }
                            }
                        }else{
                            [ToolBox Tanchujinggao:itemSM.msg IconName:nil];
                        }
                    }];
                }];
                
            }else{
                [ToolBox Tanchujinggao:sm.msg IconName:nil];
            }
        }];
        
    }else if(sender == chongxinHuoquBtn){
        [self fasongYanzhengma];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)daojishiTime{
    index--;
    countLabel.text = [NSString stringWithFormat:@"%d秒后重新获取验证码",index];
    if (index == 0) {
        index = 60;
        countLabel.text = [NSString stringWithFormat:@"%d秒后重新获取验证码",index];
        chongxinHuoquBtn.hidden = NO;
        countLabel.hidden = YES;
        [timer invalidate];
        timer = nil;
    }
    
}
@end
