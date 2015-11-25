//
//  TongxunluViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TongxunluViewController.h"
#import "FenzuModel.h"
#import "FenzuViewCell.h"
#import "TongxunluModel.h"
#import "TongxunluViewCell.h"
#import "LianXiRenXiangQingViewController.h"
#import "ChatViewController.h"

@interface TongxunluViewController ()<TongxunluModelDelegate>
{
    //原始数据源
    NSMutableArray *_dataArray;
    NSMutableArray *_allDataArray;
    ///
    //用于存放搜索结果
    NSMutableArray *_resultArray;
    
    //搜索条(普通视图控件)
    UISearchBar  *_searchBar;
    //搜索控制器(用于开启搜索模式，并呈现搜索结果)
    UISearchDisplayController *_displayController;
    
    BOOL fenzu;
    BOOL quanbu;
    
    NSMutableArray *yonghuArray;
    
    NSMutableArray *letterArray;
    
    NSMutableArray *fenzuArray;
    
    int Start;
    int Count;
    int beishu;
    
}
@end

@implementation TongxunluViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = RGBACOLOR(53, 55, 68, 1);
    
    
    _dataArray = [@[] mutableCopy];
    _allDataArray = [@[] mutableCopy];
    _resultArray = [@[] mutableCopy];
    letterArray = [@[] mutableCopy];
    yonghuArray = [@[] mutableCopy];
    fenzuArray = [@[] mutableCopy];
    
    //分组
    fenzuArray = [FenzuStores getAllWithGongsiID:[AppStore getGongsiID] Parid:@"0"];
    //通讯录
    yonghuArray = [YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
    
    // Do any additional setup after loading the view from its nib.
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _tableView.tableHeaderView = _searchBar;
    _searchBar.placeholder = @"请输入搜索关键词";
    _searchBar.delegate = self;
    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //为搜索控制器中tableView设置数据源和代理
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
    
    [self addSegmentedControlWithLeftTitle:@"分组" RightTitle:@"全部" selector:@selector(segmentedControlValueChanged:)];
     [self customBackItemIsHidden:YES];
    
    if ([NetWork isConnectionAvailable]) {
        [self fenzuData];
    }else{
        [self fenzuShuju];
    }
    
    //下拉刷新
    MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        if (quanbu) {
            Start = 0;
            beishu = 0;
            Count = 200;
            [YonghuStores deleteDataInGongSiTongXunLuDataBase];
        }
        [self loadData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.header = header;
    
}

#pragma mark - 切换seg

- (void)segmentedControlValueChanged:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex == 0) {
        if (_dataArray.count == 0) {
            [self loadData];
        }else{
            fenzu = YES;
            quanbu = NO;
            [_tableView reloadData];
        }
    }else{
        fenzu = NO;
        quanbu = YES;
        if (_allDataArray.count == 0) {
            if (yonghuArray.count == 0) {
                Start = 0;
                beishu = 0;
                Count = 200;
                [YonghuStores deleteDataInGongSiTongXunLuDataBase];
                [self loadData];
            }else{
                
                [self xiugaishuju];
            }
        }else{
            
            [_tableView reloadData];
        }
    }
}

-(void)loadData{
    if (fenzu) {
        [self fenzuData];
    }else if(quanbu){
        [self quanbuData];
    }
}


- (void)xiugaishuju{
    
    [self yonghuShuju];
    //解档
    NSString *time = [ToolBox jiedangCompanyid:[AppStore getGongsiID]];
    UpdateCompanyPersonsSM *personSM = [[UpdateCompanyPersonsSM alloc] init];
    personSM.companyid = [AppStore getGongsiID];
    personSM.updatedtime = time;
    NSMutableArray *userid = [@[] mutableCopy];
    for (YonghuInfoDB *db in yonghuArray) {
        [userid addObject:db.userid];
    }
    personSM.userid = [userid componentsJoinedByString:@","];
    [ServiceShell getcheckUpdateCompanyPersonsWithUpdateCompanyPersonsSM:personSM Priorityyouxianji:YES usingCallback:^(DCServiceContext *serviceContext, ResultModelOfcheckUpdateCompanyPersonsSM *sm) {
        if (serviceContext.isSucceeded && sm.status == 0) {
            //归档
            [ToolBox chuliTime:sm.data2 isArchive:YES companyid:[AppStore getGongsiID]];
            for (CheckUpdateCompanyPersonsSM *checkUpdate in sm.data) {
                NSMutableArray *yonghuShuzu = [@[] mutableCopy];
                for (YonghuInfoDB *db in yonghuArray) {
                    [yonghuShuzu addObject:db.userid];
                }
                
                if ([yonghuShuzu containsObject:checkUpdate.userid]) {
                    [YonghuStores updataWithName:checkUpdate.name Letter:checkUpdate.letter Deptid:checkUpdate.deptid Phone:checkUpdate.phone Imgurl:checkUpdate.imgurl Deptname:checkUpdate.deptname zhiwei:checkUpdate.position ID:checkUpdate.userid];
                    
                }else{
                    if (checkUpdate.userid.length >= 20) {
                        [YonghuStores InsertWithUserid:[self panDuanIsNull:checkUpdate.userid] Name:[self panDuanIsNull:checkUpdate.name] Letter:[self panDuanIsNull:checkUpdate.letter] Email:[self panDuanIsNull:checkUpdate.email] Phone:[self panDuanIsNull:checkUpdate.phone] Wechat:[self panDuanIsNull:checkUpdate.wechat] QQ:[self panDuanIsNull:checkUpdate.qq] Birthday:[self panDuanIsNull:@""] Hobby:[self panDuanIsNull:@""] Imgurl:[self panDuanIsNull:checkUpdate.imgurl] Companyid:[AppStore getGongsiID] Position:[self panDuanIsNull:checkUpdate.position] Jobnumber:[self panDuanIsNull:checkUpdate.jobnumber] Deptid:[self panDuanIsNull:checkUpdate.deptid] Deptname:[self panDuanIsNull:checkUpdate.deptname]];
                    }
                    
                }

            }
            
            if (sm.data1.count != 0) {
                for (NSString *DelUserid in sm.data1) {
                    [YonghuStores DeleteWithID:DelUserid];
                }
            }
            [self yonghuShuju];
        }else{
            [self yonghuShuju];
        }
    }];
}

#pragma mark - 用户数据
- (void)yonghuShuju{
    fenzu = NO;
    quanbu = YES;
    [_allDataArray removeAllObjects];
    yonghuArray = [YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
    for (int i = 0; i <= 26; i++) {
        NSString *Letter;
        if (i < 26) {
            Letter = [NSString stringWithFormat:@"%c",i+65];
        }else{
            Letter = @"#";
        }
        NSMutableArray *array = [@[] mutableCopy];
        for (YonghuInfoDB *db in yonghuArray) {
            
            NSString *letter = [db.letter uppercaseString];
            if ([letter isEqualToString:Letter]) {
                if (![letterArray containsObject:letter]) {
                    [letterArray addObject:letter];
                }
                TongxunluModel *model = [[TongxunluModel alloc] init];
                model.personsSM = db;
                
                [array addObject:model];
            }
        }
        if (array.count != 0) {
            [_allDataArray addObject:array];
        }
        
    }
    [_tableView reloadData];
}

#pragma mark - 分组数据
- (void)fenzuShuju{
    fenzu = YES;
    quanbu = NO;
    [_dataArray removeAllObjects];
     fenzuArray = [FenzuStores getAllWithGongsiID:[AppStore getGongsiID] Parid:@"0"];
    for (FenzuInfoDB *db in fenzuArray) {
        FenzuModel *model = [[FenzuModel alloc] init];
        model.deptsSM = db;
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark 分组
- (void)fenzuData{
    NSLog(@"分组");
    [FenzuStores deleteDataInGongSiTongXunLuFenzuDataBase];
    [ServiceShell getCompanyDeptsListWithCompanyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyDeptsSM *companyDeptsSM) {
         [_tableView.header endRefreshing];
        if (serviceContext.isSucceeded) {
            
            for (CompanyDeptsSM *deptsSM in companyDeptsSM.data) {
                [FenzuDB saveToDB:deptsSM];
            }
            [self fenzuShuju];
        }
    }];
    
}
#pragma mark 全部
- (void)quanbuData{
    
    
    NSLog(@"全部");
    [ServiceShell getCompanyPersonsWithCompanyid:[AppStore getGongsiID] Start:Start Count:Count Priorityyouxianji:YES usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyPersonsSM *PersonsSM) {

        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        if (PersonsSM.data.count != 0) {
            if (PersonsSM.data.count != Count){
                [_tableView.header endRefreshing];//停止刷新
                [self saveDataInDBWithResultModelOfCompanyPersonsSM:PersonsSM];
                return ;
            }
            [self saveDataInDBWithResultModelOfCompanyPersonsSM:PersonsSM];
            dispatch_queue_t newQueue =dispatch_queue_create("NEW", NULL);
            dispatch_async(newQueue, ^{
                /* vvvvv */
                beishu++;
                Start = Count*beishu;
                if([self respondsToSelector:@selector(quanbuData)])
                    [self quanbuData];
                
            });
        }

    }];
}

#pragma mark 保存数据库
- (void)saveDataInDBWithResultModelOfCompanyPersonsSM:(ResultModelOfCompanyPersonsSM*)PersonsSM
{
    
    dispatch_queue_t myQueue = dispatch_queue_create("jhon", NULL);
    dispatch_async(myQueue, ^{
        /*由于数据太多有时候会出现，数据库执行失败的情况.
         所以每保存200个休息0.25秒
         */
        for (DeptPersonsSM *sm in PersonsSM.data) {
            [YonghuDB saveToDB:sm];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self respondsToSelector:@selector(yonghuShuju)])
                [self yonghuShuju];
        });
    });
    
    
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView != _tableView || quanbu) {
        return 60;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 22)];
    headerLabel.text = [letterArray objectAtIndex:section];
    headerLabel.font = [UIFont systemFontOfSize:12];
    headerLabel.textColor = RGBACOLOR(174, 174, 174, 1);
    [headerView addSubview:headerLabel];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView != _tableView) {
        TongxunluModel *model;
        model = [_resultArray objectAtIndex:indexPath.row];
        NSLog(@"第%ld分区,第%ld行被选中",(long)indexPath.section,(long)indexPath.row);
        LianXiRenXiangQingViewController *lianXiRenVC = [[LianXiRenXiangQingViewController alloc] init];
        lianXiRenVC.ID = model.personsSM.userid;
        lianXiRenVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lianXiRenVC animated:YES];
    }else{
        if (fenzu) {
            
            FenzuModel *model = _dataArray[indexPath.row];
            
            if (model.deptsSM.isleaf == 0) {
                XiaofenTongxunluViewController *xiaofenzu = [[XiaofenTongxunluViewController alloc] init];
                xiaofenzu.ID = model.deptsSM._id;
                xiaofenzu.Title = model.deptsSM.name;
                xiaofenzu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:xiaofenzu animated:YES];
            }else{
                ZifenzuTongxunluViewController *zitongxunlu = [[ZifenzuTongxunluViewController alloc]init];
                zitongxunlu.ID = model.deptsSM._id;
                zitongxunlu.Title = model.deptsSM.name;
                zitongxunlu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:zitongxunlu animated:YES];
            }
        }else{
            TongxunluModel *model;
            if (tableView != _tableView) {
                model = [_resultArray objectAtIndex:indexPath.row];
                
            }else{
                NSMutableArray *array = [_allDataArray objectAtIndex:indexPath.section];
                model = [array objectAtIndex:indexPath.row];
            }
            NSLog(@"第%ld分区,第%ld行被选中",(long)indexPath.section,(long)indexPath.row);
            LianXiRenXiangQingViewController *lianXiRenVC = [[LianXiRenXiangQingViewController alloc] init];
            lianXiRenVC.ID = model.personsSM.userid;
            lianXiRenVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lianXiRenVC animated:YES];
        }
    }
    
}

#pragma mark - table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //可以通过传递过来的tableView参数来判断，到底是通过哪个tableView调用的此方法
    if (tableView!=_tableView) {
        //搜索控制器所对应的tableView
        return 1;
    }else{
        //自己的创建的tableView
        if (quanbu) {
            return [letterArray count];
        }else{
            return 1;
        }
    }
    
}

//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView!=_tableView) {
        //收集搜索结果,收集完成后 返回搜索结果的数目
        //搜索之前，先清除旧的搜索结果
        [_resultArray removeAllObjects];
        //根据用户在搜索框中输入的关键字，从_dataArray中筛选包含关键字的字符串,放入_resultArray中
        //_searchBar.text 能够拿到用户在搜索框中输入的文字
        for (YonghuInfoDB *db in yonghuArray) {
            NSRange rangeName = [db.name rangeOfString:_searchBar.text];
            NSRange rangePhone = [db.phone rangeOfString:_searchBar.text];
            if (rangeName.location != NSNotFound || rangePhone.location != NSNotFound) {
                //str符合搜索结果
                TongxunluModel *model = [[TongxunluModel alloc] init];
                model.personsSM = db;
                [_resultArray addObject:model];
            }
        }
        return [_resultArray count];
    }else{
        if (quanbu) {
            return  [[_allDataArray objectAtIndex:section] count];
        }else{
            return [_dataArray count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView!=_tableView) {
        TongxunluViewCell *tongxunluCell = [TongxunluViewCell cellForTableView:tableView];
        TongxunluModel *model = [_resultArray objectAtIndex:indexPath.row];
        tongxunluCell.model = model;
        model.delegate = self;
        return tongxunluCell;
    }
    if (quanbu) {
        TongxunluViewCell *tongxunluCell = [TongxunluViewCell cellForTableView:tableView];
        NSMutableArray *array = [_allDataArray objectAtIndex:indexPath.section];
        TongxunluModel *model = [array objectAtIndex:indexPath.row];
        tongxunluCell.model = model;
        model.delegate = self;
        return tongxunluCell;
    }else if(fenzu){
        FenzuViewCell *fenzuCell = [FenzuViewCell cellForTableView:tableView];
        FenzuModel *model = [_dataArray objectAtIndex:indexPath.row];
        fenzuCell.model = model;
        
        return fenzuCell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (quanbu && tableView == _tableView) {
        return 22;
    }
    return 0;
}

//为tableView设置索引,索引显示在tableView的右边
//返回值，数组中放的是所有索引标题的字符串
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    if (quanbu && tableView == _tableView) {
        return letterArray;
    }else{
        return nil;
    }
}

//title 被选中的索引标题,index 被选中索引标题在索引中的位置
//返回值  要指向的分区的位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //关键要找到index与返回值的关系
    //当返回值为-1时，不会引起tableView的滚动
    return index;
}


#pragma mark - AllDelegate
-(void)callNumber:(TongxunluModel *)model
{
    NSLog(@"打电话");
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",model.personsSM.phone];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)chatMessage:(TongxunluModel *)model
{
    NSLog(@"发起聊天");
//    NSMutableArray *_xuanzhongArray = [[NSMutableArray alloc] init];
//    [_xuanzhongArray addObject:model];
    ChatViewController *chatView =[[ChatViewController alloc]initWithChatter:[model.personsSM.userid substringToIndex:20] isGroup:NO];
    chatView.hidesBottomBarWhenPushed = YES;
    chatView.name = model.personsSM.name;
    chatView.Renyuanid = model.personsSM.userid;
    chatView.phonto = model.personsSM.imgurl;
    [self.navigationController pushViewController:chatView animated:YES];
    
}

-(void)smsMessage:(TongxunluModel *)model
{
    NSLog(@"发送短信消息");
    NSString *telUrl = [NSString stringWithFormat:@"sms://%@",model.personsSM.phone];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height-49);
}

- (NSString *)panDuanIsNull:(id)text{
    if (text == nil || [text isEqual:[NSNull null]] || text == NULL) {
        return @"";
    }else{
        return text;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (fenzu) {
        if (indexPath.row == fenzuArray.count-1) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }else{
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
        }
    }else if (quanbu){
        if (indexPath.row == [[_allDataArray objectAtIndex:indexPath.section] count]-1) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }else{
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
        }
    }
    
}

@end
