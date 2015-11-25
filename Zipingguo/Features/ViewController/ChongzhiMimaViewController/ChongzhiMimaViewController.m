//
//  ChongzhiMimaViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ChongzhiMimaViewController.h"
#import "ChongzhiShoujihaoViewController.h"

@interface ChongzhiMimaViewController ()<UITextFieldDelegate>

@end

@implementation ChongzhiMimaViewController

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
    
    if (self.isXiugaiMima) {
        _daView.hidden = NO;
        self.navigationItem.title = @"重置密码";
        _miaoshu.text = @"为了保障您的数据安全，修改密码前请填写原密码";
        _tubiao.image = [UIImage imageNamed:@"密码icon"];
    }else{
        _daView2.hidden = NO;
        self.navigationItem.title = @"验证密码";
        _miaoshu.text = @"为了保障您的数据安全,重置手机号前请填写密码";
        _tubiao.image = [UIImage imageNamed:@"手机icon"];
    }
    _yuanMima.delegate = self;
    _xinmima.delegate = self;
    _xinmima2.delegate = self;
    _mima.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    _tubiao.frame = CGRectMake((ScreenWidth-72)/2, 28, 72, 72);
    if (self.isXiugaiMima) {
        _qunrenbtn.frame = CGRectMake(15, _daView.frame.origin.y+_daView.frame.size.height+46, ScreenWidth-30, 50);
        _daView.layer.masksToBounds = YES;
        _daView.layer.borderColor = RGBACOLOR(239, 239, 244, 1).CGColor;
        _daView.layer.borderWidth = 1;
    }else{
        _qunrenbtn.frame = CGRectMake(15, _daView2.frame.origin.y+_daView2.frame.size.height+46, ScreenWidth-30, 50);
        _daView2.layer.masksToBounds = YES;
        _daView2.layer.borderColor = RGBACOLOR(239, 239, 244, 1).CGColor;
        _daView2.layer.borderWidth = 1;
    }
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight+20)];
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (self.isXiugaiMima) {
        
        if (_yuanMima.text.length == 0 || _xinmima.text.length == 0 || _xinmima2.text.length == 0) {
            [self jingdaoTishi:@"请填写完所有信息，再进行修改"];
            return;
        }
        
        if ([_xinmima.text isEqualToString:_xinmima2.text]) {
            
            if (![[_yuanMima.text MD5Hash] isEqualToString:[AppStore getYongHuMima]]) {
                [self jingdaoTishi:@"原密码输入错误，请重新输入"];
                [_yuanMima becomeFirstResponder];
                return;
            }
            
            [LDialog showWaitBox:@"修改密码中"];
            [ServiceShell getResetPwdWithID:[AppStore getYongHuID] Password:[_xinmima.text MD5Hash] oldPassword:[_yuanMima.text MD5Hash] usingCallback:^(DCServiceContext *serviceContext, ResultMode *resetPwdSM) {
                [LDialog closeWaitBox];
                if (!serviceContext.isSucceeded) {
                    return ;
                }
                
                if (resetPwdSM.status == 0) {
                    
                    [ToolBox Tanchujinggao:@"重置密码成功，请重新登录" IconName:@"提醒_成功icon.png" DissMiss:^{
                        
                        [_xinmima resignFirstResponder];
                        [_xinmima2 resignFirstResponder];
                        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
                            NSLog(@"info%@",info);
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                        } onQueue:nil];
                    }];

                }else if(resetPwdSM.status == 1){
                    [self jingdaoTishi:@"输入信息有误，请重新输入"];
                }
                
            }];
        }else{
            [self jingdaoTishi:@"新密码输入不一致，请重新输入"];
        }
    }else{
        if (![[_mima.text MD5Hash] isEqualToString:[AppStore getYongHuMima]]) {
            [self jingdaoTishi:@"密码输入错误，请重新输入"];
            return;
        }
        [LDialog showWaitBox:@"验证密码中"];
        [ServiceShell getResetPwdCheckOldPwdWithID:[AppStore getYongHuID] oldPassword:[_mima.text MD5Hash] usingCallback:^(DCServiceContext *serviceContext, ResultMode *resetPwdSM) {
            [LDialog closeWaitBox];
            if (!serviceContext.isSucceeded) {
                return ;
            }
            
            if (resetPwdSM.status == 0) {
                ChongzhiShoujihaoViewController *chongzhiShoujihao = [[ChongzhiShoujihaoViewController alloc] init];
                chongzhiShoujihao.oldPassword = [_mima.text MD5Hash];
                [self.navigationController pushViewController:chongzhiShoujihao animated:YES];
                [_mima resignFirstResponder];
            }else if(resetPwdSM.status == 1){
                [self jingdaoTishi:resetPwdSM.msg];
            }
            
        }];
    }
}

- (void)jingdaoTishi:(NSString *)tishi{
    
    [ToolBox Tanchujinggao:tishi IconName:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [self.scrollView setContentOffset:CGPointMake(0, 195) animated:YES];
    return YES;
}


@end
