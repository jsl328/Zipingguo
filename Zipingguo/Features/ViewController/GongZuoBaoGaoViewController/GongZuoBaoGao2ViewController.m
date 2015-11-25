//
//  GongZuoBaoGao2ViewController.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/9.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "GongZuoBaoGao2ViewController.h"
#import "SouSuoBaoGaoViewController.h"
#import "BaoGaoTableViewCell.h"
#import "XinJianBaoGaoViewController.h"
#import "GongZuoBaoGaoXiangQViewController.h"
#import "BaoGaoServiceShell.h"
#import "MJRefresh.h"
#import "MJYaMiFooter.h"
#import "MJYaMiRefreshHeader.h"
#import "BaoGaoHeaderView.h"
#import "YMSearchBar.h"
@interface GongZuoBaoGao2ViewController ()
{
    ///我提交viewmodel数组
    NSMutableArray *_wotijiaoArray;
    ///提交我viewmodel数组
    NSMutableArray *_tijiaowoArray;
    ///用于存放搜索结果
    NSMutableArray *_resultArray;
    
    ///按部门排序-部门名
    NSMutableArray *_bumenArray;
    ///按名称排序-名称
    NSMutableArray *_mingchengArray;
    
    ///部门报告总数据
    NSMutableDictionary *_bumenDic;
    ///人员报告总数据
    NSMutableDictionary *_mingchengDic;

    
    ///提交给我yes 我提交的no
    BOOL _isToMe;
    ///我提交是否加载过，省流量
    BOOL _wotijiaoLoaded;
    ///提交我是否加载过，省流量
    BOOL _tijiaowoLoaded;
    ///是否加载更多数据，yes-上拉加载，no-下拉刷新；
    BOOL _isLoadMore;
    
    UIView *_searchHeader;
    YMSearchBar  *_searchBar;
    UISearchDisplayController *_displayController;
    
    
    ///排序View
    UIView *_sortView;
    ///排序title
    NSArray *_titleArrayOfSort;
    ///当前选中的日周月报
    UIButton *_currentBtn;
    ///当前选中的部门时间名称
    UIButton *_currentSortBtn;
}
@end

@implementation GongZuoBaoGao2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self addSegmentedControlWithLeftTitle:@"提交我的" RightTitle:@"我提交的" selector:@selector(segmentedControlValueChanged:)];
    [self addItemWithTitle:nil imageName:@"快捷操作+icon" selector:@selector(xinjianClick:) location:NO];
    
    //处理搜索上移卡顿问题
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    _wotijiaoArray = [@[] mutableCopy];
    _tijiaowoArray = [@[] mutableCopy];
    _resultArray = [@[] mutableCopy];
    _bumenArray = [@[] mutableCopy];
    _mingchengArray = [@[] mutableCopy];
    
    _bumenDic = [@{} mutableCopy];
    _mingchengDic = [@{} mutableCopy];
    
    _titleArrayOfSort = @[@"时间",@"部门",@"名称"];

    _isToMe = YES;
    _wotijiaoLoaded = NO;
    _tijiaowoLoaded = NO;
    _isLoadMore = NO;
    
    [self createButton];
    [self uiConfig];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadWoTiJiaoData) name:@"shuaxinbaogao" object:nil];
    
    //下拉刷新
    MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        [self loadData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _mTableView.header = header;
    
    //上拉加载
    MJYaMiFooter *footer = [MJYaMiFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadData];
    }];
    _mTableView.footer = footer;
}

#pragma mark - UI 配置
-(void)uiConfig{
    
    _searchHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];

    //提交给我的 搜索
     _searchBar = [[YMSearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 70, 44)];
    _searchBar.placeholder = @"搜索及分类查看";
    _searchBar.delegate = self;
    [_searchHeader addSubview:_searchBar];
    
    
    _mTableView.tableHeaderView = _searchBar;
    
    //footerView 因为底部半透明，所以让最后一条上去
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 57)];
    footerView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
     _mTableView.tableFooterView = footerView;

    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //为搜索控制器中tableView设置数据源和代理
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.delegate = self;
    _displayController.searchResultsTableView.tableHeaderView = _xuanzeView;
   
    _currentBtn = _ribaoBtn;//默认选中

    
}

#pragma mark - 右下角 button 布局
-(void)createButton{
    //排序view
    _sortView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 57, ScreenWidth, 57)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"底部bg"]];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = _sortView.bounds;
    [_sortView addSubview:imageView];
    _sortView.backgroundColor = [UIColor clearColor];
    int width = 40;
    int padding = 15;
    
    //创建主button
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(ScreenWidth - width - padding, 8, width, width);
    [sortBtn setImage:[UIImage imageNamed:@"排序未点"] forState:UIControlStateNormal];
    [sortBtn setImage:[UIImage imageNamed:@"排序已点击"] forState:UIControlStateSelected];
    [sortBtn setCircle];
    [sortBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sortBtn.tag = 200;
    
    //创建展开button
    NSArray *_imageArray = @[@"部门",@"时间",@"名称"];
    NSArray *_imageSelectArray = @[@"部门-已选",@"时间-已选",@"名称-已选"];
    for (int i = 0; i < _titleArrayOfSort.count; i ++ ) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 0, 0);
        btn.frame = sortBtn.frame;
        btn.center = sortBtn.center;
        [btn setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imageSelectArray[i]] forState:UIControlStateSelected];
        [btn setCircle];
        [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        btn.transform = CGAffineTransformMakeRotation(M_PI);//倒着放，为了做旋转效果
        btn.hidden = YES;
        if (i == 1) {//时间
            btn.selected = YES;
            _currentSortBtn = btn;//默认按时间排序
        }
        [_sortView addSubview:btn];
    }
    //后添加主btn是为了让他在最上面，也可以添加展开button的时候insert
    [_sortView addSubview:sortBtn];
    [self.view addSubview:_sortView];
}

#pragma mark - 右下角排序方式 button 点击
-(void)sortBtnClick:(UIButton *)btn{
    
    UIButton *bumenBtn = (UIButton *)[self.view viewWithTag:100];
    UIButton *shijianBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *mingChengBtn = (UIButton *)[self.view viewWithTag:102];

    if (btn.tag == 200) {
        if (btn.selected) {//选中状态 即打开状态 关闭动画
            [UIView animateWithDuration:0.4 animations:^{
                bumenBtn.frame = btn.frame;
                shijianBtn.frame = btn.frame;
                mingChengBtn.frame = btn.frame;
                //旋转
                shijianBtn.transform = CGAffineTransformMakeRotation( M_PI );
                mingChengBtn.transform = CGAffineTransformMakeRotation( M_PI);
                bumenBtn.transform = CGAffineTransformMakeRotation( M_PI);

            } completion:^(BOOL finished) {
                if (finished) {
                    shijianBtn.hidden = YES;
                    mingChengBtn.hidden = YES;
                    bumenBtn.hidden = YES;
                }
            }];
        }else{//打开动画
            int width = 40;
            int padding = 15;
            //@"部门",@"时间",@"名称"
            shijianBtn.hidden = NO;
            mingChengBtn.hidden = NO;
            bumenBtn.hidden = NO;
            [UIView animateWithDuration:0.4 animations:^{
                bumenBtn.frame = CGRectMake(ScreenWidth - width * 4 - padding *4, 8, width, width);
                shijianBtn.frame = CGRectMake(ScreenWidth - width * 3 - padding *3, 8, width, width);
                mingChengBtn.frame = CGRectMake(ScreenWidth - width * 2 - padding *2, 8, width, width);
                //旋转
                shijianBtn.transform = CGAffineTransformMakeRotation(0);
                mingChengBtn.transform = CGAffineTransformMakeRotation(0);
                bumenBtn.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
            }];
        }
    }else{
        _currentSortBtn.selected = NO;
        _currentSortBtn = btn;
        [self sortData];
    }
    btn.selected = !btn.selected;
}

#pragma mark - 加载数据
-(void)loadData{
    
    if(_isToMe){//提交给我
        switch (_currentSortBtn.tag) {
            case 100://部门
                [self loadtijiaowoBuMenSortData];
                break;
            case 101://时间-默认
                [self loadTiJiaoWoData];
                break;
            case 102://名称
                [self loadtijiaowoMingChengSortData];
                break;
            default:
                break;
        }
    }else{
        [self loadWoTiJiaoData];//加载我提交的
    }
}

/**
 *  排序数据，判断加载过直接reload，否则请求数据
 */
-(void)sortData{
    switch (_currentSortBtn.tag) {
        case 100://部门
            if(_bumenArray.count > 0){
                [_mTableView reloadData];
            }else{
                [self loadtijiaowoBuMenSortData];
            }
            break;
        case 101://时间-默认
            if(_tijiaowoArray.count > 0){
                [_mTableView reloadData];
            }else{
                [self loadTiJiaoWoData];
            }
            break;
        case 102://名称
            if(_mingchengArray.count > 0){
                [_mTableView reloadData];
            }else{
                [self loadtijiaowoMingChengSortData];
            }
            break;
        default:
            break;
    }
}

/**
 *  加载提交给我的数据
 */
-(void)loadTiJiaoWoData{
    
    NSInteger start;
    start = _isLoadMore ? [_tijiaowoArray count] : 0;
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell TijiaogeiwoGongzuoWithuserid:[AppStore getYongHuID] Papertype:1 Start:(int)start Count:20 createtime:@"" usingCallback:^(DCServiceContext *sc, BaoGaoResultSM *sm) {
        [LDialog closeWaitBox];
        [_mTableView.header endRefreshing];//停止刷新
        if (sm.data.count<20) {//没有更多数据
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [_mTableView.footer endRefreshingWithNoMoreData];
        }else{
            [_mTableView.footer endRefreshing];//停止加载

        }
        if (sc.isSucceeded) {
            _tijiaowoLoaded = YES;
            if (!_isLoadMore) {//下拉刷新清除数据
                [_tijiaowoArray removeAllObjects];
            }
            [self dataModel:sm.data ToViewModel:_tijiaowoArray];
        }
        [_mTableView reloadData];
        
    }];
}

/**
 *  加载我提交的数据
 */
-(void)loadWoTiJiaoData{
    NSInteger start;
    start = _isLoadMore ? [_wotijiaoArray count] : 0;
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell mySubmitPaperWithCreateid:[AppStore getYongHuID] Papertype:1 Start:(int)start Count:20 createtime:@"" usingCallback:^(DCServiceContext *sc, BaoGaoResultSM *sm) {
        [LDialog closeWaitBox];
        [_mTableView.header endRefreshing];//停止刷新
        [_mTableView.footer endRefreshing];//停止加载

        if (sc.isSucceeded) {
            _wotijiaoLoaded = YES;
            if (!_isLoadMore) {//下拉刷新清除数据
                [_wotijiaoArray removeAllObjects];
            }
            [self dataModel:sm.data ToViewModel:_wotijiaoArray];

        }
        [_mTableView reloadData];

    }];
    
}

/**
 *  数据模型为view模型赋值
 *
 *  @param dataArray 数据模型数组
 */
-(void)dataModel:(NSArray *)dataArray ToViewModel:(NSMutableArray *)vmArray{
    
    for (int i = 0; i < dataArray.count;  i ++) {
        [vmArray addObject:[self cellVMWithmodel:dataArray[i]]];
    }
}

-(BaoGaoTableViewCellVM *)cellVMWithmodel:(BaoGaoListSM *)data{
    
    BaoGaoTableViewCellVM *model1 = [[BaoGaoTableViewCellVM alloc]init];
    model1.title = data.papername;
    model1.isCaogao = NO;
    model1.ID = data.ID;
    model1.isRead = data.isread;
    model1.leixing = data.papertype;
    //时间格式转化 10-10 18:04----》10月10日
    NSString *yue = [data.createtime substringWithRange:NSMakeRange(5, 2)];
    NSString *ri = [data.createtime substringWithRange:NSMakeRange(8, 2)];
    NSString *riqi = [NSString stringWithFormat:@"%@月%@日",yue,ri];
    model1.shijian = [riqi stringByAppendingString:data.weekday];
    return model1;
}

#pragma mark - 加载部门名称排序数据
/**
 *  提交给我按部门排序
 */
-(void)loadtijiaowoBuMenSortData{
    
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell getHaveSubmitPaperToMeDeptWithUserid:[AppStore getYongHuID] Papertype:1 usingCallback:^(DCServiceContext *sc, BaoGaoSortResultSM *sm) {
        [LDialog closeWaitBox];
        [_mTableView.header endRefreshing];
        if(sc.isSucceeded){
            [_bumenArray removeAllObjects];//请求成功移除老数据
            [_bumenDic removeAllObjects];//分组中得数据也全部移除

            for (CompanyDeptsSortSM  *data in sm.data) {
                [_bumenArray addObject:[self dataModeltoHeaderViewModel:data isbumen:YES]];
            }
        }
        [_mTableView reloadData];

    }];
}

/**
 *  提交给我按名称排序
 */
-(void)loadtijiaowoMingChengSortData{
    
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell getHaveSubmitPaperToMeUnameWithUserid:[AppStore getYongHuID] Papertype:1 usingCallback:^(DCServiceContext *sc, BaoGaoSortResultSM *sm) {
        [LDialog closeWaitBox];
        [_mTableView.header endRefreshing];
        if (sc.isSucceeded && sm) {
            [_mingchengArray removeAllObjects];
            [_mingchengDic removeAllObjects];//分组中得数据也全部移除

            for (CompanyDeptsSortSM  *data in sm.data) {
                [_mingchengArray addObject:[self dataModeltoHeaderViewModel:data isbumen:NO]];
            }
        }
        [_mTableView reloadData];

    }];
}

-(BaoGaoHeaderViewModel *)dataModeltoHeaderViewModel:(CompanyDeptsSortSM *)sm isbumen:(BOOL)isbumen{

    BaoGaoHeaderViewModel *model = [[BaoGaoHeaderViewModel alloc]init];
    model.title = sm.name;
    if (isbumen) {
        model.ID = sm.ID;
    }else{
        model.ID = sm.userid;
    }
    model.shuzi = sm.notreadcount;
    model.isZhanKai = NO;
    return model;
}

#pragma mark - 点击分组
-(void)headerClick:(NSNumber *)index{

    if (_currentSortBtn.tag == 100) {//部门
        BaoGaoHeaderViewModel *model = _bumenArray[[index integerValue]];
        
        if(!model.isZhanKai &&(![_bumenDic objectForKey:model.ID])){//展开操作并且没有请求数据
            [self loadribaoWithBumenid:model.ID];//请求数据并布局
            model.isZhanKai = !model.isZhanKai;

        }else{//直接布局
            model.isZhanKai = !model.isZhanKai;

            NSIndexSet *set = [NSIndexSet indexSetWithIndex:[index integerValue]];
            [_mTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        }
    }else{//名称
        
        BaoGaoHeaderViewModel *model = _mingchengArray[[index integerValue]];
        
        if(!model.isZhanKai &&(![_mingchengDic objectForKey:model.ID])){//展开操作并且没有请求数据
            [self loadribaoWithMingChengid:model.ID];//请求数据并布局
            model.isZhanKai = !model.isZhanKai;
            
        }else{//直接布局
            model.isZhanKai = !model.isZhanKai;
            
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:[index integerValue]];
            [_mTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - 加载分组展开数据
/**
 *  加载部门下报告列表
 *
 *  @param bumenid 部门id
 */
-(void)loadribaoWithBumenid:(NSString *)bumenid{
    
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell getSubmitPaperToMeDeptSortWithUserid:[AppStore getYongHuID] Papertype:1 Deptid:bumenid Start:0 Count:20 usingCallback:^(DCServiceContext *sc, BaoGaoResultSM *sm) {
        [LDialog closeWaitBox];
        if(sc.isSucceeded){
            NSMutableArray *shuzu = [@[] mutableCopy];
            for (BaoGaoListSM *baogao in sm.data) {
                [shuzu addObject:[self cellVMWithmodel:baogao]];
            }
            [_bumenDic setObject:shuzu forKey:bumenid];
            [_mTableView reloadData];
        }
    }];
}

/**
 *  名称下报告列表
 *
 *  @param nameid 名称id
 */
-(void)loadribaoWithMingChengid:(NSString *)nameid{
    
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell getSubmitPaperToMeUnameSortWithUserid:[AppStore getYongHuID] Papertype:1 Createid:nameid Start:0 Count:20 usingCallback:^(DCServiceContext *sc, BaoGaoResultSM *sm) {
        [LDialog closeWaitBox];
        if(sc.isSucceeded){
            NSMutableArray *shuzu = [@[] mutableCopy];
            for (BaoGaoListSM *baogao in sm.data) {
                [shuzu addObject:[self cellVMWithmodel:baogao]];
            }
            [_mingchengDic setObject:shuzu forKey:nameid];
            [_mTableView reloadData];
        }
    }];
}

#pragma mark - segment 点击切换
- (void)segmentedControlValueChanged:(UISegmentedControl *)seg{
   
    if (seg.selectedSegmentIndex == 0) {//提交我的
        _isToMe = YES;
        _sortView.hidden = NO;
        if (!_tijiaowoLoaded) {
            [self loadTiJiaoWoData];
        }
    }else{//我提交的
        _isToMe = NO;
        _sortView.hidden = YES;
        if (!_wotijiaoLoaded) {
            [self loadWoTiJiaoData];
        }
    }
    [_mTableView reloadData];
}

#pragma mark - 新建
-(void)xinjianClick:(UIButton *)btn{
 
    [ToolBox showList:@[@"新建日报",@"新建周报",@"新建月报"] images:@[] forAlignment:ListViewAlignmentRight callback:^(int index) {
        XinJianBaoGaoViewController *xinjianVC = [[XinJianBaoGaoViewController alloc]init];
        xinjianVC.leixing = index;
        [self.navigationController pushViewController:xinjianVC animated:YES];
    }];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if(tableView == _mTableView && _isToMe && _currentSortBtn.tag == 100 ){//提交我---部门排序
        return _bumenArray.count;
    }
    if(tableView == _mTableView && _isToMe && _currentSortBtn.tag == 102){//提交我---名称排序
        return _mingchengArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaoGaoTableViewCell *baogaoCell = [BaoGaoTableViewCell cellForTableView:tableView];
    BaoGaoTableViewCellVM *model ;
    if(tableView == _mTableView ){//我提交的

        model = [self getBaoGaoTableViewCellVMWith:indexPath];
        
    }else{//搜索结果
    
        model = _resultArray[indexPath.row];
    }
    baogaoCell.model = model;
    return baogaoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == _mTableView && !_isToMe) {//我提交
        return _wotijiaoArray.count;
    }
    
    if(tableView == _mTableView && _isToMe && _currentSortBtn.tag == 100 ){//提交我---部门排序

        BaoGaoHeaderViewModel * model = _bumenArray[section];
        if (model.isZhanKai) {//展开
            NSArray *arr = [_bumenDic objectForKey:model.ID];
            return arr.count;
        }else{//关闭
            return 0;
        }
    }
    if(tableView == _mTableView && _isToMe && _currentSortBtn.tag == 102){//提交我---名称排序
        BaoGaoHeaderViewModel * model = _mingchengArray[section];
        if (model.isZhanKai) {//展开
            NSArray *arr = [_mingchengDic objectForKey:model.ID];
            return arr.count;
        }else{//关闭
            return 0;
        }
    }
    
    if(tableView == _mTableView && _isToMe){//提交我
        return _tijiaowoArray.count;
    }
    
    if(tableView == _displayController.searchResultsTableView){//搜索
        [_resultArray removeAllObjects];
        for (BaoGaoTableViewCellVM *model in  (_isToMe ? _tijiaowoArray : _wotijiaoArray)) {
            NSRange range = [model.title rangeOfString:_searchBar.text];
            if (range.location != NSNotFound) {
                if(([_currentBtn.titleLabel.text isEqualToString:@"日报"]&& model.leixing == 1)||([_currentBtn.titleLabel.text isEqualToString:@"周报"]&& model.leixing == 2)||([_currentBtn.titleLabel.text isEqualToString:@"月报"]&& model.leixing == 3)){
                    //str符合搜索结果
                    [_resultArray addObject:model];
                }
                
            }
        }
        return [_resultArray count];
    }
    return 0;
  
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _mTableView && _isToMe && _currentSortBtn.tag == 100) {//提交给我的按部门排序
        BaoGaoHeaderView *header = [[BaoGaoHeaderView alloc]init];
        header.target = self;
        header.action = @selector(headerClick:);
        header.index = section;
        header.model = _bumenArray[section];
        return header;
        
    }else if(tableView == _mTableView && _isToMe && _currentSortBtn.tag == 102){//提交给我的按人名排序
        BaoGaoHeaderView *header = [[BaoGaoHeaderView alloc]init];
        header.target = self;
        header.action = @selector(headerClick:);
        header.index = section;
        header.model = _mingchengArray[section];
        return header;

    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (tableView == _mTableView && _isToMe && (_currentSortBtn.tag == 100 || _currentSortBtn.tag == 102)) {//提交给我的按部门排序和按人名排序
        return 50;
    }else{
        return 0.001;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GongZuoBaoGaoXiangQViewController *xiangqingVC = [[GongZuoBaoGaoXiangQViewController alloc]init];
    BaoGaoTableViewCellVM *vm;
    
    if (tableView == _mTableView ) {//提交给我
        if(_isToMe){//提交给我
            vm = [self getBaoGaoTableViewCellVMWith:indexPath];//获取cellViewModel
            if (!vm.isRead ) {//提交给我未读-- 去掉小红点
                vm.isRead = YES;
                //我是为了省流量才这么干的，偷懒可以直接刷新数据
                if(_currentSortBtn.tag == 100){//按部门
                    BaoGaoHeaderViewModel *headerModel = _bumenArray[indexPath.section];
                    headerModel.shuzi  = [NSString stringWithFormat:@"%d",[headerModel.shuzi intValue] - 1];//数字-1;
                    [_bumenArray replaceObjectAtIndex:indexPath.section withObject:headerModel];
                    
                    NSMutableArray *arr = [_bumenDic objectForKey:headerModel.ID];
                    [arr replaceObjectAtIndex:indexPath.row withObject:vm];

                }else if (_currentSortBtn.tag == 101){//时间
                    [_tijiaowoArray replaceObjectAtIndex:indexPath.row withObject:vm];

                }else{//名称
                    BaoGaoHeaderViewModel *headerModel = _mingchengArray[indexPath.section];
                    headerModel.shuzi  = [NSString stringWithFormat:@"%d",[headerModel.shuzi intValue] - 1];//数字-1;
                    [_mingchengArray replaceObjectAtIndex:indexPath.section withObject:headerModel];
                    NSMutableArray *arr = [_mingchengDic objectForKey:headerModel.ID];
                    [arr replaceObjectAtIndex:indexPath.row withObject:vm];
                }
                
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else{
            vm = _wotijiaoArray[indexPath.row];
        }
    }else{//搜索
        vm = _resultArray[indexPath.row];
    }
    xiangqingVC.baogaoId = vm.ID;
    xiangqingVC.leixing = vm.leixing;
    xiangqingVC.isRead = vm.isRead;
    if (_isToMe && !vm.isRead) {//提交给我未读-- 去掉小红点
        vm.isRead = YES;
        [_tijiaowoArray replaceObjectAtIndex:indexPath.row withObject:vm];
        [_mTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

    [self.navigationController pushViewController:xiangqingVC animated:YES];
}

/**
 *  根据_mTableView的indexpath获取cellVM,主要用于cellForRowAtIndexPath:和didSelectRowAtIndexPath:两个方法中
 *
 *  @param indexPath _mTableView indexpath；
 *
 *  @return BaoGaoTableViewCellVM *
 */
-(BaoGaoTableViewCellVM *)getBaoGaoTableViewCellVMWith:(NSIndexPath *)indexPath{
    BaoGaoTableViewCellVM *vm;
    if(_isToMe){//提交给我
        switch (_currentSortBtn.tag) {
            case 100://按部门排序
            {
                BaoGaoHeaderViewModel *model1 = _bumenArray[indexPath.section];
                NSArray *array = [_bumenDic objectForKey:model1.ID];//通过部门id取到报告数组
                vm = array[indexPath.row];
            }
                break;
            case 101://按时间排序
            {
                vm = _tijiaowoArray[indexPath.row];
            }
                break;
            case 102://按名称排序
            {
                BaoGaoHeaderViewModel *model1 = _mingchengArray[indexPath.section];
                NSArray *array = [_mingchengDic objectForKey:model1.ID];//通过部门id取到报告数组
                vm = array[indexPath.row];
            }
                break;
            default:
                break;
        }
    }else{//我提交的
        vm = _wotijiaoArray[indexPath.row];
    }
    return vm;
}

//删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _mTableView && !_isToMe){//我提交
        BaoGaoTableViewCellVM *model = _wotijiaoArray[indexPath.row]; ;
        if (model.isCaogao) {
            return YES;
        }
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_wotijiaoArray removeObjectAtIndex:indexPath.row];
        [_mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    //选择视图，
    int button_w = ScreenWidth / 3;
    int button_h = 40;
    _xuanzeView.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _ribaoBtn.frame = CGRectMake(0, 0, button_w, button_h);
    _zhoubaoBtn.frame = CGRectMake(button_w, 0, button_w, button_h);
    _yuebaoBtn.frame = CGRectMake(button_w * 2, 0, button_w, button_h);
    
    _mTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight );
    _sortView.frame = CGRectMake(0, ScreenHeight - 57, ScreenWidth, 57);
//    _xinJianView.frame  = CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight);
    
    if ([_mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mTableView setLayoutMargins:UIEdgeInsetsZero];
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

#pragma mark - 顶部日报 周报 月报button点击
-(void)btnClick:(UIButton *)sender {
    _currentBtn.selected = NO;
    sender.selected = YES;
    _currentBtn = sender;
    [UIView animateWithDuration:0.2 animations:^{
        _lineLabel.center = CGPointMake(sender.center.x, 39);
        
    }];
    [_displayController.searchResultsTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //默认选中日报
    [self btnClick:_ribaoBtn];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;

}


@end
