//
//  WanshanZiliaoViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WanshanZiliaoViewController.h"
#import "CustomTabbarController.h"
#import "CustomActionSheet.h"
#import "Base64JiaJieMi.h"
#import "UIImage+UIImageCategory.h"
#import "XuanZeCengJiViewController.h"
@interface WanshanZiliaoViewController ()<CustomActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *imgurl;
    NSString *deptid;
    FXBlurView *blurView;
    XuanZeCengJiViewController *selectCengJiVC;
    
    UITextField *_textField;
}
@end

@implementation WanshanZiliaoViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

// 设置模糊背景
- (void)setViewBlur{
    if (!blurView) {
        blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissBgView)]];
        [blurView setDynamic:YES];
        blurView.blurRadius = 8;
        blurView.tintColor = [UIColor clearColor];
        [ShareApp.window addSubview:blurView];
        blurView.hidden = YES;
        selectCengJiVC = [[XuanZeCengJiViewController alloc] init];
        selectCengJiVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        __block WanshanZiliaoViewController *blSelf = self;
        selectCengJiVC.quXiaoBlock = ^(){
            [blSelf disMissBgView];
        };
        selectCengJiVC.passValueFromXuanze = ^(NSString* buMen,NSString *deptId){
            blSelf->deptid = deptId;
            blSelf->bumen.text = buMen;
            [blSelf disMissBgView];
        };
        [blurView addSubview:selectCengJiVC.view];
    }
}
// 点击模糊的背景消失
- (void)disMissBgView {
//    selectCengJiVC.view.hidden = YES;
    blurView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backbtn.hidden = YES;
    gongsiName.text = [AppStore getCompanyname];
    name.text = [AppStore getYongHuMing];
    zhiwei.text = [AppStore getZhiwei];
    bumen.text = self.userdata.deptname;
    youxiang.text = self.userdata.email;
    gonghao.text = self.userdata.jobnumber;
    deptid = self.userdata.deptid;
 
    if (!self.isDenglu) {
        self.navigationItem.title = @"完善资料";
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                        UITextAttributeFont : [UIFont systemFontOfSize:16]};
        
        
        [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (IS_IPHONE_4S) {
         scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+100);
    }
   
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
    [self resign];
    if (sender == xiangjiBtn) {
        [self creatActionSheet];
    }else if (sender == wanchengBtn){
        
        if (name.text.length == 0 || zhiwei.text.length == 0 || deptid.length == 0) {
            [self tanchuJinggao:@"姓名、部门、职位为必填项"];
            return;
        }
        
        if (name.text.length > 20) {
            [self tanchuJinggao:@"名字过长,请重新输入"];
            return;
        }
        if (zhiwei.text.length > 20){
            [self tanchuJinggao:@"职位名称过长,请重新输入"];
            return;
        }
        if (gonghao.text.length > 20){
            [self tanchuJinggao:@"工号过长,请重新输入"];
            return;
        }
        if (youxiang.text.length > 20){
            [self tanchuJinggao:@"邮箱过长,请重新输入"];
            return;
        }
        
        FirstLoginPerfectInfoSM *infoSM = [[FirstLoginPerfectInfoSM alloc] init];
        infoSM.userid = [AppStore getYongHuID];
        infoSM.name = name.text;
        infoSM.position = zhiwei.text;
        infoSM.imgurl = imgurl;
        infoSM.jobnumber = gonghao.text;
        infoSM.email = youxiang.text;
        infoSM.deptid = deptid;
        [LDialog showWaitBox:@"处理信息中"];
        [ZhuceServiceShell FirstLoginPerfectInfoWithPerfectInfo:infoSM usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            [LDialog closeWaitBox];
            if (serviceContext.isSucceeded && model.status == 0) {
                
                [ServiceShell DengLu:[AppStore getYongHuShoujihao] Password:[AppStore getYongHuMima] Companyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *context, DengluSM *itemSM){
                    if (!context.isSucceeded) {
                        return ;
                    }
                    if (itemSM.status == 0) {
                        if ([itemSM.data1.loginStatus isEqualToString:@"LOGIN_SUCCESS"]) {//多公司
                            if (itemSM.data1.lackdeptinfo == 0){//正常进入
                                
                                if(itemSM.data1.lackuserinfo == 0){//正常进入，登录成功
                                    [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:[AppStore getYongHuMima] IsWanshan:YES];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                }
                                
                            }
                        }
                    }else{
                        [ToolBox Tanchujinggao:itemSM.msg IconName:nil];
                    }
                    
                }];
            }else{
                if ([model.msg isEqualToString:@"请求参数不完整"]) {
                    [ToolBox Tanchujinggao:@"请填写完必填项" IconName:nil];
                }else{
                    [ToolBox Tanchujinggao:model.msg IconName:nil];
                }
                
            }
        }];
        
    }else if (sender == bumenBtn){
        
        [self setViewBlur];
        [selectCengJiVC loadCengJiJieGouData];
        blurView.hidden = NO;
    }
}

- (void)creatActionSheet{
    CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"相册",@"拍照"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    customActionSheet.delegate = self;
    [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
    [ShareApp.window addSubview:customActionSheet];
    [customActionSheet show];
    [self showMoHuView];
}

#pragma mark - actionSheetDelegate
- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton customActionView:(CustomActionSheet *)customActionSheet{
    NSLog(@"%ld",(long)indexButton);
    if(indexButton == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else{
            [LDialog showMessage:@"无法访问相册库"];
        }
    }
    else if (indexButton == 2)
    {
        //拍照上传
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else{
            [LDialog showMessage:@"不支持拍照功能"];
        }
    }
    [self hideMoHuView];
}

- (void)CustomActionSheetDelegateDidClickCancelButton:(CustomActionSheet *)customActionSheet{
    [self hideMoHuView];
}

//让UIImagePickerController，根据不同的资源参数，加载不同的后续资源
- (void)loadImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing =YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    picker.allowsEditing = YES;
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *savePhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(savePhoto, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    
    [self saveSelectedImage:image completion:^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

#pragma mark - 上传图片
- (void)saveSelectedImage:(UIImage *)image completion:(void(^)()) callback{
    UIImage *newImage = [image fixOrientation:image];
    [xiangjiBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    xiangjiBtn.layer.masksToBounds = YES;
    xiangjiBtn.layer.cornerRadius = xiangjiBtn.frame.size.width/2;
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.000001);
    NSString *imgStr = Base64_bianMa_DataToString(imageData);
    
    //存图片
    [ServiceShell getUploadWithImgNmae:@"touxinag.png" ImgStr:imgStr usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM) {
        callback();
        if (serviceContext.isSucceeded && ItemSM.result == 0) {
            imgurl = ItemSM.data.url;
            
        }
        
    }];
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
}

- (void)resign{
    [name resignFirstResponder];
    [zhiwei resignFirstResponder];
    [gonghao resignFirstResponder];
    [youxiang resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)tanchuJinggao:(NSString *)jinggao{
    [ToolBox Tanchujinggao:jinggao IconName:nil];
}

@end
