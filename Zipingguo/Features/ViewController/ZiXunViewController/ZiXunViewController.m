//
//  ZiXunViewController.m
//  Zipingguo
//
//  Created by sunny on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunViewController.h"
#import "ZiXunTopScrollView.h"
#import "SDCycleScrollView.h"
#import "ZiXunCell.h"
#import "ZiXunXiangQingViewController.h"
#import "JZScrollView.h"
#import "ZiXunServiceShell.h"

#define topScrollViewH 44
#define adHeaderViewH ScreenWidth *186/375.0

@interface ZiXunViewController ()<ZiXunTopScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    /// 默认选中第0个，显示最新资讯
    int currentIndex;
    
    // 一页多少个
    int pageSize;
    
    /// 标题数组
    NSMutableArray *leiBieArray;
    JZScrollView *bgScrollView;
    ZiXunTopScrollView *topScrollView;
    // 列表总数据源
    NSMutableArray *dataArray;
    NSMutableArray *cycleDataArray;
    NSMutableArray *tableViewArray;
    NSMutableArray *cycleViewArray;
    
    /// 记录刷新是从第几个开始
    NSMutableArray *startIndexArray;
    ///  YES:刚进来只加载最新  NO: 不是第一次进来的时候加载最新
    BOOL isStartFirst;
}
@end

@implementation ZiXunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     self.title = @"资讯";
    currentIndex = 0;
    pageSize = 10;
    isStartFirst = YES;
    tableViewArray = [@[] mutableCopy];
    dataArray = [@[] mutableCopy];
    leiBieArray = [@[] mutableCopy];
    cycleDataArray = [@[] mutableCopy];
    cycleViewArray = [@[] mutableCopy];
    startIndexArray = [@[] mutableCopy];
    if (IOSDEVICE) {
        self.automaticallyAdjustsScrollViewInsets= YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self createBgScrollView];
    [self loadTitleListData];
}
#pragma  mark - UI
- (void)createBgScrollView{
    bgScrollView = [[JZScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topScrollView.frame), ScreenWidth, ScreenHeight - NavHeight - topScrollViewH)];
    bgScrollView.pagingEnabled = YES;
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = self.navigationController.screenEdgePanGestureRecognizer;
    [bgScrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
    bgScrollView.delegate =self;
    [self.view addSubview:bgScrollView];
}
#pragma  mark - 加载数据
- (void)loadTitleListData{
    if ([NetWork isConnectionAvailable]) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [ZiXunServiceShell getZiXunLeiBieListWithCompanyID:[AppStore getGongsiID] UsingCallback:^(DCServiceContext *context, ZiXunLeiBieListSM *sm) {
        [LDialog closeWaitBox];
        if (context.isSucceeded) {
            [leiBieArray removeAllObjects];

            [leiBieArray addObject:[ZiXunLeiBieSM getZiXunSMWithTitle:@"最新"]];
            for (ZiXunLeiBieSM *leiBieSM in sm.data) {
                [leiBieArray addObject:leiBieSM];
            }
            [leiBieArray addObject:[ZiXunLeiBieSM getZiXunSMWithTitle:@"收藏"]];
            
            
            [self createTopScrollView:leiBieArray];
            
            // 创建tableView
            [self createTableView:leiBieArray];
            // 加载选中的title的列表数据
            [self clickTopViewWithIndex:0 LeiBieID:ZiXun_zuiXinID LeiBieTitle:@"最新"];
        }
    }];  
}
#pragma mark -  顶部view的button点击
/// 刷新当前列表
- (void)clickTopViewWithIndex:(int)index LeiBieID:(NSString *)leiBieID LeiBieTitle:(NSString *)leiBieTitle{
    // 当前显示的是哪个tableView
    currentIndex = index;
    ///  有数据就不再重复加载
    if ([dataArray[currentIndex] count] > 0 || ((SDCycleScrollView *)((UITableView *)tableViewArray[currentIndex]).tableHeaderView).imageURLStringsGroup.count > 0) {
        return;
    }
    // 从0开始加载数据
    [self loadZiXunListDataWithLeiBieID:leiBieID LeiBieTitle:leiBieTitle StartIndex:0];
}
#pragma mark -  加载列表数据
- (void)loadZiXunListDataWithLeiBieID:(NSString *)leiBieID LeiBieTitle:(NSString *)leiBieTitle StartIndex:(int)startIndex{
    /// 此处是刷新
    if (startIndex == 0) {
         [dataArray[currentIndex] removeAllObjects];
        [startIndexArray replaceObjectAtIndex:currentIndex withObject:[NSNumber numberWithInt:startIndex]];
    }
    if ([leiBieID isEqualToString:ZiXun_zuiXinID]) {
        if ([NetWork isConnectionAvailable] && isStartFirst == NO) {
            [LDialog showWaitBox:@"数据加载中"];
        }
        [ZiXunServiceShell getZuiXinZiXunListWithStartIndex:startIndex PageSize:pageSize usingCallback:^(DCServiceContext *context, ZiXunListSM *sm) {
            [((UITableView *)tableViewArray[currentIndex]).footer endRefreshing];
            [((UITableView *)tableViewArray[currentIndex]).header endRefreshing];
            [LDialog closeWaitBox];
            if (context.isSucceeded) {
                if (sm.data.count < pageSize) {
                    [((UITableView *)tableViewArray[currentIndex]).footer endRefreshingWithNoMoreData];
                }

                if (sm.data.count > 0) {
                    int start =  startIndex ;
//                    start = startIndex + (int)sm.data.count;
                    start = (int)[(dataArray[currentIndex]) count];
                    NSLog(@"最新:::%d",start);
                    [startIndexArray replaceObjectAtIndex:currentIndex withObject:[NSNumber numberWithInt:start]];
                }
                isStartFirst = NO;
//                [self fillListDataWith:sm];
                ((UITableView *)tableViewArray[currentIndex]).hidden = NO;
                for (ZiXunListSubSM *subSM in sm.data) {
                    ZiXunCellModel *model = [[ZiXunCellModel alloc] init];
                    [model setModelWithSM:subSM];
                    [dataArray[currentIndex] addObject:model];
                }
                [tableViewArray[currentIndex] reloadData];
            }
        }];
    }else if ([leiBieID isEqualToString:ZiXun_shouCangID]){
        if ([NetWork isConnectionAvailable]) {
            [LDialog showWaitBox:@"数据加载中"];
        }
        [ZiXunServiceShell getShouCangZiXunListWithYongHuID:[AppStore getYongHuID] StartIndex:startIndex PageSize:pageSize UsingCallback:^(DCServiceContext *context, ZiXunListSM *sm) {
            [((UITableView *)tableViewArray[currentIndex]).footer endRefreshing];
            [((UITableView *)tableViewArray[currentIndex]).header endRefreshing];
            [LDialog closeWaitBox];
            if (context.isSucceeded) {
                if (sm.data.count < pageSize) {
                    [((UITableView *)tableViewArray[currentIndex]).footer endRefreshingWithNoMoreData];
                }
                if (sm.data.count > 0) {
                    int start =  startIndex ;
                    start = startIndex + (int)sm.data.count;
                    NSLog(@"收藏:::%d",start);
                    [startIndexArray replaceObjectAtIndex:currentIndex withObject:[NSNumber numberWithInt:start]];
                }
                ((UITableView *)tableViewArray[currentIndex]).hidden = NO;
                for (ZiXunListSubSM *subSM in sm.data) {
                    ZiXunCellModel *model = [[ZiXunCellModel alloc] init];
                    [model setModelWithSM:subSM];
                    [dataArray[currentIndex] addObject:model];
                }
                [tableViewArray[currentIndex] reloadData];
            }
        }];
        
    }else{
        if ([NetWork isConnectionAvailable]) {
            [LDialog showWaitBox:@"数据加载中"];
        }
        [ZiXunServiceShell getCommenZiXunListWithLeiBieID:leiBieID startIndex:startIndex PageSize:pageSize usingCallback:^(DCServiceContext *context, ZiXunListSM *sm) {
            [((UITableView *)tableViewArray[currentIndex]).footer endRefreshing];
            [((UITableView *)tableViewArray[currentIndex]).header endRefreshing];
            [LDialog closeWaitBox];
            if (context.isSucceeded) {
                if (sm.data1.count < pageSize) {
//                    [((UITableView *)tableViewArray[currentIndex]).footer endRefreshingWithNoMoreData];
                }
                if (sm.data1.count > 0) {
                    int start =  startIndex ;
//                    start = startIndex + (int)sm.data1.count;
                    
                    NSLog(@"其它:::%d",start);
                    [startIndexArray replaceObjectAtIndex:currentIndex withObject:[NSNumber numberWithInt:start]];
                }
                [self fillListDataWith:sm];
            }
        }];
    }
}
// 填充列表数据 (收藏,最新不一样，收藏列表数据是data，其他为data1)
- (void)fillListDataWith:(ZiXunListSM *)sm{
    ((UITableView *)tableViewArray[currentIndex]).hidden = NO;
    for (ZiXunListSubSM *subSM in sm.data1) {
        ZiXunCellModel *model = [[ZiXunCellModel alloc] init];
        [model setModelWithSM:subSM];
        [dataArray[currentIndex] addObject:model];
    }
    [self fillTableViewHeaderData:sm.data];
    [tableViewArray[currentIndex] reloadData];
}
// 填充广告数据
- (void)fillTableViewHeaderData:(NSArray *)headerArray{
    NSMutableArray *leiBieImageStrArray = [@[] mutableCopy];
    NSMutableArray *leiBieTitleArray = [@[] mutableCopy];
    for (ZiXunListSubSM *subSM in headerArray) {
        ZiXunCellModel *model = [[ZiXunCellModel alloc] init];
        [model setModelWithSM:subSM];
        [cycleDataArray[currentIndex] addObject:model];
        [leiBieImageStrArray addObject:[NSString stringWithFormat:@"%@%@",URLKEY,model.iconImage]];
        [leiBieTitleArray addObject:model.titleName];
    }
    if (headerArray.count > 0) {
        ((UITableView *)tableViewArray[currentIndex]).tableHeaderView = cycleViewArray[currentIndex];
        ((SDCycleScrollView *)cycleViewArray[currentIndex]).autoScroll = YES;
        ((SDCycleScrollView *)((UITableView *)tableViewArray[currentIndex]).tableHeaderView).imageURLStringsGroup = leiBieImageStrArray;
        ((SDCycleScrollView *)((UITableView *)tableViewArray[currentIndex]).tableHeaderView).titlesGroup = leiBieTitleArray;
    }
   
}
#pragma mark - 创建顶部view
- (void)createTopScrollView:(NSArray *)netArray{
    NSMutableArray *titleArray = [@[] mutableCopy];
    for (ZiXunLeiBieSM *sm in netArray) {
        [titleArray addObject:sm.title];
        NSMutableArray *tempArry = [@[] mutableCopy];
        [dataArray addObject:tempArry];
    }
    topScrollView = [[ZiXunTopScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topScrollViewH) andItems:titleArray];
    topScrollView.selectedIndex = 0;
    topScrollView.topViewDelegate = self;
    topScrollView.backgroundColor = RGBACOLOR(37, 38, 49, 1);
    [self.view addSubview:topScrollView];
}
#pragma mark - 创建tableView
- (void)createTableView:(NSArray *)netArray{
    // 每个期初都是从0开始加载
    for (int i = 0 ; i < netArray.count; i ++) {
        [startIndexArray addObject:[NSNumber numberWithInt:0]];
    }
    for (int i = 0; i < netArray.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, bgScrollView.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.hidden = YES;
        tableView.separatorColor = Fenge_Color;
        tableView.tag = i + 10;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.tableFooterView = footerView;
        [tableViewArray addObject:tableView];
        [bgScrollView addSubview:tableView];
        //网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, adHeaderViewH) imageURLStringsGroup:nil];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.delegate = self;
        cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        cycleScrollView.autoScrollTimeInterval = 4.0f;
        cycleScrollView.tag = 100+i;
        NSMutableArray *tempArry = [@[] mutableCopy];
        [cycleDataArray addObject:tempArry];
        [cycleViewArray addObject:cycleScrollView];
        
        ZiXunLeiBieSM *leiBie = netArray[i];
        MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
            // 刷新
            [self loadZiXunListDataWithLeiBieID:leiBie.titleID LeiBieTitle:leiBie.title StartIndex:0];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        tableView.header = header;
        MJYaMiFooter *footer = [MJYaMiFooter footerWithRefreshingBlock:^{
            [self loadZiXunListDataWithLeiBieID:leiBie.titleID LeiBieTitle:leiBie.title StartIndex:[startIndexArray[i] intValue]];
        }];
        tableView.footer = footer;
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray[tableView.tag - 10] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZiXunCell *cell = [ZiXunCell cellForTableView:tableView];
    cell.model = dataArray[tableView.tag - 10][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZiXunCellModel *model = dataArray[tableView.tag - 10][indexPath.row];
    [self pushToXiangQingVC:model];
}
#pragma mark - UIscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == bgScrollView) {
        int offsetx = (scrollView.contentOffset.x + ScreenWidth * 0.5) / ScreenWidth;
        [topScrollView selectIndex:offsetx withFlag:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == bgScrollView) {
        int newIndex = (scrollView.contentOffset.x ) / ScreenWidth;
        // 加载数据
        ZiXunLeiBieSM *leiBieSM = leiBieArray[newIndex];
            [self clickTopViewWithIndex:newIndex LeiBieID:leiBieSM.titleID LeiBieTitle:leiBieSM.title];
    }
}
#pragma mark - ZiXunTopScrollViewDelegate
- (void)ZiXunTopScrollViewDelegateBarSelectedIndexChanged:(int)newIndex{
    [bgScrollView setContentOffset:CGPointMake(ScreenWidth * newIndex, 0) animated:NO];
    SDCycleScrollView *cycleScrollView = (SDCycleScrollView *) [self.view viewWithTag:100 + newIndex];
    cycleScrollView.autoScroll = YES;
    ZiXunLeiBieSM *leiBieSM = leiBieArray[newIndex];
    [self clickTopViewWithIndex:newIndex LeiBieID:leiBieSM.titleID LeiBieTitle:leiBieSM.title];
}
#pragma mark - SDCycleDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ZiXunCellModel *model = cycleDataArray[currentIndex][index];
   [self pushToXiangQingVC:model];
}
/**
 *  <#Description#>
 *
 *  @param index 跳转详情vc需要传的值
 */
- (void)pushToXiangQingVC:(ZiXunCellModel *)ziXunCellModel{
    ZiXunXiangQingViewController *ziXunXiangQingVC = [[ZiXunXiangQingViewController alloc] init];
    //    ziXunXiangQingVC.currentIndex = currentIndex;
    ziXunXiangQingVC.ziXunID = ziXunCellModel.ziXunID;
    ziXunXiangQingVC.ziXunCellModel = ziXunCellModel;
    ziXunXiangQingVC.actionCallback = ^(NSString *actionName){
        if ([actionName isEqualToString:@"赞"]) {
            
        }else if ([actionName isEqualToString:@"收藏"]){
            // 当前显示是收藏页面
            if (currentIndex == tableViewArray.count - 1) {
                ZiXunLeiBieSM *leiBie = leiBieArray[currentIndex];
                [self loadZiXunListDataWithLeiBieID:leiBie.titleID LeiBieTitle:leiBie.title StartIndex:0];
            }else{
                [[dataArray lastObject] removeAllObjects];
            }
        }else if ([actionName isEqualToString:@"取消收藏"]){
            // 当前显示是收藏页面
            if (currentIndex == tableViewArray.count - 1) {
                ZiXunLeiBieSM *leiBie = leiBieArray[currentIndex];
                [self loadZiXunListDataWithLeiBieID:leiBie.titleID LeiBieTitle:leiBie.title StartIndex:0];
            }else{
                [[dataArray lastObject] removeAllObjects];
            }
        }else if ([actionName isEqualToString:@"评论"]){
            // 是列表，而不是广告
            if ([dataArray[currentIndex] indexOfObject:ziXunCellModel]!= NSNotFound){
                NSInteger index = [dataArray[currentIndex] indexOfObject:ziXunCellModel];
                [tableViewArray[currentIndex] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    };
    ziXunXiangQingVC.fenXiangImage = ziXunCellModel.iconImage;
    [self.navigationController pushViewController:ziXunXiangQingVC animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    for (UITableView *tableView in tableViewArray) {
        SDCycleScrollView *cycleView = (SDCycleScrollView *)tableView.tableHeaderView;
        [cycleView clearCache];
    }
}
#pragma mark - layout
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(topScrollView.frame), ScreenWidth, ScreenHeight - NavHeight - topScrollView.height);
    bgScrollView.contentSize = CGSizeMake(ScreenWidth * leiBieArray.count, topScrollView.height);
    for (UITableView *tableView in tableViewArray) {
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
