//
//  DaKaJiLuViewController.m
//  Zipingguo
//
//  Created by sunny on 15/9/25.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "DaKaJiLuViewController.h"
#import "HeaderView.h"
#import "NSString+Ext.h"
#import "ChangGuiDaKaJiLuCell.h"
#import "ChangGuiDaKaJiLuHeaderView.h"
#import "WaiChuDaKaJiLuCell.h"
#import "DaKaServiceShell.h"
#import "EMCDDeviceManager.h"

@interface DaKaJiLuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
     ///常规考勤记录 的 pageIndex
    int changGuiIndex;
    int waiChuIndex;
    /// 一次多少个
    int size;
    
    JiLuType currentJiLuType;
    NSMutableArray *changGuiDataArray;
    NSMutableArray *waiChuDataArray;
    UITableView *changGuiTableView;
    UITableView *waiChuTableView;
    // 当前显示在最上端的是tableView的哪一组
    NSInteger changGuiNow;
    NSInteger waiChuNow;
    
    // 提示view
    UIView *rightTipView;
    UILabel *rightMonth;
    UILabel *rightYear;
    
    NSMutableArray *waiChuCellHeightArray;
}
@property (strong, nonatomic) MessageReadManager *messageReadManager;
@end

@implementation DaKaJiLuViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createNav];
    // 默认常规打卡
    currentJiLuType = JiLuTypeChangGui;
    size = 10;
    changGuiDataArray = [@[] mutableCopy];
    waiChuDataArray = [@[] mutableCopy];
    waiChuCellHeightArray = [@[] mutableCopy];
    [self createTableView];
    [self createRightTipView];
    [self loadChangGuiData];
}
- (void)createNav{
    [self addSegmentedControlWithLeftTitle:@"常规记录" RightTitle:@"外出记录" selector:@selector(segmentedControlValueChanged:)];
}
- (void)createRightTipView{
    rightTipView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 150, 0, 150, 42)];
    rightTipView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rightTipView];
    [self.view bringSubviewToFront:rightTipView];
    rightMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, rightTipView.width - 15, 10)];
    rightMonth.backgroundColor = [UIColor clearColor];
    rightMonth.textAlignment = IOSDEVICE ? NSTextAlignmentRight : UITextAlignmentRight;
    rightMonth.font = [UIFont systemFontOfSize:12];
    rightMonth.textColor = RGBACOLOR(160, 160, 160, 1);
    [rightTipView addSubview:rightMonth];
    rightYear = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, rightTipView.width - 15, 10)];
    rightYear.backgroundColor = [UIColor clearColor];
    rightYear.textAlignment = IOSDEVICE ? NSTextAlignmentRight : UITextAlignmentRight;
    rightYear.font = [UIFont systemFontOfSize:9];
    rightYear.textColor = RGBACOLOR(160, 160, 160, 1);
    [rightTipView addSubview:rightYear];
}
- (void)createTableView{
    
    changGuiTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    changGuiTableView.delegate = self;
    changGuiTableView.dataSource = self;
    changGuiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:changGuiTableView];
//    UIImageView *changGuiFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//    changGuiFooterView.image = [UIImage imageNamed:@"分割线.png"];
//    changGuiTableView.tableFooterView = changGuiFooterView;
    MJYaMiRefreshHeader *changGuiHeader = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        changGuiIndex = 0;
        [self loadChangGuiData];
    }];
    changGuiHeader.lastUpdatedTimeLabel.hidden = YES;
    changGuiTableView.header = changGuiHeader;
    MJYaMiFooter *changGuifooter = [MJYaMiFooter footerWithRefreshingBlock:^{
        [self loadChangGuiData];
    }];
    changGuiTableView.footer = changGuifooter;

    
    waiChuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    waiChuTableView.delegate = self;
    waiChuTableView.dataSource = self;
    waiChuTableView.hidden = YES;
    waiChuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:waiChuTableView];
    MJYaMiRefreshHeader *waiChuHeader = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        waiChuIndex = 0;
        [self loadWaiChuData];
    }];
    waiChuHeader.lastUpdatedTimeLabel.hidden = YES;
    waiChuTableView.header = waiChuHeader;
    MJYaMiFooter *waiChufooter = [MJYaMiFooter footerWithRefreshingBlock:^{
        [self loadWaiChuData];
    }];
    waiChuTableView.footer = waiChufooter;
    // 网络判断
    if (![NetWork isConnectionAvailable]) {
        HeaderView *headerView = [[HeaderView alloc] init];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        changGuiTableView.tableHeaderView = headerView;
        
        HeaderView *headerView2 = [[HeaderView alloc] init];
        headerView2.frame = CGRectMake(0, 0, ScreenWidth, 40);
        waiChuTableView.tableHeaderView = headerView2;
    }else{
        changGuiTableView.tableHeaderView = nil;
        waiChuTableView.tableHeaderView = nil;
    }
}
- (void)loadChangGuiData{
    [DaKaServiceShell daKaGetRecordWithYongHuID:[AppStore getYongHuID] DaKaType:1 IsToday:0 Start:changGuiIndex CountSize:size UsingCallback:^(DCServiceContext *context, DaKaJiLuSM *sm) {
        [changGuiTableView.header endRefreshing];
        [changGuiTableView.footer endRefreshing];
        if (context.isSucceeded && sm.status == 0) {
            [self fillChangGuiData:sm];
            if (sm.data.count < size) {//没有更多数据
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [changGuiTableView.footer endRefreshingWithNoMoreData];
            }
        }
    }];
}
- (void)fillChangGuiData:(DaKaJiLuSM *)sm{
    if (changGuiIndex == 0) {
        [changGuiDataArray removeAllObjects];
    }
    for (int i  = 0; i < sm.data.count ; i ++) {
        SingleDayListSM *listSM = sm.data[i];
        ChangGuiDaKaJiLuheaderModel *headerModel = [[ChangGuiDaKaJiLuheaderModel alloc] init];
        NSArray *riQiArray = [listSM.datetime componentsSeparatedByString:@"-"];
        headerModel.year = riQiArray[0];
        headerModel.month = riQiArray[1];
        headerModel.ri = riQiArray[2];
        headerModel.weekDay = listSM.week;
        for (SingleDaySM *daySM in listSM.list) {
            ChangGuiDaKaJiLuModel *model = [[ChangGuiDaKaJiLuModel alloc] init];
            model.time = [[daySM.attdtime componentsSeparatedByString:@" "][1] substringToIndex:5];
            model.address = daySM.attdaddr;
            [headerModel.dayArray addObject:model];
         }
        // 默认刷新显示第一个月份的
        if (i == 0 && changGuiIndex == 0) {
            [self fillTipViewData:headerModel];
        }
        [changGuiDataArray addObject:headerModel];
    }
    changGuiIndex = (int)changGuiDataArray.count;
   [changGuiTableView reloadData];
}
- (void)fillWaiChuData:(DaKaJiLuSM *)sm{
    if (waiChuIndex == 0) {
        [waiChuDataArray removeAllObjects];
        [waiChuCellHeightArray removeAllObjects];
    }
    for (int i  = 0; i < sm.data.count ; i ++) {
        SingleDayListSM *listSM = sm.data[i];
        ChangGuiDaKaJiLuheaderModel *headerModel = [[ChangGuiDaKaJiLuheaderModel alloc] init];
        NSArray *riQiArray = [listSM.datetime componentsSeparatedByString:@"-"];
        headerModel.year = riQiArray[0];
        headerModel.month = riQiArray[1];
        headerModel.ri = riQiArray[2];
        headerModel.weekDay = listSM.week;
        NSMutableArray *tempHeightArray = [@[] mutableCopy];
        for (int j = 0 ; j < listSM.list.count ; j ++) {
            SingleDaySM *daySM = listSM.list[j];
            WaiChuDaKaJiLuModel *waiChuModel = [[WaiChuDaKaJiLuModel alloc] init];
            waiChuModel.time = [[daySM.attdtime componentsSeparatedByString:@" "][1] substringToIndex:5];
            waiChuModel.address = daySM.attdaddr;
            waiChuModel.content = daySM.content;
            NSMutableArray *yuYinArray = [@[] mutableCopy];
            for (DaKaImageSoundSM *sound in daySM.sounds) {
                YuyinModel *model = [[YuyinModel alloc] init];
                [model setYuYinModelWithSM:sound];
                [yuYinArray addObject:model];
            }
            waiChuModel.yuYinArray = yuYinArray;
            NSMutableArray *tuPianArray = [@[] mutableCopy];
            for (DaKaImageSoundSM *tuPian in daySM.imgs) {
                TupianModel *model = [[TupianModel alloc] init];
                [model setTuPianModelWithSM:tuPian];
                [tuPianArray addObject:model];
            }
            waiChuModel.tuPianArray = tuPianArray;
            [headerModel.dayArray addObject:waiChuModel];
            [tempHeightArray addObject:[NSString stringWithFormat:@"%f",[self getWaiChuCellHeightWithHeaderModel:waiChuModel]]];
        }
        // 默认刷新显示第一个月份的
        if (i == 0 && waiChuIndex == 0) {
            [self fillTipViewData:headerModel];
        }
        [waiChuDataArray addObject:headerModel];
        [waiChuCellHeightArray addObject:tempHeightArray];
    }
    waiChuIndex = (int)waiChuDataArray.count;
    [waiChuTableView reloadData];
}
- (void)loadWaiChuData{
    [DaKaServiceShell daKaGetRecordWithYongHuID:[AppStore getYongHuID] DaKaType:2 IsToday:0 Start:waiChuIndex CountSize:size UsingCallback:^(DCServiceContext *context, DaKaJiLuSM *sm) {
        [waiChuTableView.header endRefreshing];
        [waiChuTableView.footer endRefreshing];
        if (context.isSucceeded && sm.status == 0) {
            if (sm.data.count < size) {//没有更多数据
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [waiChuTableView.footer endRefreshingWithNoMoreData];
            }
            [self fillWaiChuData:sm];
        }
    }];
}

- (void)fillTipViewData:(ChangGuiDaKaJiLuheaderModel *)headerModel{
    if (headerModel == nil) {
        rightMonth.text = @"";
        rightYear.text = @"";
    }else{
        rightMonth.text = [NSString stringWithFormat:@"%@月",headerModel.month];
        rightYear.text = headerModel.year;
    }
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == changGuiTableView) {
        return [changGuiDataArray count];
    }else{
        return [waiChuDataArray count];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == changGuiTableView) {
        return [((ChangGuiDaKaJiLuheaderModel *)changGuiDataArray[section]).dayArray count];
    }else{
        return [((ChangGuiDaKaJiLuheaderModel *)waiChuDataArray[section]).dayArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == changGuiTableView) {
        ChangGuiDaKaJiLuCell *cell = [ChangGuiDaKaJiLuCell cellForTableView:tableView];
        cell.model = ((ChangGuiDaKaJiLuheaderModel *)changGuiDataArray[indexPath.section]).dayArray[indexPath.row];
        return cell;
    }else{
        WaiChuDaKaJiLuCell *cell = [WaiChuDaKaJiLuCell cellForTableView:tableView];
        cell.model =  ((ChangGuiDaKaJiLuheaderModel *)waiChuDataArray[indexPath.section]).dayArray[indexPath.row];
        cell.chaKanPhotos = ^(int index,NSArray *photosArray){
            [self.messageReadManager showBrowserWithImages:photosArray];
            [self.messageReadManager showImageWithIndex:index];
        };
        cell.boFangYuYinClick = ^(YuyinView *yuyinView){
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:yuyinView.fileNameUrl completion:^(NSError *error) {
                
            }];
        };
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == changGuiTableView) {
        return 32.0f;
    }else{
        return [waiChuCellHeightArray[indexPath.section][indexPath.row] floatValue];
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     ChangGuiDaKaJiLuHeaderView *header = [ChangGuiDaKaJiLuHeaderView headerForTableView:tableView];
    if (tableView == changGuiTableView) {
        header.model = changGuiDataArray[section];
    }else{
        header.model = waiChuDataArray[section];
    }
     return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (tableView == changGuiTableView) {
        if (changGuiNow > section) {
            //下滑动
            changGuiNow = section;
        }
    }else{
        if (waiChuNow > section) {
            //下滑动
            waiChuNow = section;
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    
     if (tableView == changGuiTableView) {
         /// 上滑
        if (section == changGuiNow) {
            changGuiNow = changGuiNow + 1;
            return;
        }
     }else{
         if (section == waiChuNow) {
             waiChuNow = waiChuNow + 1;
             return;
         }
     }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y  < 0) {
        rightTipView.frame = CGRectMake(ScreenWidth - rightTipView.width, - scrollView.contentOffset.y, rightTipView.width, rightTipView.height);
    }
    ChangGuiDaKaJiLuheaderModel *headerModel;
    if (scrollView == changGuiTableView && changGuiTableView.hidden == NO) {
        if (changGuiDataArray.count > changGuiNow) {
            headerModel = changGuiDataArray[changGuiNow];
            [self fillTipViewData:headerModel];
        }
    }else if (scrollView == waiChuTableView && waiChuTableView.hidden == NO){
        if (waiChuDataArray.count > waiChuNow) {
            headerModel = waiChuDataArray[waiChuNow];
            [self fillTipViewData:headerModel];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (!changGuiTableView.header.isRefreshing ) {
        rightTipView.frame = CGRectMake(ScreenWidth - rightTipView.width, 0, rightTipView.width, rightTipView.height);
//    }
}


#pragma mark - action
- (void)segmentedControlValueChanged:(UISegmentedControl *)seg{
    ChangGuiDaKaJiLuheaderModel *headerModel;
    // 常规记录
    if (seg.selectedSegmentIndex == 0) {
        currentJiLuType = JiLuTypeChangGui;
        changGuiTableView.hidden = NO;
        waiChuTableView.hidden = YES;
        if (changGuiDataArray.count == 0) {
            changGuiIndex = 0;
            [self fillTipViewData:nil];
            [self loadChangGuiData];
            
        }else{
            headerModel = changGuiDataArray[changGuiNow];
            [self fillTipViewData:headerModel];
        }
    }else{
        // 外出记录
        currentJiLuType = JiLuTypeWaiChu;
        changGuiTableView.hidden = YES;
        waiChuTableView.hidden = NO;
        if (waiChuDataArray.count == 0) {
            waiChuIndex = 0;
            [self fillTipViewData:nil];
            [self loadWaiChuData];
            
        }else{
            headerModel = waiChuDataArray[waiChuNow];
            [self fillTipViewData:headerModel];
        }
    }
}

#pragma mark - 导航右按钮点击事件
- (void)rightBtnClick{
    DaKaJiLuViewController *vc = [[DaKaJiLuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark - layOut
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    changGuiTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight );
    waiChuTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight);
}

- (float)getWaiChuCellHeightWithHeaderModel:(WaiChuDaKaJiLuModel *)model{
    float imageW = (ScreenWidth - 30 - 10)/3;
    // 地址的最下边
    float addressHeight = 20 + 13;
    if (model.content.length != 0 && model.content != nil && model.content != NULL && ![model.content isEqual:[NSNull null]]) {
        CGSize contentLabelSize = [model.content calculateSize:CGSizeMake(ScreenWidth - 15 - 18 , MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        addressHeight += contentLabelSize.height + 5;
    }
    if (model.yuYinArray.count>0) {
        addressHeight += 8 + (26 + 11) * model.yuYinArray.count;
        if (model.tuPianArray.count > 0) {
            addressHeight +=  (imageW + 5) * ((model.tuPianArray.count +2 )/3 );
            addressHeight = addressHeight - 5;
        }else{
            addressHeight = addressHeight - 11;
        }
    }else{
        if (model.tuPianArray.count > 0) {
            addressHeight += 8 + (imageW + 5) * ((model.tuPianArray.count +2 )/3 );
            addressHeight = addressHeight - 5;
        }
        
    }
//    if ([model.content length] == 0 && model.yuYinArray.count == 0 && model.tuPianArray.count == 0) {
//        addressHeight = 28;
//    }
    return addressHeight;
}

#pragma mark - 播放语音
- (void)boFangYuYin{
    
}
- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}
@end
