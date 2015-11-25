//
//  GetYanZhengMaViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "GetYanZhengMaViewController.h"
#import "IQKeyboardManager.h"
#import "ZuZhiKuangJiaViewController.h"

@interface GetYanZhengMaViewController ()
{
    __weak IBOutlet UIButton *getYanZhengMaButton;
    NSInteger timeCount;
}
@end

@implementation GetYanZhengMaViewController
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
    phoneTF.text = [AppStore getYongHuShoujihao];
    timeCount = 60;//60秒
  
    [self fasongYanzhengma];
}
- (IBAction)finishButtonClick:(UIButton *)sender {
    if (yanZhengMaTF.text.length == 0) {
        [ToolBox Tanchujinggao:@"请输入验证码" IconName:nil];
        return;
    }
    [LDialog showWaitBox:@"验证验证码中"];
    [ZhuceServiceShell getRegCorpCheckCodeWithPhone:phoneTF.text PassWord:[AppStore getYongHuMima] Companyname:[AppStore getCompanyname] Code:yanZhengMaTF.text UsingCallback:^(DCServiceContext *context, RegCorpCheckCodeSM *sm) {
        [LDialog closeWaitBox];
        if (!context.isSucceeded) {
            return ;
        }
        if (sm.status == 0) {
            [AppStore setGongsiID:sm.data.companyid];
            [AppStore setYongHuID:sm.data.userid];
            [AppStore setYongHuMing:@""];
            [AppStore setZhiwei:@""];
            [AppStore setYonghuImageView:@""];
            ZuZhiKuangJiaViewController *addGroup = [[ZuZhiKuangJiaViewController alloc] init];
                        addGroup.isDenglu = YES;
            [self.navigationController pushViewController:addGroup animated:YES];
        }else{
            [ToolBox Tanchujinggao:@"验证码输入错误，请重新输入" IconName:nil];
        }
    }];
}


- (IBAction)getYanZhengMaButtonClick:(UIButton *)sender {
    [self fasongYanzhengma];
}

- (void)fasongYanzhengma{
    [ServiceShell employeeGetCodeWithPhone:[AppStore getYongHuShoujihao] Status:@"1" usingCallback:^(DCServiceContext *context, ResultModelOfGetCodeSM *sm) {
        if (!context.isSucceeded) {
            return ;
        }
        if (sm.status == 0) {
            timeCount = 60;
            getYanZhengMaButton.enabled = NO;
            [self daoJiShi];
            [ToolBox Tanchujinggao:@"验证码已发送,请注意查收" IconName:@"提醒_成功icon.png"];
        }
    }];
}

- (void)daoJiShi{
    if (timeCount==0) {
        timeCount = 60;
        getYanZhengMaButton.enabled = YES;
        [getYanZhengMaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    [getYanZhengMaButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取验证码",(long)timeCount] forState:UIControlStateDisabled];
    [self performSelector:@selector(showNextSecond) withObject:nil afterDelay:1];
}
- (void)showNextSecond{
   
    NSLog(@"%ld",(long)timeCount);
    timeCount --;
    [self daoJiShi];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    viewHeight.constant = ScreenHeight+1-64;
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
