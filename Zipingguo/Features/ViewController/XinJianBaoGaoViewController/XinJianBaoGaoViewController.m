//
//  XinJianBaoGaoViewController.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "XinJianBaoGaoViewController.h"
#import "UIPlaceHolderTextView.h"
#import "XiugaiXinxiViewController.h"
#import "UIKeyboardCoView.h"
#import "XuanzeRenyuanViewController.h"
#import "LFDatePickerView.h"
#import "CustomActionSheet.h"
#import "AppStore.h"
#import "BaoGaoServiceShell.h"
#import "IQKeyboardManager.h"
#import "XuanzeRenyuanModel.h"
#import "ToolBox.h"
#import "ZYQAssetPickerController.h"
#import "Base64JiaJieMi.h"
#import "WenJianTableViewCell.h"
#import "ServiceShell.h"
#import "UploadHelper.h"
@interface XinJianBaoGaoViewController ()<CustomActionSheetDelegate,ZYQAssetPickerControllerDelegate,WenJianTableViewCellDelegate>
{

    ALAssetsLibrary *_aLAssetsLibrary;
    UITableView *_tableView;
    NSArray *_titleArray;
    NSMutableArray *_deltailArray;
    ///日报名字
    NSString *_title;
    ///日报时间
    NSString *_riqi;
    ///批阅人
    NSString *_piyueren;
    ///抄送人
    NSString *_chaosongren;
    ///附件
    NSString *_fujian;
    
    ///批阅人数组
    NSMutableArray *_piyuerenArray;
    ///抄送人数组
    NSMutableArray *_chaosongrenArray;
    ///附件数组
    NSMutableArray *_fujianArray;
    
    ///当前编辑的textview所在的section
    NSInteger _currentTextviewSection;
    ///时间选择view
    LFDatePickerView *_shijianView;
    CustomActionSheet * _customActionSheet;
    CustomActionSheet * _fujianActionSheet;

    ///新建报告上传参数
    XinjianShangchuanRibaoSM *_xinjianShangchuanRibaoSM;
    
    ///选择的是批阅人or抄送人
    BOOL _isPiyueRen;
    ///是否编辑过？编辑过返回提示是否保存
    BOOL _isEdit;

}
@end

@implementation XinJianBaoGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    _titleArray = @[@"标题",@"日期",@"批阅人",@"抄送人",@"上传附件"];
    if (_leixing == 1) {//日报
        _title = [NSString stringWithFormat:@"%@的日报",[AppStore getYongHuMing]];
    }else if (_leixing == 2){//周报
        _title = [NSString stringWithFormat:@"%@的周报",[AppStore getYongHuMing]];
    }else{
        _title = [NSString stringWithFormat:@"%@的月报",[AppStore getYongHuMing]];
    }
    _riqi = [ToolBox shijianStringWith:[NSDate date] isTime:NO];
//    _piyuerenArray = [@[] mutableCopy];
    _piyuerenArray = [[NSMutableArray alloc]init];

    _chaosongrenArray = [@[] mutableCopy];
    _fujianArray = [@[] mutableCopy];
    _isEdit = NO;
    _piyueren = @"";
    _chaosongren = @"";
    _fujian = @"";
    _deltailArray  = [@[_title,_riqi,_piyueren,_chaosongren,_fujian] mutableCopy];

    _aLAssetsLibrary = [[ALAssetsLibrary alloc]init];
    _xinjianShangchuanRibaoSM = [[XinjianShangchuanRibaoSM alloc]init];
    _xinjianShangchuanRibaoSM.createid = [AppStore getYongHuID];
        _xinjianShangchuanRibaoSM.createtime = [ToolBox shijianStringWith:[NSDate date] isTime:YES];
    _xinjianShangchuanRibaoSM.papername = _title;
    _xinjianShangchuanRibaoSM.papertype = _leixing;
    _xinjianShangchuanRibaoSM.approveruserids = @[];
    _xinjianShangchuanRibaoSM.ccuserids = @[];
    _xinjianShangchuanRibaoSM.companyid = [AppStore getGongsiID];
    _xinjianShangchuanRibaoSM.deptid = [AppStore getDeptid];
    
    //批阅人解档
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentPath stringByAppendingString:[@"/piyueren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
    _piyuerenArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self chuliDataArray:_piyuerenArray isPiyueren:YES isArchive:NO];
    
    //抄送人解档
    NSString *path1 = [documentPath stringByAppendingString:[@"/chaosongren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
    _chaosongrenArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
    [self chuliDataArray:_chaosongrenArray isPiyueren:NO isArchive:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuanwanle:) name:@"xuanzhongArray" object:nil];

    [self addKeyboardCoView];//键盘
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)uiConfig{

    self.title = @"新建工作报告";
    [self addItemWithTitle:@"发送" imageName:@"" selector:@selector(fasong) location:NO];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight - NavHeight) style:UITableViewStyleGrouped];
    //    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    _shijianView  = [[LFDatePickerView alloc]init];
    _shijianView.frame = CGRectMake(0, self.view.height , ScreenWidth, 200);
    [self.view addSubview:_shijianView];

    //为了省个代理容易么（$_$）
    __weak typeof(self)  weakSelf = self;
    __weak UITableView * tableview = _tableView;
    __weak XinjianShangchuanRibaoSM *shangchaunSM = _xinjianShangchuanRibaoSM;
    [_shijianView setType:UIDatePickerModeDate confirmCallBack:^(NSDate *shijian) {
        shangchaunSM.createtime = [ToolBox shijianStringWith:shijian isTime:YES];

        UITableViewCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailTextLabel.text = [ToolBox shijianStringWith:shijian isTime:NO];
        [weakSelf hiddenShijianView];
    } cancelCallBack:^{
        [weakSelf hiddenShijianView];
        
    }];
}

#pragma mark - 重写父类返回
-(void)backSel{
    [self shoujianpan];
    if (_isEdit) {
        _customActionSheet = [[CustomActionSheet alloc] initWithTitle:@"" OtherButtons:@[@"保存为草稿",@"不保存"] CancleButton:@"取消" Rect:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight )];
        _customActionSheet.delegate = self;
        [self setMoHuViewWithHeight:_customActionSheet.actionSheetHeight];
        [ShareApp.window addSubview:_customActionSheet];
        [_customActionSheet show];
        [self showMoHuView];

    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//重写滑动返回方法
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    [self shoujianpan];
    if (_isEdit) {
        _customActionSheet = [[CustomActionSheet alloc] initWithTitle:@"" OtherButtons:@[@"保存为草稿",@"不保存"] CancleButton:@"取消" Rect:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight )];
        _customActionSheet.delegate = self;
        [self setMoHuViewWithHeight:_customActionSheet.actionSheetHeight];
        [ShareApp.window addSubview:_customActionSheet];
        [_customActionSheet show];
        [self showMoHuView];
        return NO;
    }
    return YES;
}


#pragma mark - actionSheetDelegate
- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton customActionView:(CustomActionSheet *)customActionSheet{
    [self hideMoHuView];
    if (customActionSheet == _customActionSheet) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        switch (indexButton) {
            case 1:
            {
                //选择多张图片
                [self photos];
            }
                break;
            case 2:
            {
                //拍照上传
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                }else{
                    [LDialog showMessage:@"不支持拍照功能"];
                }

            }
                break;
            default:
                break;
        }
    }
}

- (void)CustomActionSheetDelegateDidClickCancelButton:(CustomActionSheet *)customActionSheet{
    [self hideMoHuView];

}

//多张图片
- (void)photos{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
//    picker.maximumNumberOfSelection = 9-photos.count;
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

//让UIImagePickerController，根据不同的资源参数，加载不同的后续资源
- (void)loadImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //保存到相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *savePhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(savePhoto, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
        NSData * imgData = UIImageJPEGRepresentation(savePhoto,0.00001);

        NSString * base64Str = Base64_bianMa_DataToString(imgData);

        WenJianTableViewCellModel *wenjianModel = [[WenJianTableViewCellModel alloc]init];
        //这里是个坑
        wenjianModel.title = @"Camera_Picture.JPG";
        wenjianModel.image = savePhoto;
        wenjianModel.len = [NSString stringWithFormat:@"%ld",(unsigned long)imgData.length];
        wenjianModel.imagebase64 = base64Str;
        [_fujianArray addObject:wenjianModel];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];

    }

    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(WenJianTableViewCellModel *)getWenJianTableViewCellModelWith:(ALAsset *)asset{
    ALAssetRepresentation * repre = [asset defaultRepresentation];
    CGImageRef  ref = asset.thumbnail;
    UIImage * img = [UIImage imageWithCGImage:ref];
    NSData * imgData = UIImageJPEGRepresentation(img,0.00001);
    NSString * base64Str = Base64_bianMa_DataToString(imgData);
    NSString * imgName = [NSString stringWithFormat:@"%@",[repre filename]];
    NSNumber * number = [NSNumber numberWithLongLong:repre.size];
    NSString * numStr = [number stringValue];
    NSLog(@"文件大小:%@ 图片长度:%lu",numStr,(unsigned long)imgData.length);
    
    WenJianTableViewCellModel *wenjianModel = [[WenJianTableViewCellModel alloc]init];
    wenjianModel.title = imgName;
    wenjianModel.image = img;
//    wenjianModel.len = numStr;//这个得到的是未压缩的
    wenjianModel.len = [NSString stringWithFormat:@"%ld",(unsigned long)imgData.length];

    wenjianModel.imagebase64 = base64Str;
    return wenjianModel;
}

- (void)image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo{
    if(error != NULL){
        NSLog(@"保存图片失败");
    }else{
        NSLog(@"保存图片成功");
    }
}



#pragma mark - ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            [_fujianArray addObject:[self getWenJianTableViewCellModelWith:asset]];

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];

            [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        });
    });
}

#pragma mark - 发送
-(void)fasong{
    
    if (![self xinXiisComplete]) {
        return;
    }
    [LDialog showWaitBox:@"发送中..."];
    if(_fujianArray.count > 0){//有附件
        [self shangchuanfujians:_fujianArray success:^(NSArray *array) {
            _xinjianShangchuanRibaoSM.annexlist = array;
            [self fasongService];//发送接口
        } failure:^{
            [LDialog closeWaitBox];
            [LDialog showMessage:@"上传失败"];
        }];
    }else{//没有附件，直接发送
        [self fasongService];
    }
}

//发送接口
-(void)fasongService{
    
    [BaoGaoServiceShell createGongzuoBaogaoWithCreateGongzuoBaogao:_xinjianShangchuanRibaoSM usingCallback:^(DCServiceContext *sc, XInjianribaoSM *sm) {
        [LDialog closeWaitBox];
        if (sc.isSucceeded && sm.status == 0) {//发表成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxinbaogao" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [LDialog showMessage:@"发送失败"];
        }
    }];
    
}
//上传单张图片
- (void)shangchuanfujian:(WenJianTableViewCellModel *)model success:(void (^)(NSString *url))success failure:(void (^)())failure{
    
    
    [ServiceShell getUploadWithImgNmae:@"fujian.jpg" ImgStr:model.imagebase64 usingCallback:^(DCServiceContext *sc, ResultModelShangchuanWenjianSM *sm) {
        if (sc.isSucceeded && sm.result == 0) {//上传成功
//            model.url = sm.data.url;
            if (success) {
                success(sm.data.url);
            }
        }else {
            if (failure) {
                failure();
            }
        }

    }];
    
}

- (void)shangchuanfujians:(NSArray *)modelArray success:(void (^)(NSArray *))success failure:(void (^)())failure{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    __block NSUInteger currentIndex = 0;
    UploadHelper *uploadHelper = [UploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;

    uploadHelper.singleFailureBlock = ^(){
        failure();
        return ;
    };
    
    uploadHelper.singleSuccessBlock = ^(NSString *url){

        WenJianTableViewCellModel *viewModel = _fujianArray[currentIndex];
        FujianDataModel *fujianDataModel = [[FujianDataModel alloc]init];
        fujianDataModel.filename = viewModel.title;
        fujianDataModel.fileurl = url;
        fujianDataModel.filesize = viewModel.len;
        
        [array addObject:fujianDataModel];
        currentIndex ++ ;
        
        if ([array count] == [modelArray count]) {
            success([array copy]);
            return;
        }else{
            
            [self shangchuanfujian:modelArray[currentIndex] success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };
    
    [self shangchuanfujian:modelArray[0] success:uploadHelper.singleSuccessBlock failure:uploadHelper.singleFailureBlock];

}

/**
 *  判断信息是否完整（发送前）
 *
 *  @return yes-完整 no- 信息不全，提示，不能发送
 */
-(BOOL)xinXiisComplete{
    
    if (_title.length == 0) {
        [LDialog showMessage:@"请填写标题"];
        return NO;
    }
    if (_xinjianShangchuanRibaoSM.approveruserids.count == 0 ) {
        [LDialog showMessage:@"请选择批阅人"];
        return NO;
    }
    
    UIPlaceHolderTextView *textview_jinri = (UIPlaceHolderTextView *)[self.view viewWithTag:101];
    UIPlaceHolderTextView *textview_plan = (UIPlaceHolderTextView *)[self.view viewWithTag:102];
    if(textview_jinri.text.length == 0){
        [LDialog showMessage:@"总结内容不能为空"];
        return NO;
    }
    if(textview_plan.text.length == 0){
        [LDialog showMessage:@"计划内容不能为空"];
        return NO;
    }
    _xinjianShangchuanRibaoSM.summary = textview_jinri.text;
    _xinjianShangchuanRibaoSM.plan = textview_plan.text;
    return YES;
}

#pragma mark - tableview delegate&
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if(indexPath.row == 4){//上传附件
            static NSString *cellIndentifier = @"shangchaunFujianCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                UIImageView *addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"添加icon"]];
                addImageView.frame = CGRectMake(ScreenWidth - 30 , 15, 15, 15);
                [cell.contentView addSubview:addImageView];

            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = RGBACOLOR(160, 160, 162, 1);
            cell.textLabel.text = _titleArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        
        if (indexPath.row > 4) {//附件
            WenJianTableViewCell *wenjiancell = [WenJianTableViewCell cellForTableView:tableView];
            wenjiancell.model = _fujianArray[indexPath.row - 5];
            wenjiancell.delegate = self;
            return wenjiancell;
        }
        
        static NSString *cellIndentifier = @"xinjianCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = _deltailArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGBACOLOR(160, 160, 162, 1);
        cell.detailTextLabel.textColor = RGBACOLOR(53, 55, 68, 1);

        return cell;
    }
    
    static NSString *cellIndentifier = @"bianjiCell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        
        UIPlaceHolderTextView *textview = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 180 )];
        textview.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        if(_leixing == 1){//日报
            textview.placeholder = indexPath.section == 1 ? @"在此编辑今日总结" : @"在此编辑明日计划";
        }else if(_leixing == 2){//周报
            textview.placeholder = indexPath.section == 1 ? @"在此编辑本周总结" : @"在此编辑下周计划";
        }else{//月报
            textview.placeholder = indexPath.section == 1 ? @"在此编辑本月总结" : @"在此编辑下月计划";
        }
        
        textview.placeholderColor = RGBACOLOR(194, 194, 194, 1);
        textview.font = [UIFont systemFontOfSize:13];
        textview.tag = indexPath.section == 1 ? 101:102;
        textview.delegate = self;
        [cell.contentView addSubview:textview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 5 + _fujianArray.count;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 44;
    }
    return 180;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = Bg_Color;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,100, 30 )];
    label.textColor = RGBACOLOR(140, 140, 140, 1);
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    
    if (section == 1) {
        switch (_leixing) {
            case 1:
                label.text = @"今日总结";
                break;
            case 2:
                label.text = @"本周总结";
                break;
            case 3:
                label.text = @"本月总结";
                break;
            default:
                break;
        }
            
    } else if (section == 2) {
        switch (_leixing) {
            case 1:
                label.text = @"明日计划";
                break;
            case 2:
                label.text = @"下周计划";
                break;
            case 3:
                label.text = @"下月计划";
                break;
            default:
                break;
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shoujianpan)];
   [headerView addGestureRecognizer:tap];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0.01;
    }
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    footerView.backgroundColor = Bg_Color;
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://标题
            {
                XiugaiXinxiViewController *xiugai = [[XiugaiXinxiViewController alloc] init];
                xiugai.titleText = cell.textLabel.text;
                xiugai.chuanzhiStr = cell.detailTextLabel.text;

                [xiugai returnText:^(NSString *value) {
                    cell.detailTextLabel.text = value;
                    _xinjianShangchuanRibaoSM.papername = value;
                }];
                [self.navigationController pushViewController:xiugai animated:YES];
            }
                break;
              
            case 1://日期
            {
                [self showShijianView];//显示日期选择View
            }
                break;
            case 2://批阅人
            {
                _isPiyueRen = YES;
                XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
                xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
                xuanze.xuanzhongArray = _piyuerenArray;
                [self presentViewController:nav animated:YES completion:nil];

            }
                break;
            case 3://抄送人
            {
                _isPiyueRen  = NO;
                XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
                xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
                xuanze.xuanzhongArray = _chaosongrenArray;
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 4:{//上传附件
                [self xuanzeFujian];
            
            }
                break;
            default:
                break;
        }
        
    }

}

#pragma mark - wenJianTableViewCell delegate 删除附件
-(void)wenJianTableViewCellDelete:(WenJianTableViewCellModel *)model{

    [LDialog showMessageCancelOK:[NSString stringWithFormat:@"确定要删除附件%@吗?",model.title] ok:^{
        [_fujianArray removeObject:model];
        [_tableView reloadData];
    } cancel:nil];
    
}

#pragma mark -  选择附件
-(void)xuanzeFujian{

    _fujianActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"相册",@"拍照"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    _fujianActionSheet.delegate = self;
    [self setMoHuViewWithHeight:_fujianActionSheet.actionSheetHeight];
    [ShareApp.window addSubview:_fujianActionSheet];
    [_fujianActionSheet show];
    [self showMoHuView];
}

#pragma mark - 控制dibuview
- (void)addKeyboardCoView
{
    /*
     不隐藏时 使用
     可以不遵守delegate
     */
    UIKeyboardCoView *view = [[UIKeyboardCoView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
    view.beginRect = ^(CGRect beginRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            _tableView.frame  = CGRectMake(0,  0, _tableView.width, beginRect.origin.y);
  
        }];
        
        [UIView animateWithDuration:duration animations:^{
            
        } completion:^(BOOL finished) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currentTextviewSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            _tableView.frame  = CGRectMake(0, 0, _tableView.width, self.view.height);

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

#pragma mark - textview delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _isEdit = YES;
    _currentTextviewSection = textView.tag - 100;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _currentTextviewSection = 0;
    return YES;
}

#pragma mark - 收键盘
-(void)shoujianpan{
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 选择时间View
//显示时间选择View
-(void)showShijianView{
    _shijianView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _shijianView.frame = CGRectMake(0, self.view.height - 200, ScreenWidth, 200);
    }];
}

//隐藏时间选择view
-(void)hiddenShijianView{
    [UIView animateWithDuration:0.5 animations:^{
        _shijianView.frame = CGRectMake(0, self.view.height, ScreenWidth, 200);

    } completion:^(BOOL finished) {
        _shijianView.hidden = YES;
    }];
}

#pragma mark - 选人选完了通知

-(void)xuanwanle:(NSNotification *)notice{
    
    NSDictionary *dict = notice.userInfo;
    NSArray *resultArray = [dict objectForKey:@"xuanzhongArray"];
    
    [self chuliDataArray:resultArray isPiyueren:_isPiyueRen isArchive:YES];
}
/**
 *  数据处理
 *
 *  @param resultArray 数组
 *  @param isPiyueren  是否是批阅人 no -- 抄送人
 *  @param isArchive   是否需要归档，通知回来的要归档；解档完处理不用再归档
 */
- (void)chuliDataArray:(NSArray *)resultArray isPiyueren:(BOOL)isPiyueren isArchive:(BOOL)isArchive{
    
    //取出名字放到数组里链接成字符串
    NSMutableArray *tempNameArray = [@[] mutableCopy];
    NSMutableArray *tempIDArray = [@[] mutableCopy];
    
    for (XuanzeRenyuanModel *model in resultArray) {
        [tempNameArray addObject:model.personsSM.name];
        [tempIDArray addObject:model.personsSM.userid];
    }
    NSString *tempNameStr = [tempNameArray componentsJoinedByString:@" "];
    
    if(isPiyueren){//批阅人
        if(isArchive){
            //归档批阅人--- 拼接GongsiID
            //直接放在沙盒根目录在真机上不好使，改成放在document下
//            NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:[@"piyueren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
            
            //document
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path=[documentPath stringByAppendingString:[@"/piyueren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];

            
            BOOL success=[NSKeyedArchiver archiveRootObject:resultArray toFile:path];
            if (success) {
                NSLog(@"批阅人归档成功");
            }
        }
        _piyuerenArray = [resultArray mutableCopy];//批阅人数组
        _xinjianShangchuanRibaoSM.approveruserids = tempIDArray;//需要上传的批阅人id数组
        [_deltailArray replaceObjectAtIndex:2 withObject:tempNameStr];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

    }else{//抄送人
        if(isArchive){
            //归档抄送人
//            NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:[@"/chaosongren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
            
            //document
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path=[documentPath stringByAppendingString:[@"/chaosongren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
            
            BOOL success=[NSKeyedArchiver archiveRootObject:resultArray toFile:path];
            if (success) {
                NSLog(@"抄送人归档成功");
            }
        }
        _chaosongrenArray = [resultArray mutableCopy];//抄送人数组
        _xinjianShangchuanRibaoSM.ccuserids = tempIDArray;//需要上传的抄送人id数组
        [_deltailArray replaceObjectAtIndex:3 withObject:tempNameStr];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }

}


@end
