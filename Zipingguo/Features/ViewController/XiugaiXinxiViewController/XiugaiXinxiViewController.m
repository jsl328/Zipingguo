//
//  XiugaiXinxiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiugaiXinxiViewController.h"

@interface XiugaiXinxiViewController ()<UITextFieldDelegate>

@end

@implementation XiugaiXinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addItemWithTitle:@"提交" imageName:@"" selector:@selector(xiugaiSelector) location:NO];
    self.navigationItem.title = [NSString stringWithFormat:@"修改%@",self.titleText];
    _xiugaiXinxi.placeholder = [NSString stringWithFormat:@"请输入%@",self.titleText];
    _xiugaiXinxi.delegate = self;
    
    _xiugaiXinxi.text = _chuanzhiStr;
    [_xiugaiXinxi becomeFirstResponder];
    
    if ([self.titleText isEqualToString:@"QQ号"]) {
        _xiugaiXinxi.keyboardType = UIKeyboardTypePhonePad;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)xiugaiSelector{
    
    if (self.returnValue != nil) {
        self.returnValue(_xiugaiXinxi.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _xiugaiView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    _xiugaiView.layer.masksToBounds = YES;
    _xiugaiView.layer.borderColor = RGBACOLOR(239, 239, 244, 1).CGColor;
    _xiugaiView.layer.borderWidth = 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_xiugaiXinxi resignFirstResponder];
}


-(void)returnText:(ReturnValueBlock)value{
    self.returnValue = value;
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
