//
//  EditRenWuNameViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "EditRenWuNameViewController.h"
#import "RenWuServiceShell.h"

@interface EditRenWuNameViewController ()

@end

@implementation EditRenWuNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"任务名称";
    [self addItemWithTitle:@"提交" imageName:@"" selector:@selector(tiJiaoClick) location:NO];
    nameTF.text = self.oldContent;
    
}
- (void)tiJiaoClick{
    if (!nameTF.text.length) {
        [SDialog showTipViewWithText:@"任务名称不能为空" hideAfterSeconds:1];
        return;
    }
    if (self.isXinjian) {
        if (self.editFinish) {
            self.editFinish(nameTF.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if (self.editFinish) {
            self.editFinish(nameTF.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [nameTF resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [nameTF resignFirstResponder];
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
