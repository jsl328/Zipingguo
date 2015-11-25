//
//  KaiShiShengPiViewController.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "KaiShiShengPiViewController.h"
#import "Base64JiaJieMi.h"
#import "ResultModelShangchuanWenjianSM.h"
@interface KaiShiShengPiViewController ()

@end

@implementation KaiShiShengPiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)textChanged:(NSNotification *)notification
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:_neirongTextView];
    
    [shouxieBan clear];
    _huatuBanView=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"通过理由";
    [self addItemWithTitle:@"提交" imageName:@"" selector:@selector(rightItemClicked) location:NO];
    
    //添加导航
    _neirongTextView.placeholder = @"请在此输入理由(300字以内)";
    _neirongTextView.textContainerInset =UIEdgeInsetsMake(15, 15, 15, 15);
    _neirongTextView.placeholderColor =[UIColor colorWithRed:194./255. green:194./255 blue:194./255. alpha:1];
    _neirongTextView.font =[UIFont systemFontOfSize:14.f];
    //[_neirongTextView becomeFirstResponder];
    
    UISwipeGestureRecognizer *sw =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downDrection)];
    sw.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:sw];
}

-(void)downDrection
{
    [_neirongTextView resignFirstResponder];
}

-(void)rightItemClicked
{
    //提交
    NSLog(@"申请_id=%@",self.applyid);
    NSString *urlStr= [photoArray firstObject];
    if (self.isPass==1) {
        //不批准
        [ServiceShell getPassWithdealid:[AppStore getYongHuID] withStatus:1 withApplyid:self.applyid withcontent:_neirongTextView.text withhandwriteurl:urlStr withapssid:@"" usingCallback:^(DCServiceContext *context, ResultMode *model) {
            
            if (!context.isSucceeded) {
                return ;
            }
            
            if (model.status==0) {
                //修改数据库表格  通过
                self.passValueFromShengpi(model.status);
                [self showHint:@"审批通过"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if (model.status == 1){
                [SDialog showTipViewWithText:model.msg hideAfterSeconds:1.5f];
            }
        }];
    }else if(self.isPass==0){
        //批准
        [ServiceShell getPassWithdealid:[AppStore getYongHuID] withStatus:2 withApplyid:self.applyid withcontent:_neirongTextView.text withhandwriteurl:urlStr withapssid:@"" usingCallback:^(DCServiceContext *context, ResultMode *model) {
            
            if (!context.isSucceeded) {
                return ;
            }
            
            if (model.status==0) {
                self.passValueFromShengpi(model.status);
                [self showHint:@"审批未通过"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if (model.status == 1){
                [SDialog showTipViewWithText:model.msg hideAfterSeconds:1.5f];
            }
        }];
    }
}

- (IBAction)buttonOnclick:(UIButton *)sender {
    
    if (sender==_qingkongBtn) {
        //清空
		//[self expanderShouXieban];
        [_huatuBanView clear];
    }else{
		//上传
        photoArray=[NSMutableArray array];
        NSData *imageData = UIImageJPEGRepresentation(_huatuBanView.image,0.000001);
        [LDialog showWaitBox:@"提交签名中..."];
        NSString *imgStr = Base64_bianMa_DataToString(imageData);
        [ServiceShell getUploadWithImgNmae:@"shouxieban.png" ImgStr:imgStr usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM) {
            if (ItemSM.result == 0) {
                [_huatuBanView clear];
                [LDialog closeWaitBox];
                NSLog(@"图片路径:%@",ItemSM.data.url);
                [photoArray addObject:ItemSM.data.url];
                [_shangchuanBtn setTitleColor:RGBACOLOR(185, 215, 123, 1) forState:UIControlStateNormal];
                [_shangchuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
                [_shangchuanBtn setImage:[UIImage imageNamed:@"上传成功icon"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)addToolBar{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"键盘收起.png"] style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    UIBarButtonItem *LeftdoneButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"旁边分割线.png"] style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,LeftdoneButton,doneButton,nil];
    [topView setItems:buttonsArray];
    [_neirongTextView setInputAccessoryView:topView];
    
}

-(void)dismissKeyBoard
{
    [_neirongTextView resignFirstResponder];
	//打开手写版...
	//[self expanderShouXieban];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_neirongTextView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSMutableString *backText = [[NSMutableString  alloc] initWithString:textView.text];
    //拼接将要输入的内容
    [backText appendString:text];
    return backText.length <= 300;
}

@end
