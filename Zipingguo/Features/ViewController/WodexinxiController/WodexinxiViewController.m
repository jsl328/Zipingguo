//
//  WodexinxiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WodexinxiViewController.h"
#import "WodexinxiHeaderView.h"
#import "WodexinxiViewCell.h"
#import "XiugaiXinxiViewController.h"
#import "XingzuoVM.h"
#import "CustomActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "UIImage+UIImageCategory.h"
#import "ZYQAssetPickerController.h"
#import "Base64JiaJieMi.h"
#import "XuanZeCengJiViewController.h"
@interface WodexinxiViewController ()<WodexinxiHeaderViewDelegate,CustomActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *contentArray;
    NSMutableArray *valueArray;
    WodexinxiHeaderView *wodexinHeader;
    CGPoint currentPoint;
    
    FXBlurView *blurView;
    
    XuanZeCengJiViewController *selectCengJiVC;
    
    NSString *hobby;
    
}
@end

@implementation WodexinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的信息";
    _tableView.backgroundColor = Bg_Color;
    _tableView.separatorColor = Fenge_Color;

    // Do any additional setup after loading the view from its nib.
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view bringSubviewToFront:beijingImageView];
    [self.view bringSubviewToFront:shengriView];
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1;
    [beijingImageView addGestureRecognizer:singleRecognizer];
    
    [self initUI];
    
    [self initData];
}

- (void)initUI{
    wodexinHeader = [[WodexinxiHeaderView alloc] init];
    wodexinHeader.frame = CGRectMake(0, 0, ScreenWidth, 74);
    wodexinHeader.delegate = self;
    
    _tableView.tableHeaderView = wodexinHeader;
    
}

- (void)initData
{
    dataArray = [@[] mutableCopy];
    contentArray = [@[] mutableCopy];
    valueArray = [@[] mutableCopy];
    
    NSArray *titileArray1 = [[NSArray alloc]initWithObjects:@"姓名",@"部门",@"职位",@"工号", nil];
    NSArray *titileArray2 = [[NSArray alloc]initWithObjects:@"联系电话",@"电子邮件", nil];
    NSArray *titileArray3 = [[NSArray alloc]initWithObjects:@"微信号",@"QQ号",@"生日",@"星座",@"爱好", nil];
    dataArray = [@[titileArray1,titileArray2,titileArray3]mutableCopy];
    
    NSArray *valueArr1 = [[NSArray alloc]initWithObjects:@"name",@"deptid",@"position",@"jobnumber", nil];
    NSArray *valueArr2 = [[NSArray alloc]initWithObjects:@"",@"email", nil];
    NSArray *valueArr3 = [[NSArray alloc]initWithObjects:@"wechat",@"qq",@"birthday",@"",@"hobby", nil];
    valueArray = [@[valueArr1,valueArr2,valueArr3]mutableCopy];
    
    [ServiceShell getUserDetailWithYonghuID:[AppStore getYongHuID] Sessionid:[AppStore getSessionid] usingCallback:^(DCServiceContext *serviceContext, DengluSM *itemSM) {
        if (itemSM.status == 0) {
            
            NSString *shengri;
            NSString *xingzuo;
            if(![[self puanduanISNull:itemSM.data.userinfos.birthday] isEqualToString:@""]){
                shengri = [itemSM.data.userinfos.birthday substringToIndex:10];
                NSString *month = [itemSM.data.userinfos.birthday substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [itemSM.data.userinfos.birthday substringWithRange:NSMakeRange(8, 2)];
                xingzuo = [XingzuoVM chuanzhiNum:[NSString stringWithFormat:@"%@%@",month,day]];
            }else{
                shengri = @"";
                xingzuo = @"";
            }
            
            NSArray *contentArr1 = [[NSArray alloc]initWithObjects:[self puanduanISNull:itemSM.data.name],[self puanduanISNull:itemSM.data.deptname],[self puanduanISNull:itemSM.data.position],[self puanduanISNull:itemSM.data.jobnumber],nil];
            NSArray *contentArr2 = [[NSArray alloc]initWithObjects:[self puanduanISNull:itemSM.data.phone],[self puanduanISNull:itemSM.data.email],nil];
            NSArray *contentArr3 = [[NSArray alloc]initWithObjects:[self puanduanISNull:itemSM.data.wechat],[self puanduanISNull:itemSM.data.qq],shengri,xingzuo,[self puanduanISNull:itemSM.data.userinfos.hobby],nil];
            
            hobby = [self puanduanISNull:itemSM.data.userinfos.hobby];
            
            [wodexinHeader.imageView setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,itemSM.data.imgurl] fileName:@"头像100.png" Width:wodexinHeader.imageView.frame.size.width];
            
            contentArray = [@[contentArr1,contentArr2,contentArr3] mutableCopy];
            
        }
        [_tableView reloadData];
    }];
    
}

- (NSString *)puanduanISNull:(id)text{
    if (text == nil || [text isEqual:[NSNull null]] || text == NULL) {
        return @"";
    }else{
        return text;
    }
}

#pragma mark - tabelviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = dataArray[indexPath.section][indexPath.row];
    if (![title isEqualToString:@"联系电话"] && ![title isEqualToString:@"星座"]) {
        if (![title isEqualToString:@"生日"] && ![title isEqualToString:@"部门"]) {
            [self tiaozhuangXiugaixinxiTitle:title indexPath:indexPath];
        }else if([title isEqualToString:@"生日"]){
            NSLog(@"生日");
            [self showDatePicker];
            beijingImageView.hidden = NO;
        }else if([title isEqualToString:@"部门"]){
            NSLog(@"部门");
            [self setViewBlur];
            [selectCengJiVC loadCengJiJieGouData];
            blurView.hidden = NO;
        }
             
    }
    
}

- (void)tiaozhuangXiugaixinxiTitle:(NSString *)title indexPath:(NSIndexPath *) indexPath{
    
    WodexinxiViewCell *cell = (WodexinxiViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    NSString * content = contentArray[indexPath.section][indexPath.row];
    NSString *valueStr = valueArray[indexPath.section][indexPath.row];
    
    XiugaiXinxiViewController *xiugai = [[XiugaiXinxiViewController alloc] init];
    xiugai.titleText = title;
    
    xiugai.chuanzhiStr = content;
    
    [xiugai returnText:^(NSString *value) {
        [ServiceShell getupdateUserAttrWithKey:valueStr Value:value Id:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (model.status == 0) {
                if ([title isEqualToString:@"姓名"]) {
                    [AppStore setYongHuMing:value];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:value forKey:@"name"];
                    [userDefaults synchronize];
                    
                }else if ([title isEqualToString:@"职位"]){
                    [AppStore setZhiwei:value];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:value forKey:@"position"];
                    [userDefaults synchronize];
                    
                }
                cell.neirong.text = value;
            }
        }];
    }];
    
    [self.navigationController pushViewController:xiugai animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (hobby.length != 0) {
//        if (indexPath.section == 2 && indexPath.row == 4) {
//            return [self calculateSizeOfModelHeightWithVM];
//        }
//    }
    return 50;
}

- (float)calculateSizeOfModelHeightWithVM{
    CGSize size2 = [hobby sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(211, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size2.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section) {
        return 0;
    }else{
        return 16;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if(section == 1){
        return 2;
    }else{
        return 5;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WodexinxiViewCell *cell = [WodexinxiViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   NSString * title = dataArray[indexPath.section][indexPath.row];
    if (contentArray.count != 0) {
        NSString *name = contentArray[indexPath.section][indexPath.row];
        cell.neirong.text = name;
    }
    //    cell.backgroundColor = [UIColor whiteColor];
    if ([title isEqualToString:@"联系电话"] || [title isEqualToString:@"星座"]) {
        cell.jiantou.hidden = YES;
    }
    
    cell.name.text = title;
    
//    if (indexPath.section == 2 && indexPath.row == 4) {
//        cell.neirong.frame = CGRectMake(cell.neirong.frame.origin.x, cell.neirong.frame.origin.y, cell.frame.size.width, [self calculateSizeOfModelHeightWithVM]);
//    }
    
    return cell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    shengriView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
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

- (void)touxiangShangchuan{
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
    
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.000001);
    NSString *imgStr = Base64_bianMa_DataToString(imageData);
    
    //存图片
    [LDialog showWaitBox:@"上传照片中"];
    [ServiceShell getUploadWithImgNmae:@"touxinag.png" ImgStr:imgStr usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM) {
        [LDialog closeWaitBox];
        callback();
        if (ItemSM.result == 0) {
            
            [ServiceShell getupdateUserAttrWithKey:@"imgurl" Value:ItemSM.data.url Id:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
                if (model.status == 0) {
//                    [self initData];
                    [AppStore setYonghuImageView:ItemSM.data.url];
                    wodexinHeader.imageView.image = newImage;
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:ItemSM.data.url forKey:@"imgurl"];
                    [userDefaults synchronize];
                    
                }
            }];
            
        }
        
    }];
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
}

- (void)handleSingleTapFrom{
    beijingImageView.hidden = YES;
    [self endDatePicker];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)itemClick:(UIBarButtonItem *)sender {
    if (sender == doneItem){
        beijingImageView.hidden = YES;
        [self setDataPicker];
        [self endDatePicker];
    }else if(sender == cancelItem){
        beijingImageView.hidden = YES;
        [self endDatePicker];
    }
}

#pragma showDatePicker
- (void)showDatePicker{
    UIView *v = nil;
    v = shengriView;
    float y = ScreenHeight - (v.frame.size.height+v.frame.origin.y-_tableView.contentOffset.y);
    NSLog(@"%f",y);
    
    currentPoint = _tableView.contentOffset;
    if (y <shengriView.frame.size.height) {
        CGPoint p = _tableView.contentOffset;
        p.y += (shengriView.frame.size.height);
        [_tableView setContentOffset:p animated:YES];
    }
    [UIView animateWithDuration:0.25
                     animations:^{
                         shengriView.frame = CGRectMake(0, ScreenHeight-200-NavHeight, ScreenWidth, 200);
                         
                         
                     } completion:nil];
    
}

#pragma endShowDatePicker
- (void)endDatePicker{
    [_tableView setContentOffset:currentPoint animated:YES];
    [UIView animateWithDuration:0.25
                     animations:^{
                         shengriView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
                         
                     } completion:nil];
}

- (void)setDataPicker{
    WodexinxiViewCell *cell = (WodexinxiViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
    WodexinxiViewCell *cell2 = (WodexinxiViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:2]];
    NSDate * date = datePicker.date;
    NSDate * nowDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    if (date == [date laterDate:nowDate] && datePicker.datePickerMode == UIDatePickerModeDate) {
        [SDialog showTipViewWithText:@"时间必须早于当前日期" hideAfterSeconds:1.5f];
    }else{
        if (datePicker.datePickerMode == UIDatePickerModeDate) {
            NSString *shengri = [NSString stringWithFormat:@"%4ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)components.day];
            [ServiceShell getupdateUserAttrWithKey:@"birthday" Value:shengri Id:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
                if (model.status == 0) {
                    cell.neirong.text = shengri;
                    NSString *month = [shengri substringWithRange:NSMakeRange(5, 2)];
                    NSString *day = [shengri substringWithRange:NSMakeRange(8, 2)];
                    cell2.neirong.text = [XingzuoVM chuanzhiNum:[NSString stringWithFormat:@"%@%@",month,day]];
                }
            }];
        }
        
        
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
        WodexinxiViewCell *bumen = (WodexinxiViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        __block WodexinxiViewController *blSelf = self;
        selectCengJiVC.quXiaoBlock = ^(){
            [blSelf disMissBgView];
        };
        selectCengJiVC.passValueFromXuanze = ^(NSString* buMen,NSString *deptId){
            
            [ServiceShell getupdateUserAttrWithKey:@"deptid" Value:deptId Id:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
                if (serviceContext.isSucceeded && model.status == 0) {
                    bumen.neirong.text = buMen;
                    [blSelf disMissBgView];
                }
                
            }];
            
            
        };
        [blurView addSubview:selectCengJiVC.view];
    }
}
// 点击模糊的背景消失
- (void)disMissBgView {
    //    selectCengJiVC.view.hidden = YES;
    blurView.hidden = YES;
}

@end
