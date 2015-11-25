//
//  BianjiVC.m
//  Lvpingguo
//
//  Created by miao on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "BianjiVC.h"
#import "DCNavigationController.h"
#import "ShengpiDetailViewController.h"
@interface BianjiVC ()
{
    NSMutableString *shiyouStr;
}
@end

@implementation BianjiVC

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =@"转交理由";
    [self addItemWithTitle:@"转交" imageName:@"" selector:@selector(rightItemClicked) location:NO];
    
    _TextView.delegate = self;
    _TextView.placeholder = @"请输入转交理由(1000字以内)";
    _TextView.textContainerInset =UIEdgeInsetsMake(15, 15, 15, 15);
    _TextView.placeholderColor =[UIColor colorWithRed:194./255. green:194./255 blue:194./255. alpha:1];
    _TextView.font =[UIFont systemFontOfSize:14.f];
    
    if (!_chuanzhiNeirong) {
        _chuanzhiNeirong =@"";
    }else{
        shiyouStr =[[NSMutableString alloc]initWithString:_chuanzhiNeirong];
    }
    
    //NSLog(@"%@",_chuanzhiNeirong);
    _TextView.text =[NSString stringWithFormat:@"%@",_chuanzhiNeirong];
    bijiArr=[[NSMutableArray alloc]init];
}

-(void)rightItemClicked
{
    
    
    NSString *urlStr=_TextView.text;
    //转交
    [ServiceShell getPassWithdealid:[AppStore getYongHuID] withStatus:4 withApplyid:self.applyid withcontent:_TextView.text withIDarray:self.ID withPeopleImageUrl:urlStr usingCallback:^(DCServiceContext *context, ResultMode *result) {
        
        if (!context.isSucceeded) {
            return ;
        }
        
        if (result.status == 0) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            
            [nc postNotificationName:@"zhuanjiaoFanhui" object:nil userInfo:nil];
            
            [self showHint:@"转交成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else if (result.status == 1){
            [SDialog showTipViewWithText:result.msg hideAfterSeconds:1.5f];
        }
    }];
}

- (void)canMoveBack{
    
}

- (void)pop{
    [AppContext pop];
}

- (void)DaohanglanViewLeftBtnFangfaIsPush:(BOOL)isPush{
    
    [_TextView resignFirstResponder];
    if ([self.biaotiTitle isEqualToString:@"反馈"]) {
        if (_TextView.text.length!=0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"确定退出？退出后您所编辑的内容将丢失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
        }else{
            [self performSelector:@selector(pop) withObject:nil afterDelay:0.3];
        }
        
    }else{
        UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存草稿",@"不保存", nil];
        action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [action showInView:self.view];

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.3];
    }else{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSMutableString *backText = [[NSMutableString  alloc] initWithString:textView.text];
//    //拼接将要输入的内容
//    [backText appendString:text];
//    
//    return backText.length <= 200;
//}

-(void)DaohanglanViewRightBtnFangfa
{
//    [self dismissKeyBoard];
    if ([self.biaotiTitle isEqualToString:@"意见反馈"]) {
        if (_TextView.text.length > 0) {
//            [ServiceShell getCreateFeedbackWithID:[AppStore getYongHuID] ConTent:_TextView.text usingCallback:^(DCServiceContext *serviceContext, ResultModelOfFeedbackSM *feedbackSM) {
//                if (feedbackSM.status == 0) {
//                    [LDialog showMessage:feedbackSM.msg ok:^{
//                        [AppContext pop];
//                    }];
//                }
//            }];
        }else{
            
            [SDialog showTipViewWithText:@"请输入反馈内容" hideAfterSeconds:1.5f];
        }
        
    }else{
        if (_TextView.text.length ==0) {
            
            [self.delegate beizhuneorong:@"" withIndex:_indexFlag];
        }else{
        
            [self.delegate beizhuneorong:_TextView.text withIndex:_indexFlag];
        }
        
        [AppContext pop];

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
    [self.TextView setInputAccessoryView:topView];
}

-(void)dismissKeyBoard
{
    [self.TextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[self.TextView resignFirstResponder];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        [self.delegate beizhuneorong:_TextView.text withIndex:_indexFlag];
        [AppContext pop];
    }else if (buttonIndex==1){
        [AppContext pop];
    }
}

@end
