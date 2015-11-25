//  DaKaViewController.m
//  Zipingguo
//  Created by sunny on 15/9/24.
//  Copyright © 2015年 fuyonghua. All rights reserved.
#import "DaKaViewController.h"
#import "NSDate+Extensions.h"
#import "UILabel+Extension.h"
#import "UIImage+UIImageCategory.h"
#import "NSDate+Compare.h"
#import "DaKaCell.h"
#import "JinRiDaKaJiLuCell.h"
#import "DaKaTopAnimationView.h"
#import "WeizhiViewVC.h"
#import "CustomActionSheet.h"
#import "YuyinView.h"
#import "TupianView.h"
#import "WeizhiView.h"
#import "DaKaJiLuViewController.h"
#import "ZYQAssetPickerController.h"
#import "UIKeyboardCoView.h"
#import <BaiduMapAPI/BMKPoiSearchOption.h>
#import <BaiduMapAPI/BMKGeocodeSearch.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import "EMCDDeviceManager.h"
#import "DXRecordView.h"
#import "EMCDDeviceManager+Media.h"
#import "Base64JiaJieMi.h"
#import "DaKaServiceShell.h"
#import "MJYaMiRefreshHeader.h"
#import "MJRefresh.h"

/// 常规头view的选择位置label
static float headerLabelHeight = 30.0f;
/// 常规头view的高度
static float headerHeight = ScreenWidth *294/375.0  + headerLabelHeight -1;
/// 打卡按钮的view
static float bottomHeight = 66.0f;
/// 语音，位置，图片选择按钮宽度
static int btnW = ScreenWidth/3.0;
///  语音，位置，图片选择按钮高度
static float btnH = 50;
static float toolViewH = 160;
static float waiChuAddressViewH = 23;
static float waiChuYuYinViewH = 26;
/// 下边距
static float marginY = 15;
/// 语音地址边距距
static float marginH = 10;
static float imageW = (ScreenWidth - 30 - 10)/3.0;

@interface DaKaViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIScrollViewDelegate,TupianViewDelegate,WeizhiViewDelegate,YuyinViewDelegate,UITextViewDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,CustomActionSheetDelegate>{
    BOOL isWaiChu;
    // 默认打卡地点
    //下拉刷新
    MJYaMiRefreshHeader *header;
    DaKaModel *lastAddressName;
    NSUserDefaults *lastAddressUserDefaults;
    // tableView相关
    DaKaModel *_currentModel;
    UITableView *diZhiTableView;
    NSMutableArray *dataArray;
    UITableView *jiLuTableView;
    NSMutableArray *jinRiJiLuDataArray;
    // 地图相关
    ///geo搜索服务
    BMKGeoCodeSearch *geoCodeSearch;
    /// 当前坐标
    CLLocationCoordinate2D currentLocation;
    /// 定位管理服务
    BMKLocationService * locationService;
    ///反编译的次数，如果 > 5次，提示反编译失败
    NSInteger loadSearchTimer;
    // 时间相关
    NSDate *nowDate;
    NSTimer *timer;
    NSString *week;
    // 顶部动画View
    DaKaTopAnimationView *topAnimationView;
    /// 白天YES 晚上NO 记忆上一秒时间
    BOOL _currentDayOrNight;
    /// 当前是白天或者晚上
    BOOL _lastDayOrNight;
    ///  打卡类型 常规和外出
    DaKaType _daKaType;
    // 外出打卡
    /// 外出打卡选择的位置
    NSString *waiChuAddress;
    WeizhiView *waiChuAddressView;
    /// 发出成功语音的数组
    NSMutableArray *yuYinUrlArray;
    /// 需要展示的语音 - 显示在scrollView上的
    NSMutableArray *showYuyinViewArray;
    /// 图片地址数组
    NSMutableArray *tuPianUrlArray;
    NSMutableArray *photoViewArray;
    /// 图片Image数组
    NSMutableArray *photosArray;
    // 录音提示view
    DXRecordView *recordView;
    NSMutableArray *recordTimeArray;
    NSMutableArray *recordPathArray;
    // 外出定位坐标
    CLLocationCoordinate2D coordinate2d;
    /// 外出定位view
    WeizhiView *weizhiView;
    // 图片添加 +号按钮
    UIButton *_addImageBtn;
    BOOL isNotFirst;
    BOOL isRefreshing;
}
@property (strong, nonatomic) MessageReadManager *messageReadManager;
@end
@implementation DaKaViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    locationService.delegate = self;
    geoCodeSearch.delegate = self;
    if (isNotFirst) {
        if ([NetWork isConnectionAvailable]) {
            [self huoquRiqiDateWithNetWork:YES];
        }else{
            [self huoquRiqiDateWithNetWork:NO];
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    locationService.delegate = nil;
    geoCodeSearch.delegate = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [locationService stopUserLocationService];
    [topAnimationView invalidateTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArray = [@[] mutableCopy];
    _currentModel = [[DaKaModel alloc] init];
    if (IOSDEVICE) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    isNotFirst = YES;
    [self huoquRiqiDateWithNetWork:NO];
    // 默认常规打卡
    lastAddressUserDefaults = [NSUserDefaults standardUserDefaults];
    _daKaType = DaKaTypeChangGui;
    [self createUI];
    [self loadJinRiJiLuData];
    // 实例化地图相关
    [self createBaiDuMap];
}
#pragma  mmark - 外出打卡数据初始化
- (void)initWaiChuViewData{
    yuYinUrlArray = [@[] mutableCopy];
    tuPianUrlArray = [@[] mutableCopy];
    recordPathArray = [@[] mutableCopy];
    recordTimeArray = [@[] mutableCopy];
    showYuyinViewArray = [@[] mutableCopy];
    photoViewArray = [@[] mutableCopy];
    /// 图片Image数组
    photosArray = [@[] mutableCopy];
    yuYinView.frame = CGRectMake(- ScreenWidth, ScreenHeight - NavHeight - toolViewH, ScreenWidth, toolViewH);
    shuRuTextView.delegate = self;
    shuRuTextView.placeholder = @"在此编辑外出原因（1000字以内）";
    shuRuTextView.frame = CGRectMake(15, 5, ScreenWidth - 30, ScreenHeight - NavHeight - toolViewH);
    waiChuBottomScrollView.frame = CGRectMake(0, 0, ScreenWidth, 0);
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [waiChuView addGestureRecognizer:recognizer];
    [self resetDibuViewFrameForKeyboard];
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    [shuRuTextView resignFirstResponder];
}
- (void)createBaiDuMap{
    locationService = [[BMKLocationService alloc] init];
    [locationService startUserLocationService];
    geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
}
#pragma mark - Data
- (void)loadJinRiJiLuData{
    [DaKaServiceShell daKaGetRecordWithYongHuID:[AppStore getYongHuID] DaKaType:DaKaTypeChangGui IsToday:1 Start:0 CountSize:10 UsingCallback:^(DCServiceContext *context, DaKaJiLuSM *sm) {
        if (context.isSucceeded && sm.status == 0) {
            NSArray *arr = [sm.data1 componentsSeparatedByString:@","];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            nowDate = [formatter dateFromString:arr[0]];
            week = arr[1];
            [self huoquRiqiDateWithNetWork:YES];
            if (sm.data.count > 0) {
                [self fillJinRiDataWith:sm.data[0]];
                [jiLuTableView reloadData];
            }
            
        }
    }];
}
- (void)fillJinRiDataWith:(SingleDayListSM *)singleDayListSM{
    jinRiJiLuDataArray = [@[] mutableCopy];
    for (SingleDaySM *sm in singleDayListSM.list) {
        JinRiDaKaJiLuModel *model = [[JinRiDaKaJiLuModel alloc] init];
        [model setVMWithSM:sm];
        [jinRiJiLuDataArray addObject:model];
    }
}
#pragma mark - 创建UI
- (void)createUI{
    [self createDaoHang];
    waiChuView.hidden = YES;
    changGuiScrollView.hidden = NO;
    [self createHeaderView];
    [self createTopAnimationView];
    // 默认为常规打卡
    [self createTopViewWithDaKaType:_daKaType];
    [self createTableView];
}
// 导航
- (void)createDaoHang{
     self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self addSegmentedControlWithLeftTitle:@"常规打卡" RightTitle:@"外出打卡" selector:@selector(segmentedControlValueChanged:)];
    [self addItemWithTitle:@"" imageName:@"历史记录icon.png" selector:@selector(rightBtnClick) location:NO];
}
- (void)createHeaderView{
    //下拉刷新
    header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        isRefreshing = YES;
        [LDialog showWaitBox:@"获取定位中"];
        [locationService startUserLocationService];
    }];
    header.isWhite = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    changGuiScrollView.header = header;
    headerView.frame = CGRectMake(0, 0 , ScreenWidth, headerHeight);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerHeight - headerLabelHeight, ScreenWidth , headerLabelHeight)];
    headerLabel.text = @"    选择打卡位置";
    headerLabel.textColor = RGBACOLOR(155, 155, 155, 1);
    headerLabel.font = [UIFont systemFontOfSize:11];
    headerLabel.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [headerView addSubview:headerLabel];
    [headerView addSubview:jiLuHeaderView];
    jiLuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerLabel.y - 44, ScreenWidth -15 , 44) style:UITableViewStylePlain];
    jiLuTableView.delegate = self;
    jiLuTableView.dataSource = self;
    jiLuTableView.backgroundColor = [UIColor clearColor];
    jiLuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *jiLuHeaderClearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, jiLuTableView.width, 20)];
    jiLuHeaderClearView.backgroundColor = [UIColor clearColor];
    UIView *jiLuFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    jiLuTableView.tableFooterView = jiLuFooterView;
    [headerView addSubview:jiLuTableView];
}
// 顶部动画view
- (void)createTopAnimationView{
    topAnimationView = [[DaKaTopAnimationView alloc] init];
    [headerView addSubview:topAnimationView];
    [headerView insertSubview:topAnimationView belowSubview:timeView];
}
// 创建topView
- (void)createTopViewWithDaKaType:(DaKaType)daKaType{
    if (daKaType == DaKaTypeChangGui) {
        timeView.frame = CGRectMake(timeView.x, 67, timeView.width, timeView.height);
    }else if (daKaType == DaKaTypeWaiChu){
        timeView.frame = CGRectMake(timeView.x, 0, timeView.width, timeView.height);
    }
}
// 创建当天打卡记录tableView
- (void)createTableView{
    diZhiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerHeight, ScreenWidth , ScreenHeight - NavHeight - headerHeight -1 ) style:UITableViewStylePlain];
    diZhiTableView.delegate = self;
    diZhiTableView.dataSource = self;
    diZhiTableView.showsVerticalScrollIndicator = NO;
    diZhiTableView.backgroundColor = Bg_Color;
    diZhiTableView.separatorColor = Fenge_Color;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, bottomHeight)];
    footerView.backgroundColor = Bg_Color;
    diZhiTableView.tableFooterView = footerView;
    [self.view addSubview:diZhiTableView];
}
#pragma mark - 数据
- (void)loadDaKaAddress:(NSArray *)addressArray{
    [dataArray removeAllObjects];
    for (BMKPoiInfo * info in addressArray) {
        DaKaModel *model = [[DaKaModel alloc] init];
        model.addressName = info.name;
        model.detailAddress = info.address;
        model.positionx = info.pt.latitude;
        model.positiony = info.pt.longitude;
        [dataArray addObject:model];
    }
    if ([[lastAddressUserDefaults objectForKey:@"lastAddressName"] length] > 0) {
        lastAddressName = [lastAddressUserDefaults objectForKey:@"lastAddressName"];
        for (int i = 0; i< [dataArray count]; i++) {
            DaKaModel *model = dataArray[i];
            if ([model.detailAddress isEqual:lastAddressName]) {
                model.isSelect = YES;
                [dataArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                _currentModel = model;
                break;
            }
        }
    }
    [diZhiTableView reloadData];
    [self viewDidLayoutSubviews];
    
}
- (void)huoquRiqiDateWithNetWork:(BOOL)isNetwork{
    if (isNetwork) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [formatter stringFromDate:nowDate];
        NSDateComponents* components = [formatter dateFromString:date].components;
        riQiLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@",(long)components.year,(long)components.month,(long)components.day,week];
    }else{
        NSDateComponents* components = [NSDate date].components;
        NSString *weekday = [NSDate date].weekdayStr;
        riQiLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@",(long)components.year,(long)components.month,(long)components.day,weekday];
        nowDate = [NSDate date];
    }
    [self getCurrentDay];
    [self daojishiTime];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishiTime) userInfo:nil repeats:YES];
}
- (void)getCurrentDay{
    if ([NSDate isBetweenFromHour:5 toHour:17 withNowData:nowDate]) {
        _lastDayOrNight = YES;
        headerBgView.backgroundColor = RGBACOLOR(84, 189, 254, 1);
    }else{
        headerBgView.backgroundColor = RGBACOLOR(53, 55, 68, 1);
        _lastDayOrNight = NO;
    }
    [topAnimationView showAnimationIsDay:_lastDayOrNight];
}
- (void)daojishiTime{
    nowDate = [nowDate dateByAddingTimeInterval:1];
    NSDateComponents *c = [nowDate components];
    NSString *weekday = [NSDate date].weekdayStr;
    riQiLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld %@",(long)c.year,(long)c.month,(long)c.day,weekday];
    timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)c.hour,(long)c.minute];
    if ([NSDate isBetweenFromHour:5 toHour:17 withNowData:nowDate]) {
        _currentDayOrNight = YES;
        headerBgView.backgroundColor = RGBACOLOR(84, 189, 254, 1);
    }else{
        headerBgView.backgroundColor = RGBACOLOR(53, 55, 68, 1);
        _currentDayOrNight = NO;
    }
    if (_lastDayOrNight != _currentDayOrNight && _currentDayOrNight == YES ) {
        // 当前与上一秒时间不同，并且是白天
        _lastDayOrNight = _currentDayOrNight;
        [topAnimationView showAnimationIsDay:_lastDayOrNight];
    }else if (_currentDayOrNight != _lastDayOrNight && _currentDayOrNight == NO){
        // 当前与上一秒时间不同，并且是晚上
        _lastDayOrNight = _currentDayOrNight;
        [topAnimationView showAnimationIsDay:_lastDayOrNight];
    }
}
#pragma mark - tableDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == diZhiTableView) {
         return [dataArray count];
    }else{
        return [jinRiJiLuDataArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == diZhiTableView) {
        DaKaCell *cell = [DaKaCell cellFortableView:diZhiTableView];
        cell.model = dataArray[indexPath.row];
        return cell;
    }else{
        JinRiDaKaJiLuCell *cell = [JinRiDaKaJiLuCell cellForTableView:jiLuTableView];
        cell.model = jinRiJiLuDataArray[indexPath.row];
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == diZhiTableView) {
        return 60.0f;
    }else{
        return 20.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == diZhiTableView) {
        _currentModel.isSelect = NO;
        DaKaModel *model = dataArray[indexPath.row];
        model.isSelect = YES;
        _currentModel = model;
        [tableView reloadData];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offPoint = scrollView.contentOffset;
    if (scrollView == changGuiScrollView) {
        if (offPoint.y > 0) {
            headerView.frame = CGRectMake(0, offPoint.y,ScreenWidth, headerHeight);
        }else{
            diZhiTableView.frame = CGRectMake(0,-offPoint.y + headerHeight, diZhiTableView.width, diZhiTableView.height);
            if (dataArray.count >0) {
                [diZhiTableView setContentOffset:CGPointZero];
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == changGuiScrollView && !header.isRefreshing) {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, headerHeight);
        scrollView.contentOffset = CGPointMake(0, 0);
        diZhiTableView.frame = CGRectMake(0, headerHeight -1, diZhiTableView.width, diZhiTableView.height);
    }

}
#pragma mark - 导航segment点击事件
- (void)segmentedControlValueChanged:(UISegmentedControl *)seg{
    _daKaType = seg.selectedSegmentIndex == 0 ? DaKaTypeChangGui:DaKaTypeWaiChu;
    [shuRuTextView resignFirstResponder];
    [self createTopViewWithDaKaType:_daKaType];
    if (seg.selectedSegmentIndex == 0) {
        changGuiScrollView.hidden = NO;
        diZhiTableView.hidden = NO;
        waiChuView.hidden = YES;
    }else{
        if (isWaiChu == NO) {
            [self initWaiChuViewData];
            isWaiChu = YES;
        }        
        changGuiScrollView.hidden = YES;
        diZhiTableView.hidden = YES;
        waiChuView.hidden = NO;
    }
}
- (IBAction)daKaBtnClick:(id)sender {
    DaKaSM *daKaSM = [[DaKaSM alloc] init];
    daKaSM.yongHuID = [AppStore getYongHuID];
    daKaSM.companyid = [AppStore getGongsiID];
    daKaSM.daKaType = _daKaType;
    if (_daKaType == DaKaTypeChangGui) {
        if (_currentModel.detailAddress.length == 0) {
             [self showHint:@"请先选择打卡的位置"];
            return;
        }
        [lastAddressUserDefaults setObject:_currentModel.detailAddress forKey:@"lastAddressName"];
        [lastAddressUserDefaults synchronize];
        [LDialog showWaitBox:@"常规打卡中"];
        daKaSM.address = _currentModel.detailAddress;
        daKaSM.positionx = _currentModel.positionx;
        daKaSM.positiony = _currentModel.positiony;
        [self daKaWith:daKaSM];
    }else{
        if (waiChuAddress.length == 0) {
            [self showHint:@"请先选择打卡的位置"];
            return;
        }
        if ([shuRuTextView.text length] > 1000) {
            [self showHint:@"外出原因不能超过1000字!"];
            return;
        }
        daKaSM.content = shuRuTextView.text;
        daKaSM.address = waiChuAddress;
        daKaSM.positionx = coordinate2d.latitude;
        daKaSM.positiony = coordinate2d.longitude;
         [LDialog showWaitBox:@"外出打卡中"];
        if (recordPathArray.count != 0 && recordPathArray.count != yuYinUrlArray.count) {
            [yuYinUrlArray removeAllObjects];

            for (NSString *recordPath in recordPathArray) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSFileManager *manager = [NSFileManager defaultManager];
                    NSData *data = [manager contentsAtPath:recordPath];
                    NSString *string = [Base64JiaJieMi base64_bianMa_DataToStringS:data];
                    [ServiceShell getUploadWithImgNmae:[[recordPath componentsSeparatedByString:@"/"] lastObject] ImgStr:string usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM){
                        if (serviceContext.isSucceeded && ItemSM.result == 0) {
                            [yuYinUrlArray addObject:ItemSM.data.url];
                            if (yuYinUrlArray.count == recordPathArray.count) {
                                [self shangChuanPhotosWith:daKaSM];
                            }
                        }else{
                            [LDialog closeWaitBox];
                            [self showHint:@"打卡失败，请重新打卡"];
                        }
                    }];
                });
            }
        }else{
            [self shangChuanPhotosWith:daKaSM];
        }
    }
}
- (void)daKaWith:(DaKaSM *)daKaSM{
    NSMutableArray *tempTuPianArray = [@[] mutableCopy];
    for (int i = 0; i < tuPianUrlArray.count; i++ ) {
        DaKaSoundsSM *tuPianSM = [[DaKaSoundsSM alloc] init];
        tuPianSM.soundUrl = tuPianUrlArray[i];
        [tempTuPianArray addObject:tuPianSM];
    }
    daKaSM.imagesStr = tempTuPianArray;
    NSMutableArray *tempSoundArray = [@[] mutableCopy];
    for (int i = 0; i < yuYinUrlArray.count; i++) {
        DaKaSoundsSM *soundSM = [[DaKaSoundsSM alloc] init];
        soundSM.soundUrl = yuYinUrlArray[i];
        soundSM.soundTime = [recordTimeArray[i] intValue];
        [tempSoundArray addObject:soundSM];
    }
    daKaSM.daKaSounds = tempSoundArray;
    [DaKaServiceShell daKaPostWithDaKaSM:daKaSM UsingCallback:^(DCServiceContext *context, ResultMode *sm) {
        [LDialog closeWaitBox];
        if (context.isSucceeded && sm.status == 0) {
            if (_daKaType == DaKaTypeWaiChu) {
                waiChuBottomScrollView.frame = CGRectZero;
                [waiChuBottomScrollView removeAllSubviews];
                [recordPathArray removeAllObjects];
                waiChuAddress = @"";
                [yuYinUrlArray removeAllObjects];
                /// 需要展示的语音 - 显示在scrollView上的
                [showYuyinViewArray removeAllObjects];
                [tuPianUrlArray removeAllObjects];
                [photoViewArray removeAllObjects];
                [photosArray removeAllObjects];
                [recordTimeArray removeAllObjects];
                [recordPathArray removeAllObjects];
                [yuYinUrlArray removeAllObjects];
                shuRuTextView.text = @"";
                [self getWaiChuScrollViewHeight];
            }
            [self loadJinRiJiLuData];
            [self showHint:@"打卡成功"];
        }else{
            [self showHint:@"打卡失败，请重新打卡"];
        }
    }];
}

- (void)shangChuanPhotosWith:(DaKaSM *)daKaSM{
    if (photosArray.count != 0 && photosArray.count != tuPianUrlArray.count) {
        [tuPianUrlArray removeAllObjects];
        for (UIImage *tempImg in photosArray) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *newImage = [tempImg fixOrientation:tempImg];
                NSData *imageData = UIImageJPEGRepresentation(newImage,0.00001);
                NSString *imgStr = Base64_bianMa_DataToString(imageData);
                [ServiceShell getUploadWithImgNmae:@"tupian.png" ImgStr:imgStr usingCallback:^(DCServiceContext *serviceContext, ResultModelShangchuanWenjianSM *ItemSM) {
                    if (serviceContext.isSucceeded && ItemSM.result == 0) {
                        [tuPianUrlArray addObject:ItemSM.data.url];
                        if (tuPianUrlArray.count == photosArray.count) {
                            [self daKaWith:daKaSM];
                        }
                    }else{
                        [LDialog closeWaitBox];
                        [self showHint:@"请先选择打卡的位置"];
                    }
                }];
            });
        }
    }else{
        [self daKaWith:daKaSM];
    }
}
#pragma mark - 导航右按钮点击事件
- (void)rightBtnClick{
    DaKaJiLuViewController *vc = [[DaKaJiLuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 百度地图delegate
#pragma mark - 百度地图定位delegate
// 将要开始定位
- (void)willStartLocatingUser{
    [locationService startUserLocationService];
}
// 关闭定位
- (void)didStopLocatingUser{
    [locationService stopUserLocationService];
    [LDialog closeWaitBox];
    [changGuiScrollView.header endRefreshing];
}

// 位置改变
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    /// geo检索信息类
    BMKReverseGeoCodeOption *geoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    geoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    
    // 根据地理坐标获取地址信息
    BOOL isSuccess = [geoCodeSearch reverseGeoCode:geoCodeOption];
    loadSearchTimer ++;
    if (isSuccess) {
         NSLog(@"反编译成功次数 ： %ld",(long)loadSearchTimer);
        [locationService stopUserLocationService];
        [LDialog closeWaitBox];
        if (isRefreshing) {
            [self loadJinRiJiLuData];
        }
        [changGuiScrollView.header endRefreshing];
    }else{
        geoCodeSearch = nil;
        NSLog(@"反编译失败");
        if (loadSearchTimer > 100 ) {
            [locationService stopUserLocationService];
            [changGuiScrollView.header endRefreshing];
            [LDialog closeWaitBox];
            [self showHint:@"获取周围位置失败，请稍后再试"];
        }
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败！！！");
    [changGuiScrollView.header endRefreshing];
}
#pragma mark -BMKGeoCodeSearchDelegate
///返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    // 获得地址 -- poi地址
    [self loadDaKaAddress:result.poiList];
    if (error == 0) {
        
    }else{
        [locationService startUserLocationService];
    }
}
#pragma mark - layout
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    changGuiScrollView.frame = CGRectMake(0, 0 , ScreenWidth, ScreenHeight - NavHeight);
    headerView.frame = CGRectMake(0, 0 , ScreenWidth, headerHeight);
    topAnimationView.frame = CGRectMake(0, 0, ScreenWidth, headerHeight - 30);
    jiLuTableView.frame = CGRectMake(0, headerView.height - headerLabelHeight - 44 - 19, ScreenWidth - 15 ,  44 );
    jiLuHeaderView.frame = CGRectMake(0, jiLuTableView.y - 34 , ScreenWidth,37);
    headerBgView.frame = CGRectMake(0, 0, ScreenWidth, headerHeight - 20);
    timeLabel.centerX = riQiLabel.centerX = timeView.width/2;
    diZhiTableView.frame = CGRectMake(0, headerHeight -1, ScreenWidth,ScreenHeight - NavHeight - headerHeight + 1);
    changGuiScrollView.contentSize = CGSizeMake(ScreenWidth, changGuiScrollView.height + 1);
    // 外出
    waiChuView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight);
    toolView.frame = CGRectMake(0, ScreenHeight - NavHeight - toolViewH, ScreenWidth, toolViewH);
    [self toolBtnLayout];
    if ([diZhiTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [diZhiTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([diZhiTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [diZhiTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    bottomView.frame = CGRectMake(0, ScreenHeight - NavHeight -bottomHeight, ScreenWidth, bottomHeight);
    daKaButton.frame = CGRectMake((ScreenWidth - 50)/2, 1, 50, 50);
    [self.view bringSubviewToFront:bottomView];
    [self.view insertSubview:self.blurView aboveSubview:bottomView];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shuRuTextView resignFirstResponder];
}
- (void)dealloc{
    timer = nil;
}
#pragma  mark --- 外出View
#pragma mark - actionClick
- (void)toolBtnLayout{
    yuYinBtn.frame = CGRectMake(0, 0, btnW, btnH);
    tuPianBtn.frame = CGRectMake(CGRectGetMaxX(yuYinBtn.frame), 0, ScreenWidth - 2 *btnW, btnH);
    weiZhiBtn.frame = CGRectMake(CGRectGetMaxX(tuPianBtn.frame), 0, btnW, btnH);
}
- (IBAction)toolBtnTouchUpInside:(UIButton *)sender {
    [shuRuTextView resignFirstResponder];
    if ([sender isEqual:yuYinBtn]) {
        yuYinView.hidden = NO;
        [UIView animateWithDuration:0.35f animations:^{
            yuYinView.frame = CGRectMake(0, ScreenHeight - NavHeight - toolViewH, yuYinView.width, yuYinView.height);
            yuYinBtn.frame = CGRectMake(weiZhiBtn.centerX, weiZhiBtn.centerY, 0, 0);
            tuPianBtn.frame = CGRectMake(weiZhiBtn.centerX, weiZhiBtn.centerY, 0, 0);
            yuYinBtn.center = tuPianBtn.center = weiZhiBtn.center ;
        }];
    }else if ([sender isEqual:tuPianBtn]){
        [self creatActionSheet];
    }else if ([sender isEqual:weiZhiBtn]){
        [self getDingWeiAddress];
    }else if ([sender isEqual:luYinCloseButton]){
        yuYinView.hidden = YES;
        [UIView animateWithDuration:0.35f animations:^{
            yuYinView.frame = CGRectMake(- ScreenWidth, ScreenHeight - NavHeight - toolViewH, yuYinView.width, yuYinView.height);
        } completion:^(BOOL finished) { }];
        [UIView animateWithDuration:0.35f animations:^{
            [self toolBtnLayout];
        }];
    }
}
// 录音按钮点击
- (IBAction)luYinBtnTouchDown:(UIButton *)sender {
    
    if (![[EMCDDeviceManager sharedInstance] emCheckMicrophoneAvailability]) {
        [[[UIAlertView alloc] initWithTitle:@"麦克风无法使用"
                                    message:@"请打开手机设置->隐私->麦克风,把访问麦克风状态设置为可用,再进入本程序"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (recordPathArray.count == 3) luYinButton.enabled = NO;
    recordView = [[DXRecordView alloc] initWithFrame:CGRectMake((ScreenWidth-145)/2.0, 190, 145, 141)];
    recordView.centerY = (self.view.height  - yuYinView.height)/2;
    [self.view addSubview:recordView];
    [self.view bringSubviewToFront:recordView];
    // 存储录音文件
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"luyin%d%d",(int)time,arc4random() % 100000];
    // 环信录音按钮按钮触发开始录音事件
    [recordView recordButtonTouchDown];
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (error) {
            NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
        }
    }];
}
// 录音结束
- (IBAction)luYinBtnTouchUpInside:(UIButton *)sender {
    [recordView recordButtonTouchUpInside];
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [recordTimeArray addObject:[NSString stringWithFormat:@"%ld",(long)aDuration]];
            [recordPathArray addObject:recordPath];
            [self getWaiChuScrollViewHeight];
        }else{
            [SDialog showMessage:NSLocalizedString(@"media.timeShort", @"The recording time is too short") toView:nil];
        }
    }];
    [recordView removeFromSuperview];
}

- (IBAction)luYinBtnTouchUpOutside:(UIButton *)sender {
    [recordView recordButtonTouchUpOutside];
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [recordView removeFromSuperview];
}
- (IBAction)luYinBtnDragInside:(UIButton *)sender {
    [recordView recordButtonDragInside];
}
- (IBAction)luYinBtnDragOutside:(UIButton *)sender {
    [recordView recordButtonDragOutside];
}
#pragma mark - 计算外出scrollView的高度
- (void)getWaiChuScrollViewHeight{
    [self creatYuYinList:recordPathArray];
    [self creatWaiChuAddress:waiChuAddress];
    [self creatPhotos:photosArray];
    if (photosArray.count == 0 && [waiChuAddress length] == 0 && recordPathArray.count == 0) {
        waiChuBottomScrollView.frame = CGRectZero;
    }else{
        float yuYinAllH = recordPathArray.count != 0 ? recordPathArray.count * waiChuYuYinViewH + marginH * (recordPathArray.count -1) : 0 ;
        float photoAllHeight = photosArray.count != 0 ? imageW + 5 : 0 ;
        float addressAllH ;
        if (photoAllHeight == 0 && yuYinAllH != 0) {
            /// 只有语音没有图片 地址有上边距
            addressAllH = [waiChuAddress length] > 0 ? marginH + waiChuAddressViewH: 0;
        }else if (yuYinAllH == 0 && photoAllHeight == 0){
            /// 语音图片都没有  没有边距
            addressAllH = [waiChuAddress length] > 0 ? waiChuAddressViewH: 0;
        }else if (photoAllHeight != 0  && yuYinAllH == 0){
            /// 没有语音  有图片  有下边距
             addressAllH = [waiChuAddress length] > 0 ? waiChuAddressViewH + marginY : 0;
        }else{
            /// 有语音  有图片  有上下边距
            addressAllH = [waiChuAddress length] > 0 ? marginH +waiChuAddressViewH +  marginY : 0;
        }
        float scrollHeight = marginH + yuYinAllH + addressAllH + photoAllHeight + marginY;
        if (ScreenHeight == 480) {
            if (scrollHeight > 150) {
              waiChuBottomScrollView.frame = CGRectMake(0, ScreenHeight - NavHeight -toolViewH - 150, ScreenWidth, 150);
            }else{
                waiChuBottomScrollView.frame = CGRectMake(0, ScreenHeight - NavHeight -toolViewH - scrollHeight, ScreenWidth, scrollHeight);
            }
        }else{
            waiChuBottomScrollView.frame = CGRectMake(0, ScreenHeight - NavHeight -toolViewH - scrollHeight, ScreenWidth, scrollHeight);
        }
        if (photosArray.count != 0) {
            waiChuBottomScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(_addImageBtn.frame) + marginY + 1);
        }else{
            waiChuBottomScrollView.contentSize = CGSizeMake(ScreenWidth, scrollHeight);
        }
    }
    shuRuTextView.frame = CGRectMake(15, 5, ScreenWidth - 30, ScreenHeight - NavHeight - toolViewH - waiChuBottomScrollView.height - 15 - 10);
}
#pragma mark - 外出滚动视图里面的布局
/// 重新绘制语音view
- (void)creatYuYinList:(NSMutableArray *)yuyinArray{
    // 清空显示语音view的数组
    [showYuyinViewArray removeAllObjects];
    // 清空屏幕上显示的语音view
    for (UIView *subView in waiChuBottomScrollView.subviews) {
        if ([subView isKindOfClass:[YuyinView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (recordPathArray.count < 3){
        luYinButton.enabled = YES;
        yuYinBtn.enabled = YES;
    }
    if (yuyinArray.count == 0) return;
    for (int i = 0; i < yuyinArray.count; i++) {
        YuyinView *yuyinView = [[YuyinView alloc] init];
        yuyinView.frame = CGRectMake(15, marginH + (waiChuYuYinViewH + marginH) * i, 77, waiChuYuYinViewH);
        yuyinView.miaoshuLabel.text = [NSString stringWithFormat:@"%@''",[recordTimeArray objectAtIndex:i]];
        yuyinView.delegate = self;
        [waiChuBottomScrollView addSubview:yuyinView];
        [showYuyinViewArray addObject:yuyinView];
    }
    if (showYuyinViewArray.count == 3) {
        luYinButton.enabled = NO;
        yuYinBtn.enabled = NO;
    }
}
/// 重新绘制地址
- (void)creatWaiChuAddress:(NSString *)waichuAddressName{
    
    for (UIView *subView in waiChuBottomScrollView.subviews) {
        if ([subView isKindOfClass:[WeizhiView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    if ([waichuAddressName length] != 0 && waichuAddressName != nil) {
        weizhiView = [[WeizhiView alloc] init];
        weizhiView.delegate = self;
        float yuyinH = marginH + (waiChuYuYinViewH + marginH) * recordPathArray.count;
        weizhiView.frame = CGRectMake(15, yuyinH, 290, waiChuAddressViewH);
        weizhiView.weizhi.text = waichuAddressName;
        [waiChuBottomScrollView addSubview:weizhiView];
    }
}
/// 重新绘制图片
- (void)creatPhotos:(NSMutableArray *)photos{
    [photoViewArray removeAllObjects];
    if (photos.count >= 9) tuPianBtn.enabled = NO;
    else tuPianBtn.enabled = YES;
    for (UIView *subView in waiChuBottomScrollView.subviews) {
        if ([subView isKindOfClass:[TupianView class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    if (photos.count == 0) return;
    float panding = 5.0;
    if (photos.count > 0) {
        for (int i = 0; i < photos.count + 1; i++) {
            TupianView *tupianView = [[TupianView alloc] init];
            float addressMaxH = 0;
            float yuYinMaxH = 0;
            if (recordPathArray.count != 0) {
                yuYinMaxH = recordPathArray.count * waiChuYuYinViewH + recordPathArray.count * marginH;
                addressMaxH = waiChuAddress.length > 0 ? waiChuAddressViewH + marginH : 0;;
            }else{
                addressMaxH = waiChuAddress.length > 0 ? waiChuAddressViewH + marginH : 0;
            }
            tupianView.frame = CGRectMake(15+(i%3)*(imageW +panding),   marginY + addressMaxH + yuYinMaxH + (imageW+panding)*(i/3), imageW, imageW);
            tupianView.userInteractionEnabled = YES;
            tupianView.delegate = self;
            if (i < photos.count) {
                tupianView.tupianImageBox.image = [photos objectAtIndex:i];
                [waiChuBottomScrollView addSubview:tupianView];
                [photoViewArray addObject:tupianView];
            }
            if (i == photos.count && i < 9) {
                 _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addImageBtn.frame = CGRectMake(15+(i%3)*(imageW +panding),   marginY + addressMaxH + yuYinMaxH + (imageW+panding)*(i/3), imageW, imageW);
                [_addImageBtn setImage:[UIImage imageNamed:@"虚线框.png"] forState:UIControlStateNormal];
                _addImageBtn.adjustsImageWhenHighlighted = NO;
                [_addImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [waiChuBottomScrollView addSubview:_addImageBtn];
            }
        }
    }
}
#pragma mark - 选择定位地址delegate -- 获取定位
- (void)getDingWeiAddress{
    [shuRuTextView resignFirstResponder];
    if ([CLLocationManager locationServicesEnabled]) {
        WeizhiViewVC *weizhiVC = [[WeizhiViewVC alloc] init];
        
        weizhiVC.passValueFromWeizhi = ^(NSString *weizhiName,CLLocationCoordinate2D coordinate){
            coordinate2d = coordinate;
            waiChuAddress = weizhiName;
            [self getWaiChuScrollViewHeight];
        };
        [self.navigationController pushViewController:weizhiVC animated:YES];
    }else{
        [LDialog showMessage:@"请打开您的定位功能"];
    }
}
#pragma mark - CustomActionSheet
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
    if(indexButton == 1){
        //选择多张图片
        [self getPhotosWithAlbum];
    }else if (indexButton == 2){
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
- (void)getPhotosWithAlbum{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9 - photosArray.count;
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
    [self presentViewController:picker animated:YES completion:^{
    }];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if (photosArray.count == 0) {
        [self getWaiChuScrollViewHeight];
    }
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [photosArray addObject:tempImg];
        [self getWaiChuScrollViewHeight];

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
/// 系统相机
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
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
// 照相的上传图片
- (void)saveSelectedImage:(UIImage *)image completion:(void(^)()) callback{
    if (photosArray.count == 0) {
        [self getWaiChuScrollViewHeight];
    }
    UIImage *newImage = [image fixOrientation:image];
    [photosArray addObject:newImage];
    [self getWaiChuScrollViewHeight];
    callback();
}
- (void) image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo{
}
- (void)addImageBtnClick{
    [shuRuTextView resignFirstResponder];
    [self creatActionSheet];
}
#pragma mark - 语音，位置，图片 delegate
- (void)ShanchuYuyin:(YuyinView *)luyinView{
    for(int i = 0;i < [showYuyinViewArray count];i++){
        YuyinView *Yuyin = showYuyinViewArray[i];
        if([Yuyin isEqual:luyinView]){
            [showYuyinViewArray removeObjectAtIndex:i];
            [recordTimeArray removeObjectAtIndex:i];
            [recordPathArray removeObjectAtIndex:i];
            [self getWaiChuScrollViewHeight];
        }
    }
}
- (void)shanchuWeizhi:(WeizhiView *)address{
    waiChuAddress = @"";
    [self getWaiChuScrollViewHeight];
}
- (void)ShanchuTupian:(TupianView *)tupianView1{
    for(int i = 0;i < [photoViewArray count];i++){
        TupianView *imageBox = [photoViewArray objectAtIndex:i];
        if([imageBox isEqual:tupianView1]){
            [photoViewArray removeObjectAtIndex:i];
            [photosArray removeObjectAtIndex:i];
            [self getWaiChuScrollViewHeight];
        }
    }
}
- (void)TupianViewDidTap:(TupianView *)tapView{
    for(int i = 0;i < [photoViewArray count];i++) {
        UIImageView *imageBox = [photoViewArray objectAtIndex:i];
        if([imageBox isEqual:tapView]){
            [self.messageReadManager showBrowserWithImages:photosArray];
            [self.messageReadManager showImageWithIndex:i];
        }
    }
}
- (void)BofangYuyin:(YuyinView *)luyinView{
    for(int i = 0;i < [showYuyinViewArray count];i++)
    {
        YuyinView *yuYin = [showYuyinViewArray objectAtIndex:i];
        if([yuYin isEqual:luyinView]){
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:[recordPathArray objectAtIndex:i] completion:^(NSError *error) {
                if (error) {
                    NSLog(@"%@",[error description]);
                }
            }];
        }
    }
}
- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    return _messageReadManager;
}
#pragma mark - 控制dibuview
- (void)resetDibuViewFrameForKeyboard{
    UIKeyboardCoView *view = [[UIKeyboardCoView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
    view.beginRect = ^(CGRect beginRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            yuYinView.frame = CGRectMake(0, beginRect.origin.y- 50, yuYinView.width, toolViewH);
            toolView.frame = CGRectMake(0, beginRect.origin.y - 50, toolView.width, toolViewH);
        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            yuYinView.frame = CGRectMake(0, endRect.origin.y- toolViewH, yuYinView.width, toolViewH);
            toolView.frame = CGRectMake(0, endRect.origin.y - toolViewH, toolView.width, toolViewH);
        }];
    };
    [self.view addSubview:view];
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *lang;
    if (textView == shuRuTextView){
        if (IOSDEVICE) {
            lang = textView.textInputMode.primaryLanguage;
        }else{
            lang = [[UITextInputMode currentInputMode] primaryLanguage];
        }
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (textView.text.length >1000) {
                    textView.text = [textView.text substringToIndex:1000];
                }
            }
        }else{
            if (textView.text.length >1000) {
                textView.text = [textView.text substringToIndex:1000];
            }
        }
    }
}
@end
