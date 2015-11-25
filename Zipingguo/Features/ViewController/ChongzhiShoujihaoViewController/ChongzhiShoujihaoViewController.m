//
//  ChongzhiShoujihaoViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ChongzhiShoujihaoViewController.h"

@interface ChongzhiShoujihaoViewController ()

@end

@implementation ChongzhiShoujihaoViewController


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzhengmatextFieldChanged) name:UITextFieldTextDidChangeNotification object:yanzhengmaTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoujihaotextFieldChanged) name:UITextFieldTextDidChangeNotification object:shoujihaoTextField];
    
    self.navigationItem.title = @"重置手机号";
    
    daojishi.layer.cornerRadius = 5.0f;
    daojishi.layer.masksToBounds = YES;
    
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:[AppStore getYongHuShoujihao]];
    [mStr replaceCharactersInRange:NSMakeRange(2, 7) withString:@"*******"];
    haomaTishiLabel.text = [NSString stringWithFormat:@"当前手机号为%@",mStr];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)shoujihaotextFieldChanged{
    
    if (shoujihaoTextField.text.length == 11) {
        [yanzhengmaBtn setBackgroundImage:[UIImage imageNamed:@"验证码button"] forState:UIControlStateNormal];
        yanzhengmaBtn.enabled = YES;
    }else{
        yanzhengmaBtn.enabled = NO;
        [yanzhengmaBtn setBackgroundImage:[UIImage imageNamed:@"确认button-不可点"] forState:UIControlStateNormal];
    }
}

- (void)yanzhengmatextFieldChanged{
    if (yanzhengmaTextField.text.length == 6) {
        querenBtn.enabled = YES;
        [querenBtn setBackgroundImage:[UIImage imageNamed:@"确认button"]forState:UIControlStateNormal];
    }else{
        querenBtn.enabled = NO;
        [querenBtn setBackgroundImage:[UIImage imageNamed:@"确认button-不可点.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    tubiao.frame = CGRectMake((ScreenWidth-72)/2, 28, 72, 72);
    
    daView.layer.borderColor = RGBACOLOR(239, 239, 244, 1).CGColor;
    daView.layer.borderWidth = 1;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self pingmuXiayi];
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shoujihaoTextField resignFirstResponder];
    [yanzhengmaTextField resignFirstResponder];
    [self pingmuXiayi];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [scrollView setContentOffset:CGPointMake(0, 220) animated:YES];
    return YES;
}

- (void)pingmuXiayi{
//    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
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
    if (sender == yanzhengmaBtn) {
        yanzhengmaBtn.hidden = YES;
        daojishi.hidden = NO;
        index = 60;
        daojishi.text = [NSString stringWithFormat:@"重新获取(%d)",index];
        [LDialog showWaitBox:@"发送验证码中"];
        [ServiceShell employeeGetCodeWithPhone:shoujihaoTextField.text Status:@"3" usingCallback:^(DCServiceContext *serviceContext, ResultModelOfGetCodeSM *getCodeSM){
            [LDialog closeWaitBox];
            if (!serviceContext.isSucceeded) {
                return ;
            }
            if (getCodeSM.status == 0) {
                
                 [ToolBox Tanchujinggao:@"验证码已发送,请注意查收" IconName:@"提醒_成功icon.png"];
            }else{
                [ToolBox Tanchujinggao:getCodeSM.msg IconName:nil];
            }
            [self createTime];
        }];
        
        
    }else if (sender == querenBtn){
        [LDialog showWaitBox:@"修改手机号中"];
        [ServiceShell employeeGetCodeWithPhone:shoujihaoTextField.text Code:yanzhengmaTextField.text usingCallback:^(DCServiceContext *serviceContext, ResultMode *model){
            [LDialog closeWaitBox];
            if (!serviceContext.isSucceeded) {
                return ;
            }
            if (model.status == 0) {
                [ServiceShell getResetPhoneWithID:[AppStore getYongHuID] Phone:shoujihaoTextField.text OldPassword:_oldPassword usingCallback:^(DCServiceContext *serviceContext, ResultMode *resetPhoneSM){
                    if (!serviceContext.isSucceeded) {
                        return ;
                    }
                    
                    if (resetPhoneSM.status == 0) {
                        yanzhengmaBtn.hidden = NO;
                        daojishi.hidden = YES;
                        [time invalidate];
                        time = nil;
                        [ToolBox Tanchujinggao:@"重置手机号成功，请重新登录" IconName:@"提醒_成功icon.png" DissMiss:^{
                            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
                                NSLog(@"info%@",info);
                                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                            } onQueue:nil];
                        }];
                        
                    }else if (resetPhoneSM.status == 1){
                        [self jingdaoTishi:resetPhoneSM.msg];
                    }
                    
                }];
            }else if (model.status == 1){
                [self jingdaoTishi:model.msg];
            }
        }];
    }
}

- (void)jingdaoTishi:(NSString *)tishi{
    
    [ToolBox Tanchujinggao:tishi IconName:nil];
}

- (void)createTime{
    time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishiTime) userInfo:nil repeats:YES];
}

- (void)daojishiTime{
    index--;
    daojishi.text = [NSString stringWithFormat:@"重新获取(%d)",index];
    if (index == 0) {
        index = 60;
        daojishi.text = [NSString stringWithFormat:@"重新获取(%d)",index];
        yanzhengmaBtn.hidden = NO;
        daojishi.hidden = YES;
        [time invalidate];
        time = nil;
    }
    
}

@end
