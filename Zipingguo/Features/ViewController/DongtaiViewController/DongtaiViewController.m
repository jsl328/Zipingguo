//
//  DongtaiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DongtaiViewController.h"
#import "FabiaoDongtaiViewController.h"
#import "DongtaiModel.h"
#import "DongtaiCellView.h"
#import "EMCDDeviceManager.h"
#import "UIKeyboardCoView.h"
#import "XuanzeRenyuanViewController.h"
#import "LianXiRenXiangQingViewController.h"
@interface DongtaiViewController ()<DongtaiModelDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    SEL Downselector;
    id  targetAction;
    
    UIView *bgView;
    
    int Statr;
    
    int count;
    
    NSMutableArray *quanbuDongtaiArray;
    NSMutableArray *yaoqingWodeArray;
    NSMutableArray *wodeDongtaiArray;
    NSMutableArray *guanzhuDongtaiArray;
    NSMutableArray *shoucangDongtaiArray;
    
    BOOL _isLoadMore;//是否加载更多数据，yes-上拉加载，no-下拉刷新；
    
    NSString *YaoqingRenName;
    
    NSMutableArray *modelArray;
    
    BOOL shuaxin;
    ///下拉选中的是第几个
    int _currentindex;
}
@end

@implementation DongtaiViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    xialaView.hidden = YES;
    [self addXialaTitleViewWithTitle:subTitle selector:@selector(dongtaiTarget) Dianji:NO];
    [bgView removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}

- (void)rightItemClicked{
    
    [pinglunKuang.fabiaoPinglun resignFirstResponder];
    
    FabiaoDongtaiViewController *fabiao = [[FabiaoDongtaiViewController alloc] init];
    fabiao.hidesBottomBarWhenPushed = YES;
    fabiao.passValueFromFabiao = ^(int start){
        [self loadData];
    };
    [self removeNotification];
    [self.navigationController pushViewController:fabiao animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.separatorColor = [UIColor clearColor];
    subTitle = @"全部动态";
    _currentindex = 0;
    count = 10;
    pinglunKuang  = [[PinglunKuangView alloc] init];
    
    pinglunKuang.fabiaoPinglun.delegate = self;
    pinglunKuang.delegate = self;
    [self.view addSubview:pinglunKuang];
    
    [self customBackItemIsHidden:YES];
    [self addItemWithTitle:@"" imageName:@"快捷操作+icon.png" selector:@selector(rightItemClicked) location:NO];
    
    
    quanbuDongtaiArray = [@[] mutableCopy];
    yaoqingWodeArray = [@[] mutableCopy];
    wodeDongtaiArray = [@[] mutableCopy];
    guanzhuDongtaiArray = [@[] mutableCopy];
    shoucangDongtaiArray = [@[] mutableCopy];
    modelArray = [@[] mutableCopy];
    
    isQuanbu = YES;
    _isLoadMore = NO;
    isDongtai = NO;
    isShoucang = NO;
    isYaoqingWode = NO;
    isGuanzhu = NO;
    
    showWaitBox = YES;
    
    [self loadData];
    //下拉刷新
    MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        showWaitBox = YES;
        [self loadData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.header = header;
    
    //上拉加载
    MJYaMiFooter *footer = [MJYaMiFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadData];
    }];
    _tableView.footer = footer;
    
     [self resetDibuViewFrameForKeyboard];
}

- (void)dongtaiTarget{
    
//    if (self.upArrowFlag) {
//        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight)];
//        bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
//        [self.view addSubview:bgView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeXialaView)];
//        [bgView addGestureRecognizer:tap];
//        
//        xialaView = [[DongtaiXialaView alloc] init];
//        float xialaViewWidth = 140.0;
//        float xialaViewHight = 225.0;
//        //    float pandingY = 50;
//        xialaView.frame = CGRectMake((ScreenWidth-xialaViewWidth)/2.0, 0, xialaViewWidth, xialaViewHight);
//        xialaView.delegate = self;
//        [bgView addSubview:xialaView];
//    }else{
//        [bgView removeFromSuperview];
//    }
//

    
    NSArray *titleArray = @[@"全部动态",@"@我的动态",@"我的关注",@"我的动态",@"我的收藏"];
    [ToolBox showList:titleArray selectedIndex:_currentindex forAlignment:ListViewAlignmentCenter callback:^(int index) {
        _currentindex = index;
        [self addXialaTitleViewWithTitle:titleArray[index] selector:@selector(dongtaiTarget) Dianji:self.upArrowFlag];
        
        switch (index) {
            case 0://全部动态
            {
                [self quanbuDongtaiFangfa];

            }
                break;
            case 1://我的动态
            {
                [self yaoQingWodeDongtaiFangfa];

            }
                break;
            case 2://我的关注
            {
                [self wodeGuanzhuFangfa];

            }
                break;
            case 3://我的动态
            {
                [self wodeDongtaiFangfa];

            }
                break;
            case 4://我的收藏
            {
                [self woshoucangdeFangfa];

            }
                break;
                
            default:
                break;
        }
        

    }];
    
    
    
    
//    [self addXialaTitleViewWithTitle:subTitle selector:@selector(dongtaiTarget) Dianji:self.upArrowFlag];
    
//    [self panduanType];
}

- (void)removeXialaView{
    [self dongtaiTarget];
}

- (void)dongtaiWithTitle:(NSString *)Title isQuanbuDongTai:(BOOL)quanbudongtai isYaoqingWoDeDongTai:(BOOL)yaoqingwodedongtai isGuanZhuDongTai:(BOOL)guanzhudongtai isWodeDongTai:(BOOL)wodedongtai isShouCangDongTai:(BOOL)shoucangdongtai UparrowFlay:(BOOL)uparrowFlay{
    
    isShoucang=shoucangdongtai;
    isQuanbu = quanbudongtai;
    isGuanzhu = guanzhudongtai;
    isYaoqingWode = yaoqingwodedongtai;
    isDongtai = wodedongtai;
    
    subTitle = Title;
    [self addXialaTitleViewWithTitle:Title selector:@selector(dongtaiTarget) Dianji:uparrowFlay];
}
- (void)panduanType{
    
    if (isYaoqingWode) {
        xialaView.yaoqingwodedongtaiButton.selected = YES;
    }else if (isGuanzhu){
        xialaView.wodeguanzhuButton.selected = YES;
    }else if (isDongtai){
        xialaView.wodedongtaiButton.selected = YES;
    }else if(isQuanbu){
        xialaView.quanbudongtaiButton.selected = YES;
    }else if(isShoucang){
        xialaView.woshoucangdeButton.selected = YES;
    }
}

- (void)quanbuDongtaiFangfa{
//    [bgView removeFromSuperview];
    
    typeTitle = @"全部动态";
    [self dongtaiWithTitle:typeTitle isQuanbuDongTai:YES isYaoqingWoDeDongTai:NO isGuanZhuDongTai:NO isWodeDongTai:NO isShouCangDongTai:NO UparrowFlay:self.upArrowFlag];
    
    if (Quanbu) {
        Quanbu = NO;
        if ((int)[self fanhuiCount] < 10) {
            count = 10;
        }else{
            count = (int)[self fanhuiCount];
        }
        [self LoadListBoxData:1];
    }else{
        if (quanbuDongtaiArray.count == 0) {
            [self LoadListBoxData:1];
        }
        [_tableView reloadData];
    }
    
}

- (void)yaoQingWodeDongtaiFangfa{
//    [bgView removeFromSuperview];
    
    typeTitle = @"@我的动态";
    
    [self dongtaiWithTitle:typeTitle isQuanbuDongTai:NO isYaoqingWoDeDongTai:YES isGuanZhuDongTai:NO isWodeDongTai:NO isShouCangDongTai:NO UparrowFlay:self.upArrowFlag];
    
    if (YaoqingWode) {
        YaoqingWode = NO;
        if ((int)[self fanhuiCount] < 10) {
            count = 10;
        }else{
            count = (int)[self fanhuiCount];
        }
        [self LoadListBoxData:2];
    }else{
        if (yaoqingWodeArray.count == 0) {
            [self LoadListBoxData:2];
        }
        [_tableView reloadData];
    }
}

- (void)wodeGuanzhuFangfa{
//    [bgView removeFromSuperview];
    
    typeTitle = @"我的关注";
    
    [self dongtaiWithTitle:typeTitle isQuanbuDongTai:NO isYaoqingWoDeDongTai:NO isGuanZhuDongTai:YES isWodeDongTai:NO isShouCangDongTai:NO UparrowFlay:self.upArrowFlag];
    
    if (Guanzhu) {
        Guanzhu = NO;
        if ((int)[self fanhuiCount] < 10) {
            count = 10;
        }else{
            count = (int)[self fanhuiCount];
        }
        [self LoadListBoxData:3];
    }else{
        if (guanzhuDongtaiArray.count == 0) {
            [self LoadListBoxData:3];
        }
        [_tableView reloadData];
    }
}

- (void)wodeDongtaiFangfa{
//    [bgView removeFromSuperview];
    typeTitle = @"我的动态";
   [self dongtaiWithTitle:typeTitle isQuanbuDongTai:NO isYaoqingWoDeDongTai:NO isGuanZhuDongTai:NO isWodeDongTai:YES isShouCangDongTai:NO UparrowFlay:self.upArrowFlag];
    
    if (Dongtai) {
        Dongtai = NO;
        if ((int)[self fanhuiCount] < 10) {
            count = 10;
        }else{
            count = (int)[self fanhuiCount];
        }
        [self LoadListBoxData:5];
    }else{
        if (wodeDongtaiArray.count == 0) {
            [self LoadListBoxData:5];
        }
        [_tableView reloadData];
    }
}

- (void)woshoucangdeFangfa{
//    [bgView removeFromSuperview];
    
    typeTitle = @"我的收藏";
    [self dongtaiWithTitle:typeTitle isQuanbuDongTai:NO isYaoqingWoDeDongTai:NO isGuanZhuDongTai:NO isWodeDongTai:NO isShouCangDongTai:YES UparrowFlay:self.upArrowFlag];
    
    if (Shoucang) {
        Shoucang = NO;
        if ((int)[self fanhuiCount] < 10) {
            count = 10;
        }else{
            count = (int)[self fanhuiCount];
        }
        [self LoadListBoxData:4];
    }else{
        if (shoucangDongtaiArray.count == 0) {
            [self LoadListBoxData:4];
        }
        [_tableView reloadData];
    }
}

- (void)loadData{
    if(isQuanbu){//
        [self LoadListBoxData:1];//默认加载全部动态
        
    }else if(isYaoqingWode){
        
        [self LoadListBoxData:2];;//@我的动态
    }else if(isGuanzhu){
        
        [self LoadListBoxData:3];;//我的关注动态
    }else if(isShoucang){
        
        [self LoadListBoxData:4];;//我收藏的动态
    }else if(isDongtai){
        
        [self LoadListBoxData:5];;//我的动态
    }
}

#pragma mark -
#pragma mark 加载数据

- (void)LoadListBoxData:(int)Type{
    NSInteger start;
    if (Type == 1) {
        start = _isLoadMore ? [quanbuDongtaiArray count] : 0;
    }else if (Type == 2){
        start = _isLoadMore ? [yaoqingWodeArray count] : 0;
    }else if (Type == 3){
        start = _isLoadMore ? [guanzhuDongtaiArray count] : 0;
    }else if (Type == 4){
        start = _isLoadMore ? [shoucangDongtaiArray count] : 0;
    }else if (Type == 5){
        start = _isLoadMore ? [wodeDongtaiArray count] : 0;
    }
    
    if (start == 0 && showWaitBox) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    //动态列表
    [ServiceShell getDynamicWithstart:(int)start Count:count companyid:[AppStore getGongsiID] Createid:[AppStore getYongHuID] Groupid:@"" Type:Type usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfDynamicSM *dynamicSM) {
        [LDialog closeWaitBox];
        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        if (dynamicSM.status == 0) {
            [_tableView.header endRefreshing];//停止刷新
            [_tableView.footer endRefreshing];
            
            if (Type == 1) {
                if (!_isLoadMore) {//下拉刷新清除数据
                    [quanbuDongtaiArray removeAllObjects];
                }
            }else if(Type == 2){
                if (!_isLoadMore) {//下拉刷新清除数据
                    [yaoqingWodeArray removeAllObjects];
                }
            }else if(Type == 3){
                if (!_isLoadMore) {//下拉刷新清除数据
                    [guanzhuDongtaiArray removeAllObjects];
                }
            }else if(Type == 4){
                if (!_isLoadMore) {//下拉刷新清除数据
                    [shoucangDongtaiArray removeAllObjects];
                }
            }else if(Type == 5){
                if (!_isLoadMore) {//下拉刷新清除数据
                    [wodeDongtaiArray removeAllObjects];
                }
            }
            if (_isLoadMore) {
                if (dynamicSM.data.count < count) {
                    [_tableView.footer endRefreshingWithNoMoreData];
                }
            }
            [self dataModel:dynamicSM.data isType:Type];
            
        }
        
    }];
}

-(void)dataModel:(NSArray *)dataArray isType:(int)type{
    for (int i = 0; i < dataArray.count;  i ++) {
        DongtaiModel *model = [[DongtaiModel alloc] init];
        model.dynamicSM = dataArray[i];
        model.height = [self calculateSizeOfModelHeightWithVM:dataArray[i]];
        if (type == 1) {
            [quanbuDongtaiArray addObject:model];
        }else if (type == 2){
            [yaoqingWodeArray addObject:model];
        }else if (type == 3){
            [guanzhuDongtaiArray addObject:model];
        }else if (type == 4){
            [shoucangDongtaiArray addObject:model];
        }else if (type == 5){
            [wodeDongtaiArray addObject:model];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DongtaiModel *model = [self fanhuiModelWithIndexPath:indexPath];
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    
    if ([pinglunKuang.fabiaoPinglun isFirstResponder]) {
        
        [pinglunKuang.fabiaoPinglun resignFirstResponder];
        pinglunKuang.fabiaoPinglun.text = @"";
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /// tableView 点击cell方法
    DongtaiXiangqingViewController *xiangqing = [[DongtaiXiangqingViewController alloc] init];
    DongtaiModel *model = [self fanhuiModelWithIndexPath:indexPath];
    xiangqing.hidesBottomBarWhenPushed = YES;
    
    xiangqing.dongtaiId = model.dynamicSM.dynamic._id;
    xiangqing.passValueFromxiangqing = ^(AllDynamicSM *sm,int start){
        if (start == 1) {
            
            [self shuxinShuju];
            
            model.dynamicSM = sm;
            model.height = [self calculateSizeOfModelHeightWithVM:sm];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(start == 2){
            [self shuxinShuju];
            if ((int)[self fanhuiCount] < 10) {
                count = 10;
            }else{
                count = (int)[self fanhuiCount];
            }
            [self loadData];
        }else if (start == 3){
            
            [self shuxinShuju];
            
            if (isQuanbu) {
                [quanbuDongtaiArray removeObjectAtIndex:indexPath.row];
                
            }else if (isYaoqingWode){
                [yaoqingWodeArray removeObjectAtIndex:indexPath.row];
                
            }else if (isGuanzhu){
                [guanzhuDongtaiArray removeObjectAtIndex:indexPath.row];
            }else if (isShoucang){
                [shoucangDongtaiArray removeObjectAtIndex:indexPath.row];
                
            }else if (isDongtai){
                
                [wodeDongtaiArray removeObjectAtIndex:indexPath.row];
            }
            [_tableView reloadData];
        }
    };
    [self.navigationController pushViewController:xiangqing animated:YES];
}


#pragma mark - table View DataSource
//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self fanhuiCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DongtaiCellView *dongtaiCell = [DongtaiCellView cellForTableView:tableView];
    DongtaiModel *model = [self fanhuiModelWithIndexPath:indexPath];
    
    model.indexPath = indexPath;
    dongtaiCell.model = model;
    model.delegate = self;
    return dongtaiCell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    pinglunKuang.frame = CGRectMake(0, ScreenHeight-NavHeight, ScreenWidth, 49);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 动态Model代理
#pragma mark 关注方法
- (void)guanzhuFangfa:(NSString *)createid{
    [ServiceShell getAttentionWithCreateid:[AppStore getYongHuID] Relid:createid usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
        if (serviceContext.isSucceeded) {
            if (model.status == 0) {
                [self shuxinShuju];
                if ((int)[self fanhuiCount] < 10) {
                    count = 10;
                }else{
                    count = (int)[self fanhuiCount];
                }
                [self loadData];
            }
        }
    }];
}

#pragma mark 取消关注
- (void)quxiaoguanzhuFangfa:(NSString *)createid{
    [ServiceShell getCancelAttentionWithCreateid:[AppStore getYongHuID] Relid:createid usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
        if (serviceContext.isSucceeded) {
            if (model.status == 0) {
                [self shuxinShuju];
                if ((int)[self fanhuiCount] < 10) {
                    count = 10;
                }else{
                    count = (int)[self fanhuiCount];
                }
                [self loadData];
            }
        }
    }];
}

#pragma mark 赞
- (void)zanFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel{
    [ServiceShell getDypraiseDynamicWithDynamicid:dynamicid Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfDynamicSM *sm) {
        if (serviceContext.isSucceeded) {
            if (sm.status == 0) {
                [self shuxinShuju];
                DongtaiModel *model = [self fanhuiModelWithIndexPath:dtModel.indexPath];
                model.dynamicSM = sm.dynamicSM;
                model.height = [self calculateSizeOfModelHeightWithVM:sm.dynamicSM];
                [_tableView reloadRowsAtIndexPaths:@[dtModel.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }];
}

#pragma mark 取消赞
- (void)quxiaoZanFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel{
    [ServiceShell getDypraiseDynamicWithCancelPraiseDynamicid:dynamicid Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfDynamicSM *sm) {
        if (serviceContext.isSucceeded) {
            if (sm.status == 0) {
                [self shuxinShuju];
                DongtaiModel *model = [self fanhuiModelWithIndexPath:dtModel.indexPath];
                model.dynamicSM = sm.dynamicSM;
                model.height = [self calculateSizeOfModelHeightWithVM:sm.dynamicSM];
                [_tableView reloadRowsAtIndexPaths:@[dtModel.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }];
}

#pragma mark 评论方法
- (void)pinglunFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel{
    dongtaiModel = dtModel;
    pinglunKuang.fabiaoPinglun.placeholder = @"说点什么吧...";
    [pinglunKuang.fabiaoPinglun becomeFirstResponder];
    pinglunKuang.Isreply = @"0";
    pinglunKuang.Topparid = @"0";
    pinglunKuang.ID = dynamicid;
}

#pragma mark 删除方法
- (void)shanchuFangfa:(NSString *)dynamicid DongtaiModel:(DongtaiModel *)dtModel{
    [ServiceShell getDelMyDynamicWithID:dynamicid Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
        if (serviceContext.isSucceeded) {
            if (model.status == 0) {
                if (isQuanbu) {
                    [quanbuDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
                    
                }else if (isYaoqingWode){
                    [yaoqingWodeArray removeObjectAtIndex:dtModel.indexPath.row];
                    
                }else if (isGuanzhu){
                    [guanzhuDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
                }else if (isShoucang){
                    [shoucangDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
                    
                }else if (isDongtai){
                    
                    [wodeDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
                }
                [_tableView reloadData];
            }
            
        }
    }];
}

#pragma mark 布局位置
- (float)calculateSizeOfModelHeightWithVM:(AllDynamicSM*)sm
{
    //加上赞和评论数量的图标的高度30
    float height = 100+30-13;
    NSUInteger yuyinCount = sm.dysounds.count;
    NSUInteger tuPianCount = sm.dyimgs.count;
    NSUInteger zanCount =  sm.dypraises.count;
    NSUInteger pinglunCount =  sm.dycomments.count;
    //内容的高度
    float contenHeight = 0;
    if(sm.dynamic.content.length>0){
        CGSize contentSize = [sm.dynamic.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-85,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        contenHeight += contentSize.height+5;
    }
    height += contenHeight;
    
    //评论的高度
    
    float pingLunHeight = 0;
    
    for (int i = 0; i < sm.dycomments.count; i++) {
        DycommentsSM *SM = [sm.dycomments objectAtIndex:i];
        if (i < 3) {
            NSString *content;
            if ([SM.isreply isEqualToString:@"0"]) {
                content = [NSString stringWithFormat:@"%@: %@",SM.createname,SM.content];
            }else{
                content = [NSString stringWithFormat:@"%@回复%@: %@",SM.createname,SM.relusername,SM.content];
            }
           CGSize size1  = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth-2*15-52, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
           pingLunHeight += size1.height+10;
        }
        if (i == 3) {
            pingLunHeight += 30;
        }
        
    }

    height += pingLunHeight;
    //点赞
    float dianZanHeight = 0;
    // (只要有赞默认高度为40)(由于加上赞和评论数量的图标的高度默认是22 ，可是现在用的是30，所以dianzanheight少了5像素。3个像素是缓冲区)
    if(zanCount!=0){
        dianZanHeight = 40;
    }
    height += dianZanHeight;
    //语音的高度
    float yuyinHeight = 0;
    //有语音的话要加5个像素点
    if(yuyinCount !=0)
    {
        yuyinHeight += (yuyinCount*26+(yuyinCount-1)*5+5);
    }
    height += yuyinHeight;
    //图片
    float tupianHeight = 0;
    //图片默认高度为52（因为x/3 x小于3的话 值为0)
    if(tuPianCount!=0)
    {
        //换行
        if(tuPianCount/3>0 && tuPianCount%3>0){
            tupianHeight += (tuPianCount/3)*(ScreenWidth-85-10)/3.0+(ScreenWidth-85-10)/3.0+5;
            tupianHeight += (tuPianCount/3)*3+1;
        }
        //刚好是3的倍数
        else if (tuPianCount/3>0)
        {
            tupianHeight += (tuPianCount/3)*(ScreenWidth-85-10)/3.0+5;
            tupianHeight += ((tuPianCount/3)-1)*3;
        }
        else
        {
            tupianHeight += (ScreenWidth-85-10)/3.0+5;
        }
    }
    height += tupianHeight;

    return height;
}

#pragma mark 模型代理
- (void)pengYouQuanCellView:(NSArray *)tupianArray1 DidSelectedWithIndex:(int)index{
    NSLog(@"------%d",index);
    
    [self.messageReadManager showBrowserWithImages:tupianArray1];
    [self.messageReadManager showImageWithIndex:index];
    
}

#pragma mark 播放语音
- (void)bofangYuyin:(YuyinView *)yuyinUrl{
    NSArray *arr = [yuyinUrl.soundurl componentsSeparatedByString:@"."];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *path=[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"Downloaded/"];
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",DCMD5ForString(yuyinUrl.soundurl),[arr lastObject]]];
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:pathName completion:^(NSError *error) {
        [yuyinUrl.yinliangImageView stopAnimating];
        NSLog(@"%@",error);
    }];
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
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
            pinglunKuang.frame = CGRectMake(0, beginRect.origin.y-49, ScreenWidth, 49);
        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            pinglunKuang.frame = CGRectMake(0, endRect.origin.y-49, ScreenWidth, 49);
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

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]) {
        [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        pinglunKuang.fasongBtn.userInteractionEnabled = YES;
    }else{
        [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
        pinglunKuang.fasongBtn.userInteractionEnabled = NO;
    }
}

#pragma mark 回复方法
- (void)huofuPinglun:(DongtaiPinglunCellVM *)pinglunCellVM DongtaiModel:(DongtaiModel *)dtModel{
    dongtaiModel = dtModel;
    if ([pinglunCellVM.model.createid isEqualToString:[AppStore getYongHuID]]) {
        delPinglunid = pinglunCellVM.model._id;
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        
        action.actionSheetStyle =UIActionSheetStyleDefault;
        [action showInView:self.view];
        
    }else{
        if ([pinglunKuang.fabiaoPinglun isFirstResponder]) {
            
            [pinglunKuang.fabiaoPinglun resignFirstResponder];
            return;
        }
        
        pinglunKuang.fabiaoPinglun.placeholder = [NSString stringWithFormat:@"回复%@",pinglunCellVM.model.createname];
        [pinglunKuang.fabiaoPinglun becomeFirstResponder];
        pinglunKuang.Topparid = pinglunCellVM.model.topparid;
        pinglunKuang.Isreply = pinglunCellVM.model._id;
        pinglunKuang.ID = pinglunCellVM.model.dynamicid;
    }
}

#pragma mark 评论方法
- (void)fasongFangfaWithDongtaiID:(NSString *)dongtaiID Isreply:(NSString *)isreply Topparid:(NSString *)topparid{
    NSString *ids;
    if (atusers.count != 0) {
        ids = [atusers componentsJoinedByString:@","];
    }else{
        ids = @"";
    }
    
        [ServiceShell getDycommentDynamicWithCreateid:[AppStore getYongHuID] Content:pinglunKuang.fabiaoPinglun.text Dynamicid:dongtaiID Isreply:isreply Topparid:topparid IDS:ids usingCallback:^(DCServiceContext *serviceContext, ResultMode *sm) {
        if (serviceContext.isSucceeded) {
            if (sm.status == 0) {
                [self shuxinShuju];
                if ((int)[self fanhuiCount] < 10) {
                    count = 10;
                }else{
                    count = (int)[self fanhuiCount];
                }
                [self loadData];
                
                [pinglunKuang.fabiaoPinglun resignFirstResponder];
                pinglunKuang.fabiaoPinglun.text = @"";
                pinglunKuang.fabiaoPinglun.placeholder = @"说点什么吧...";
                [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
                pinglunKuang.fasongBtn.userInteractionEnabled = NO;
            }
            
        }
    }];
    
}

#pragma @人员数据
- (void)RenyuanShuju:(NSNotification *)not{
    [self removeNotification];
    [atusers removeAllObjects];
    [pinglunKuang.fabiaoPinglun becomeFirstResponder];
    NSMutableArray *array = [@[] mutableCopy];
    atusers = [@[] mutableCopy];
    NSDictionary *dict = [not userInfo];
    modelArray = [dict objectForKey:@"xuanzhongArray"];
    for (XuanzeRenyuanModel *model in [dict objectForKey:@"xuanzhongArray"]) {
        [array addObject:model.personsSM.name];
        [atusers addObject:model.personsSM.userid];
    }
    
    if (array.count != 0) {
        NSString *wenzi =  [pinglunKuang.fabiaoPinglun.text substringFromIndex:YaoqingRenName.length];
        
        YaoqingRenName = [NSString stringWithFormat:@"@%@ ",[array componentsJoinedByString:@" @"]];
        pinglunKuang.fabiaoPinglun.text = [YaoqingRenName stringByAppendingString:wenzi];
        
        [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        pinglunKuang.fasongBtn.userInteractionEnabled = YES;
    }
}

#pragma mark 邀请人员
- (void)yaoqingRenyuanFangfa{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
    
    XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
    xuanze.hidesBottomBarWhenPushed = YES;
    xuanze.xuanzhongArray = modelArray;
    xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
    [self presentViewController:nav animated:YES completion:nil];


}

#pragma mark 看看更多点进详情
- (void)jinXiangqingWithAllDynamicSM:(AllDynamicSM *)dynamic DongtaiModel:(DongtaiModel *)dtModel{
    DongtaiXiangqingViewController *xiangqing = [[DongtaiXiangqingViewController alloc] init];
    xiangqing.dongtaiId = dynamic.dynamic._id;
    xiangqing.dynamicSM = dynamic;
    xiangqing.passValueFromxiangqing = ^(AllDynamicSM *sm,int start){
        if (start == 1) {
            dtModel.dynamicSM = sm;
            dtModel.height = [self calculateSizeOfModelHeightWithVM:sm];
            [_tableView reloadRowsAtIndexPaths:@[dtModel.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(start == 2){
            [self loadData];
        }else if (start == 3){
            if (isQuanbu) {
                [quanbuDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
                
            }else if (isYaoqingWode){
                [yaoqingWodeArray removeObjectAtIndex:dtModel.indexPath.row];
                
            }else if (isGuanzhu){
                [guanzhuDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
            }else if (isShoucang){
                [shoucangDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
                
            }else if (isDongtai){
                
                [wodeDongtaiArray removeObjectAtIndex:dtModel.indexPath.row];
            }
            [_tableView reloadData];
        }
    };
    xiangqing.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xiangqing animated:YES];
}

- (void)tiaozhuanGerenxinxi:(NSString *)userid{
    LianXiRenXiangQingViewController *xinxi = [[LianXiRenXiangQingViewController alloc] init];
    xinxi.ID = userid;
    xinxi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xinxi animated:YES];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([textView.text quKongGe].length == 0) {//去掉空格回车后的字符串
            textView.text = @"";
            return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }else{
            NSLog(@"发送");
            [self fasongFangfaWithDongtaiID:pinglunKuang.ID Isreply:pinglunKuang.Isreply Topparid:pinglunKuang.Topparid];
            return NO;
        }
    }
    return YES;
}

#pragma mark 返回model
- (DongtaiModel *)fanhuiModelWithIndexPath:(NSIndexPath *)indexPath{
    DongtaiModel *model;
    if (isQuanbu) {
        model = quanbuDongtaiArray[indexPath.row];
        
    }else if (isYaoqingWode){
        model = yaoqingWodeArray[indexPath.row];
        
    }else if (isGuanzhu){
        model = guanzhuDongtaiArray[indexPath.row];
        
    }else if (isShoucang){
        model = shoucangDongtaiArray[indexPath.row];
        
    }else if (isDongtai){
        model = wodeDongtaiArray[indexPath.row];
        
    }
    return model;
}

#pragma mark 返回count
- (NSInteger)fanhuiCount{
    if (isQuanbu) {
        return quanbuDongtaiArray.count;
        
    }else if (isYaoqingWode){
        return yaoqingWodeArray.count;
        
    }else if (isGuanzhu){
        return guanzhuDongtaiArray.count;
    }else if (isShoucang){
        return shoucangDongtaiArray.count;
        
    }else if (isDongtai){
        
        return wodeDongtaiArray.count;
    }
    return 0;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"ff");
        [ServiceShell DydelWithCreateid:[AppStore getYongHuID] ID:delPinglunid Dynamicid:dongtaiModel.dynamicSM.dynamic._id usingCallback:^(DCServiceContext *serviceContext, ResultMode *sm) {
            if (sm.status == 0) {
                
                [self shuxinShuju];
                
                DongtaiModel *model = [self fanhuiModelWithIndexPath:dongtaiModel.indexPath];
                model.dynamicSM = sm.delData1;
                model.height = [self calculateSizeOfModelHeightWithVM:sm.delData1];
                [_tableView reloadRowsAtIndexPaths:@[dongtaiModel.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1.5f];
            }
        }];
        
    }
}

- (void)shuxinShuju{
    if (isQuanbu) {
        [self ShuxinShujuISQuanbuDongTai:NO isYaoqingWoDeDongTai:YES isGuanZhuDongTai:YES isWodeDongTai:YES isShouCangDongTai:YES];
    }else if (isYaoqingWode){
        [self ShuxinShujuISQuanbuDongTai:YES isYaoqingWoDeDongTai:NO isGuanZhuDongTai:YES isWodeDongTai:YES isShouCangDongTai:YES];
    }else if (isGuanzhu){
        [self ShuxinShujuISQuanbuDongTai:YES isYaoqingWoDeDongTai:YES isGuanZhuDongTai:NO isWodeDongTai:YES isShouCangDongTai:YES];
    }else if (isDongtai){
        [self ShuxinShujuISQuanbuDongTai:YES isYaoqingWoDeDongTai:YES isGuanZhuDongTai:YES isWodeDongTai:NO isShouCangDongTai:YES];
    }else if (Shoucang){
        [self ShuxinShujuISQuanbuDongTai:YES isYaoqingWoDeDongTai:YES isGuanZhuDongTai:YES isWodeDongTai:YES isShouCangDongTai:NO];
    }
}

- (void)ShuxinShujuISQuanbuDongTai:(BOOL)quanbudongtai isYaoqingWoDeDongTai:(BOOL)yaoqingwodedongtai isGuanZhuDongTai:(BOOL)guanzhudongtai isWodeDongTai:(BOOL)wodedongtai isShouCangDongTai:(BOOL)shoucangdongtai{
    Quanbu = quanbudongtai;
    YaoqingWode = yaoqingwodedongtai;
    Dongtai = wodedongtai;
    Guanzhu = guanzhudongtai;
    Shoucang = shoucangdongtai;
    showWaitBox = NO;
    _isLoadMore = NO;
    
}

- (void)aaAllDynamicSM:(AllDynamicSM *)dynamicSM{
    for (int i = 0; i < quanbuDongtaiArray.count; i++) {
        DongtaiModel *dyModel = [quanbuDongtaiArray objectAtIndex:i];
        if ([dyModel.dynamicSM.dynamic._id isEqualToString:dynamicSM.dynamic._id]) {
            DongtaiModel *model = [self fanhuiModelWithIndexPath:dyModel.indexPath];
            model.dynamicSM = dynamicSM;
            model.height = [self calculateSizeOfModelHeightWithVM:dynamicSM];
            [quanbuDongtaiArray replaceObjectAtIndex:i withObject:model];
        }
    }
}

@end
