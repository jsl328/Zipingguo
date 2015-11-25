//
//  FabiaoDongtaiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "FabiaoDongtaiViewController.h"
#import "UIKeyboardCoView.h"
#import "UIImage+UIImageCategory.h"
#import "WeizhiViewVC.h"
#import "ZYQAssetPickerController.h"
#import "Base64JiaJieMi.h"
#import "DXRecordView.h"
#import "EMCDDeviceManager.h"
#import "XuanzeRenyuanViewController.h"
#import "XuanzeRenyuanModel.h"
#import "PublishDynamicSM.h"
#import "EMCDDeviceManager+Media.h"
@interface FabiaoDongtaiViewController ()<UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate>
{
    DXRecordView *tmpView;
    NSString *yuyinName;
    NSMutableArray *yuyinUrlArray;
    NSMutableArray *miaoArray;
    NSMutableArray *tupianUrlArray;
    NSString *weizhi;
    NSMutableArray *atusers;
    CLLocationCoordinate2D coordinate2d;
    
    WeizhiView *weizhiView;
    YuyinView *yuyin;
    TupianView *tupianView;
    
    UIButton *_addImageBtn;
    
    NSMutableArray *photos;
    
    NSMutableArray *tupianArray;
    
    NSMutableArray *YuyinArray;
    
    NSMutableArray *dizhiArray;
    
    NSMutableArray *modelArray;
    
    NSString *YaoqingRenName;
    
}
@property (strong, nonatomic) MessageReadManager *messageReadManager;
@end

@implementation FabiaoDongtaiViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    yuyinUrlArray = [@[] mutableCopy];
    miaoArray = [@[] mutableCopy];
    tupianUrlArray = [@[] mutableCopy];
    atusers = [@[] mutableCopy];
    
    photos = [@[] mutableCopy];
    tupianArray = [@[] mutableCopy];
    
    YuyinArray = [@[] mutableCopy];
    dizhiArray = [@[] mutableCopy];
    
    modelArray = [@[] mutableCopy];
    
    [self initUI];
    
    [self resetDibuViewFrameForKeyboard];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)initUI{
    [self.view bringSubviewToFront:dibuView];
    [self.view bringSubviewToFront:yuyinView];
    fabiaoWenzi.delegate = self;
    fabiaoWenzi.maxLength = 10;
    fabiaoWenzi.placeholder = @"说点什么吧... （1000字以内）";
    self.navigationItem.title = @"新动态";
    [self addItemWithTitle:@"发布" imageName:@"" selector:@selector(fabiaodongtaiSelector) location:NO];
    yuyinView.frame = CGRectMake(-ScreenWidth, ScreenHeight-50-64, ScreenWidth, 50);
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    [fabiaoWenzi resignFirstResponder];
}

#pragma @人员数据
- (void)RenyuanShuju:(NSNotification *)not{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    [fabiaoWenzi becomeFirstResponder];
    [atusers removeAllObjects];
    NSDictionary *dict = [not userInfo];
    NSMutableArray *array = [@[] mutableCopy];
    modelArray = [dict objectForKey:@"xuanzhongArray"];
    for (XuanzeRenyuanModel *model in [dict objectForKey:@"xuanzhongArray"]) {
        [array addObject:model.personsSM.name];
        [atusers addObject:model.personsSM.userid];
    }
    
   NSString *wenzi =  [fabiaoWenzi.text substringFromIndex:YaoqingRenName.length];
    
    YaoqingRenName = [NSString stringWithFormat:@"@%@ ",[array componentsJoinedByString:@" @"]];
    fabiaoWenzi.text = [YaoqingRenName stringByAppendingString:wenzi];
}


#pragma 发布
- (void)fabiaodongtaiSelector{
    
    if (fabiaoWenzi.text.length == 0 && weizhi.length == 0 && photos.count == 0 && dizhiArray.count == 0) {
        [SDialog showTipViewWithText:@"请填写发表内容" hideAfterSeconds:1.5f];
        return;
    }
    [LDialog showWaitBox:@"发布动态中"];
    
    
    if (dizhiArray.count != 0 && yuyinUrlArray.count != dizhiArray.count) {
        [yuyinUrlArray removeAllObjects];
        for (NSString *recordPath in dizhiArray) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSFileManager *manager = [NSFileManager defaultManager];
                NSData *data = [manager contentsAtPath:recordPath];
                
                NSString *string = [Base64JiaJieMi base64_bianMa_DataToStringS:data];
                [ServiceShell getUploadWithImgNmae:[[recordPath componentsSeparatedByString:@"/"] lastObject] ImgStr:string usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM){
                    
                    if (serviceContext.isSucceeded  && ItemSM.result == 0) {
                        [yuyinUrlArray addObject:ItemSM.data.url];
                        if (yuyinUrlArray.count == dizhiArray.count) {
                            [self shangchuanTupian];
                        }
                    }else{
                        [LDialog closeWaitBox];
                        [SDialog showTipViewWithText:@"发表失败,请重新发布" hideAfterSeconds:1.5f];
                    }
                }];
                
            });
            
        }
    }else{
        [self shangchuanTupian];
    }
    
}

- (void)shangchuanTupian{

    if (photos.count != 0 && tupianArray.count != photos.count) {
        [tupianUrlArray removeAllObjects];
        for (UIImage *tempImg in photos) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *newImage = [tempImg fixOrientation:tempImg];
                NSData *imageData = UIImageJPEGRepresentation(newImage,0.00001);
                NSString *imgStr = Base64_bianMa_DataToString(imageData);
                [ServiceShell getUploadWithImgNmae:@"tupian.png" ImgStr:imgStr usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM) {
                    //                    callback();
                    
                    if (serviceContext.isSucceeded && ItemSM.result == 0) {
                        
                        [tupianUrlArray addObject:ItemSM.data.url];
                        
                        if (tupianUrlArray.count == photos.count) {
                            [self fabuDongtai];
                        }
                    }else{
                        [LDialog closeWaitBox];
                        [SDialog showTipViewWithText:@"发表失败,请重新发布" hideAfterSeconds:1.5f];
                    }
                    
                }];
                
            });
        }
    }else{
        [self fabuDongtai];
    }
}

- (void)fabuDongtai{
    PublishDynamicSM *publishDynamic = [[PublishDynamicSM alloc] init];
    publishDynamic.content = fabiaoWenzi.text;
    publishDynamic.address = weizhi;
    publishDynamic.positionx = coordinate2d.latitude;
    publishDynamic.positiony = coordinate2d.longitude;
    publishDynamic.createid = [AppStore getYongHuID];
    publishDynamic.imgstrs = tupianUrlArray;
    publishDynamic.spendtimes = miaoArray;
    publishDynamic.sounds = yuyinUrlArray;
    publishDynamic.atusers = atusers;
    publishDynamic.companyid = [AppStore getGongsiID];
    [ServiceShell getPublishDynamicWithCreateid:publishDynamic usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
        [LDialog closeWaitBox];
        if (serviceContext.isSucceeded && model.status == 0) {
            
            _passValueFromFabiao(model.status);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SDialog showTipViewWithText:@"发表失败,请重新发布" hideAfterSeconds:1.5f];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [fabiaoWenzi resignFirstResponder];
}


#pragma mark - 控制btn
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == yuyinBtn) {
        yuyinView.hidden = NO;
        [fabiaoWenzi resignFirstResponder];
        [UIView animateWithDuration:0.35f animations:^{
            yuyinView.frame = CGRectMake(0, ScreenHeight-50-64, ScreenWidth, 50);
        }];
        
        [UIView animateWithDuration:0.35 animations:^{
            yuyinBtn.frame = CGRectMake(0,0,0,0);
            yaoqingBtn.frame = CGRectMake(0,0,0,0);
            tupianBtn.frame = CGRectMake(0,0,0,0);
            
            yuyinBtn.center = weizhiBtn.center;
            yaoqingBtn.center = weizhiBtn.center;
            tupianBtn.center = weizhiBtn.center;
            
        }];
        
        
    }else if (sender == yaoqingBtn){
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
        [fabiaoWenzi resignFirstResponder];
        XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
        xuanze.xuanzhongArray = modelArray;
        xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (sender == tupianBtn){
        
        [fabiaoWenzi resignFirstResponder];
        [self creatActionSheet];
    }else if (sender == weizhiBtn){
        [fabiaoWenzi resignFirstResponder];
        if ([CLLocationManager locationServicesEnabled]) {
            WeizhiViewVC *weizhiVC = [[WeizhiViewVC alloc] init];
            
            weizhiVC.passValueFromWeizhi = ^(NSString *weizhiName,CLLocationCoordinate2D coordinate){
                NSLog(@"%@",weizhiName);
                xinxiScrollView.frame = CGRectMake(0, 200, ScreenWidth, ScreenHeight-200-50-64);
                coordinate2d = coordinate;
                [self weinzhiXinxi:weizhiName];
            };
            
            [self.navigationController pushViewController:weizhiVC animated:YES];
        }else{
            [LDialog showMessage:@"请打开您的定位功能"];
        }
    }else if (sender == guanbiBtn){
        
        float btnWidth = ScreenWidth/4.0;
        float btnHight = 50;
        [UIView animateWithDuration:0.35 animations:^{
            yuyinView.frame = CGRectMake(-ScreenWidth, ScreenHeight-50-64, ScreenWidth, 50);
        }];
        yuyinView.hidden = YES;
        
        [UIView animateWithDuration:0.35 animations:^{
            yuyinBtn.frame = CGRectMake(0, 0, btnWidth, btnHight);
            yaoqingBtn.frame = CGRectMake(yuyinBtn.frame.origin.x+btnWidth, 0, btnWidth, btnHight);
            tupianBtn.frame = CGRectMake(yaoqingBtn.frame.origin.x+btnWidth, 0, btnWidth, btnHight);
            
        }];
        
    }
}

#pragma mark 录音事件

// 录音按钮按下
- (IBAction)recordButtonTouchDown:(UIButton *)sender{
    
    if (![[EMCDDeviceManager sharedInstance] emCheckMicrophoneAvailability]) {
        [[[UIAlertView alloc] initWithTitle:@"麦克风无法使用"
                                     message:@"请打开手机设置->隐私->麦克风,把访问麦克风状态设置为可用,再进入本程序"
                                    delegate:nil
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil] show];
        return;
    }
    
    tmpView = [[DXRecordView alloc] initWithFrame:CGRectMake((ScreenWidth-145)/2.0, 190, 145, 141)];
    //    tmpView.center = self.view.center;
    [self.view addSubview:tmpView];
    [self.view bringSubviewToFront:tmpView];
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"luyin%d%d",(int)time,x];
    [tmpView recordButtonTouchDown];
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                             completion:^(NSError *error)
     {
         if (error) {
             NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
         }
     }];
    
}

// 手指在录音按钮外部时离开
- (IBAction)recordButtonTouchUpOutside:(UIButton *)sender{
    [tmpView recordButtonTouchUpOutside];
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [tmpView removeFromSuperview];
}


// 手指在录音按钮内部时离开
- (IBAction)recordButtonTouchUpInside:(UIButton *)sender{
    [tmpView recordButtonTouchUpInside];
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSLog(@"TD%ld",(long)aDuration);
            [miaoArray addObject:[NSString stringWithFormat:@"%ld",(long)aDuration]];
            [dizhiArray addObject:recordPath];
            
            fabiaoView.frame = CGRectMake(15, 15, ScreenWidth-30, 200);
            xinxiScrollView.frame = CGRectMake(0, 200, ScreenWidth, ScreenHeight-200-50-64);
            
            [self luyunFileLieBiao:dizhiArray];
            
            
            NSLog(@"%@",recordPath);
            
            
        }else {
            [weakSelf showHudInView:self.view hint:NSLocalizedString(@"media.timeShort", @"The recording time is too short")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
            });
        }
    }];
    
    [tmpView removeFromSuperview];
}

// 手指移动到录音按钮外部
- (IBAction)recordDragOutside:(UIButton *)sender{
    [tmpView recordButtonDragOutside];
    
    
}
// 手指移动到录音按钮内部
- (IBAction)recordDragInside:(UIButton *)sender{
    [tmpView recordButtonDragInside];
    
}

#pragma mark - 布局
- (void)luyunFileLieBiao:(NSMutableArray *)yuyinArray{
    [YuyinArray removeAllObjects];
    
    for (UIView *subView in xinxiScrollView.subviews) {
        if ([subView isKindOfClass:[YuyinView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (weizhi.length == 0) {
        for (int i = 0; i < yuyinArray.count; i++) {
            yuyin = [[YuyinView alloc] init];
            
            yuyin.frame = CGRectMake(10,photos.count == 0 ?xinxiScrollView.frame.size.height-15-(i+1)*(26+10):xinxiScrollView.height-15-((ScreenWidth-30-10)/3.0)-15-(i+1)*(26+10), 77, 26);
            
            yuyin.miaoshuLabel.text = [NSString stringWithFormat:@"%@''",[miaoArray objectAtIndex:i]];
            yuyin.delegate = self;
            [xinxiScrollView addSubview:yuyin];
            [YuyinArray addObject:yuyin];
        }
        
    }else{
        for (int i = 0; i < yuyinArray.count; i++) {
            yuyin = [[YuyinView alloc] init];
            
            yuyin.frame = CGRectMake(10,weizhiView.frame.origin.y-10-(i+1)*(26+10), 77, 26);
            
            yuyin.miaoshuLabel.text = [NSString stringWithFormat:@"%@''",[miaoArray objectAtIndex:i]];
            yuyin.delegate = self;
            [xinxiScrollView addSubview:yuyin];
            [YuyinArray addObject:yuyin];
        }
        
    }
    if (yuyinArray.count == 3) {
        anzhuBtn.enabled = NO;
    }else{
        anzhuBtn.enabled = YES;
    }
}

- (void)weinzhiXinxi:(NSString *)weizhixinxi{
    if (weizhi.length == 0) {
        for (UIView *subView in xinxiScrollView.subviews) {
            if ([subView isKindOfClass:[YuyinView class]]) {
                subView.frame = CGRectMake(subView.x, subView.y-10-26, subView.width, subView.height);
            }
        }
    }
    
    for (UIView *subView in xinxiScrollView.subviews) {
        if ([subView isKindOfClass:[WeizhiView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    weizhi = weizhixinxi;
    weizhiView = [[WeizhiView alloc] init];
    weizhiView.delegate = self;
    //
    weizhiView.frame = CGRectMake(10, photos.count == 0 ? xinxiScrollView.frame.size.height-15-23 : xinxiScrollView.height-15-((ScreenWidth-30-10)/3.0)-15-23, 290, 23);
    weizhiView.weizhi.text = weizhixinxi;
    [xinxiScrollView addSubview:weizhiView];
    
}

- (void)tianjiaTupian:(NSMutableArray *)photoS{
    if (photoS.count == 9) {
        tupianBtn.enabled = NO;
    }else{
        tupianBtn.enabled = YES;
    }
    [tupianArray removeAllObjects];
    xinxiScrollView.frame = CGRectMake(0, 200, ScreenWidth, ScreenHeight-200-50-64);
    
    
    for (UIView *subView in xinxiScrollView.subviews) {
        if ([subView isKindOfClass:[TupianView class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    float imageWidth = (ScreenWidth-30-10)/3.0;
    float imageHeight = (ScreenWidth-30-10)/3.0;
    float panding = 5.0;
    if (photoS.count > 0) {
        
        for (int i = 0; i < photoS.count + 1; i++) {
            tupianView = [[TupianView alloc] init];
            tupianView.frame = CGRectMake(15+(i%3)*(imageWidth+panding), weizhi.length > 0 ? CGRectGetMaxY(weizhiView.frame)+15+(imageHeight+panding)*(i/3) : xinxiScrollView.height-15+(imageHeight+panding)*(i/3)-imageHeight, imageWidth, imageHeight);
            tupianView.userInteractionEnabled = YES;
            tupianView.delegate = self;
            if (i < photos.count) {
                tupianView.tupianImageBox.image = [photoS objectAtIndex:i];
                [xinxiScrollView addSubview:tupianView];
            }
            
            if (i == photos.count && i < 9) {
                _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addImageBtn.frame = CGRectMake(15+(i%3)*(imageWidth+panding), weizhi.length > 0 ? CGRectGetMaxY(weizhiView.frame)+15+(imageHeight+panding)*(i/3) : xinxiScrollView.height-15+(imageHeight+panding)*(i/3)-imageHeight, imageWidth, imageHeight);
                [_addImageBtn setImage:[UIImage imageNamed:@"虚线框.png"] forState:UIControlStateNormal];
                _addImageBtn.adjustsImageWhenHighlighted = NO;
                [_addImageBtn addTarget:self action:@selector(tupianSelector) forControlEvents:UIControlEventTouchUpInside];
                [xinxiScrollView addSubview:_addImageBtn];
            }
            [tupianArray addObject:tupianView];
            
            
        }
    }
    if (photos.count == 9) {
        xinxiScrollView.contentSize = CGSizeMake(ScreenWidth, 550);
    }else{
        xinxiScrollView.contentSize = CGSizeMake(ScreenWidth,_addImageBtn.y+_addImageBtn.height);
    }
    
    
}

- (void)tupianSelector{
    [self creatActionSheet];
}

- (void)creatActionSheet{
    CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"相册",@"拍照"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    customActionSheet.delegate = self;
    [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
    [ShareApp.window addSubview:customActionSheet];
    [customActionSheet show];
    [self showMoHuView];
}

#pragma mark viewDidLayoutSubviews

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    int btnWidth = ScreenWidth/4.0;
    float btnHight = 50;
    fabiaoView.frame = CGRectMake(15, 10, ScreenWidth-30, ScreenHeight-15-50);
    dibuView.frame = CGRectMake(0, ScreenHeight-50-NavHeight, ScreenWidth, 50);
    
    yuyinBtn.frame = CGRectMake(0, 0, btnWidth, btnHight);
    yaoqingBtn.frame = CGRectMake(yuyinBtn.x+btnWidth, 0, ScreenWidth/2 - btnWidth, btnHight);
    tupianBtn.frame = CGRectMake(ScreenWidth/2, 0, btnWidth, btnHight);
    weizhiBtn.frame = CGRectMake(tupianBtn.x+btnWidth, 0,ScreenWidth/2 -  btnWidth, btnHight);
    
    anzhuBtn.frame = CGRectMake(5, 5, yuyinView.width-75, 40);
    guanbiBtn.frame = CGRectMake(yuyinView.width-65, 0, 60, 50);
}

#pragma mark - 控制dibuview

- (void)resetDibuViewFrameForKeyboard
{
    /*
     不隐藏时 使用
     可以不遵守delegate
     */
    UIKeyboardCoView *view = [[UIKeyboardCoView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
    view.beginRect = ^(CGRect beginRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            
            yuyinView.frame = CGRectMake(0, beginRect.origin.y-50, yuyinView.frame.size.width, 50);
            dibuView.frame = CGRectMake(0, beginRect.origin.y-50, dibuView.frame.size.width, 50);
        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            yuyinView.frame = CGRectMake(0, endRect.origin.y-50, yuyinView.frame.size.width, 50);
            dibuView.frame = CGRectMake(0, endRect.origin.y-50, dibuView.frame.size.width, 50);
        }];
    };
    [self.view addSubview:view];
}

#pragma mark - Rotation control
//为了保证不出错
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewWillRotateNotification object:nil];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewDidRotateNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


#pragma mark - actionSheetDelegate
- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton customActionView:(CustomActionSheet *)customActionSheet{
    if(indexButton == 1)
    {
        //选择多张图片
        [self photos];
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

//多张图片
- (void)photos{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9-photos.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [photos addObject:tempImg];
        
        [self tianjiaTupian:photos];
    }
    if (photos.count != 0) {
        
        if (weizhi.length == 0) {
            for (UIView *subView in xinxiScrollView.subviews) {
                if ([subView isKindOfClass:[YuyinView class]]) {
                    [self luyunFileLieBiao:dizhiArray];
                }
            }
        }else{
            for (UIView *subView in xinxiScrollView.subviews) {
                if ([subView isKindOfClass:[WeizhiView class]]) {
                    [self weinzhiXinxi:weizhi];
                }
            }
            for (UIView *subView in xinxiScrollView.subviews) {
                if ([subView isKindOfClass:[YuyinView class]]) {
                    [self luyunFileLieBiao:dizhiArray];
                }
            }
        }
    }
    
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
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //保存到相册
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
    [photos addObject:newImage];
    [self tianjiaTupian:photos];
    
    if (photos.count != 0) {
        
        if (weizhi.length == 0) {
            for (UIView *subView in xinxiScrollView.subviews) {
                if ([subView isKindOfClass:[YuyinView class]]) {
                    [self luyunFileLieBiao:dizhiArray];
                }
            }
        }else{
            for (UIView *subView in xinxiScrollView.subviews) {
                if ([subView isKindOfClass:[WeizhiView class]]) {
                    [self weinzhiXinxi:weizhi];
                }
            }
            for (UIView *subView in xinxiScrollView.subviews) {
                if ([subView isKindOfClass:[YuyinView class]]) {
                    [self luyunFileLieBiao:dizhiArray];
                }
            }
        }
    }
    callback();
    
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
}


#pragma mark - 语音、图片、位置代理
- (void)ShanchuTupian:(TupianView *)tupianView1{
    for(int i = 0;i < [tupianArray count];i++)
    {
        TupianView *imageBox = [tupianArray objectAtIndex:i];
        if([imageBox isEqual:tupianView1])
        {
            [tupianArray removeObjectAtIndex:i];
            [photos removeObjectAtIndex:i];
            [self tianjiaTupian:photos];
        }
    }
    if (weizhi.length == 0) {
        [self luyunFileLieBiao:dizhiArray];
    }else{
        [self weinzhiXinxi:weizhi];
        [self luyunFileLieBiao:dizhiArray];
    }
    
}

- (void)TupianViewDidTap:(TupianView *)tapView{
    
    for(int i = 0;i < [tupianArray count];i++)
    {
        
        UIImageView *imageBox = [tupianArray objectAtIndex:i];
        if([imageBox isEqual:tapView])
        {
            [self.messageReadManager showBrowserWithImages:photos];
            [self.messageReadManager showImageWithIndex:i];
        }
    }
}

- (void)shanchuWeizhi:(WeizhiView *)address{
    [address removeFromSuperview];
    weizhi = @"";
    [self luyunFileLieBiao:dizhiArray];
}

- (void)ShanchuYuyin:(YuyinView *)luyinView{
    for(int i = 0;i < [YuyinArray count];i++)
    {
        YuyinView *Yuyin = [YuyinArray objectAtIndex:i];
        if([Yuyin isEqual:luyinView])
        {
            [YuyinArray removeObjectAtIndex:i];
            [miaoArray removeObjectAtIndex:i];
            [dizhiArray removeObjectAtIndex:i];
            [self luyunFileLieBiao:dizhiArray];
        }
    }
}

- (void)BofangYuyin:(YuyinView *)luyinView{
    for(int i = 0;i < [YuyinArray count];i++)
    {
        YuyinView *Yuyin = [YuyinArray objectAtIndex:i];
        if([Yuyin isEqual:luyinView])
        {
            NSLog(@"%@",[dizhiArray objectAtIndex:i]);
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:[dizhiArray objectAtIndex:i] completion:^(NSError *error) {
                
            }];
            
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}


@end
