//
//  XuanzeRenyuanViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XuanzeRenyuanViewController.h"
#import "FenzuModel.h"
#import "FenzuViewCell.h"
#import "XuanzeRenyuanModel.h"
#import "XuanzeRenyuanCellView.h"
#import "XiaofenXuanrenViewController.h"
#import "ZifenzuXuanrenViewController.h"
#import "SousuoView.h"
#import "ChatViewController.h"
#import "ShengpiDetailViewController.h"
#import "BianjiVC.h"

@interface XuanzeRenyuanViewController ()<UITextFieldDelegate>
{
    //原始数据源
    NSMutableArray *_dataArray;
    NSMutableArray *_allDataArray;
    ///
    //用于存放搜索结果
    NSMutableArray *_resultArray;
    
    BOOL fenzu;
    BOOL quanbu;
    
    BOOL sousuo;
    
    NSMutableArray *letterArray;
    
    SousuoView *sousuoView;
    
    UIScrollView *_scrollView;
    
    NSMutableArray *yonghuArray;
    
    NSString *groupId;
    
    NSMutableArray *fenzuArray;
    
    NSInteger segindex;
    
    int Start;
    int Count;
    int beishu;
    
}
@end

@implementation XuanzeRenyuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    _dataArray = [@[] mutableCopy];
    _allDataArray = [@[] mutableCopy];
    _resultArray = [@[] mutableCopy];
    letterArray = [@[] mutableCopy];
    yonghuArray = [@[] mutableCopy];
    fenzuArray = [@[] mutableCopy];
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = RGBACOLOR(53, 55, 68, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //分组
    fenzuArray = [FenzuStores getAllWithGongsiID:[AppStore getGongsiID] Parid:@"0"];
    //通讯录
    yonghuArray = [YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
    // Do any additional setup after loading the view from its nib.
    
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
    
    if (yonghuArray.count == 0) {
        [self quanbuData];
    }else{
        [self xiugaishuju];
    }
    segindex = 0;
}

-(void)loadData{
    if (fenzu) {
        [self fenzuData];
    }else if(quanbu){
        
        [self quanbuData];
    }
}

#pragma mark 布局

- (void)initUI{
    [self customBackItemIsHidden:YES];
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    
    
    [self addItemWithTitle:@"取消" imageName:@"" selector:@selector(quxiaoSelector) location:YES];
    [self addItemWithTitle:@"确定" imageName:@"" selector:@selector(quedingSelector) location:NO];
    
    [self addSegmentedControlWithLeftTitle:@"全部" RightTitle:@"分组" selector:@selector(segmentedControlValueChanged:)];
    // Do any additional setup after loading the view from its nib.
    
    sousuoView = [[SousuoView alloc] init];
    sousuoView.sousuoTextField.delegate = self;
    sousuoView.frame = CGRectMake(0, 64, ScreenWidth, 50);
    [self.view addSubview:sousuoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:sousuoView.sousuoTextField];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, 0, 50)];
    [self.view addSubview:_scrollView];
    
    
    if (self.liaotian) {
        if (_xuanzhongArray.count == 0) {
            self.itemBtn.enabled = NO;
            [self.itemBtn setTitleColor:RGBACOLOR(168, 171, 186, 1) forState:UIControlStateNormal];
            _xuanzhongArray = [[NSMutableArray alloc] init];
        }else{
            self.itemBtn.enabled = YES;
            [self.itemBtn setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
            
            [self tianjiaTuanpian:_xuanzhongArray isDel:NO];
        }
    }else{
        if (_xuanzhongArray.count == 0) {
            _xuanzhongArray = [[NSMutableArray alloc] init];
        }else{
            [self tianjiaTuanpian:_xuanzhongArray isDel:NO];
        }
    }
}


#pragma mark - 搜索

- (void)textFieldChanged{
    NSLog(@"%@",sousuoView.sousuoTextField.text);
    
    NSString *lang;
    if (IOSDEVICE) {
        lang = sousuoView.sousuoTextField.textInputMode.primaryLanguage;
    }else{
        lang = [[UITextInputMode currentInputMode] primaryLanguage];
    }
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [sousuoView.sousuoTextField markedTextRange];
        UITextPosition *position = [sousuoView.sousuoTextField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            [_resultArray removeAllObjects];
            
            //_searchBar.text 能够拿到用户在搜索框中输入的文字
            
            for (NSMutableArray *array in _allDataArray) {
                for (XuanzeRenyuanModel *model in array) {
                    NSRange rangeName = [model.personsSM.name rangeOfString:sousuoView.sousuoTextField.text];
                    NSRange rangePhone = [model.personsSM.phone rangeOfString:sousuoView.sousuoTextField.text];
                    if (rangeName.location != NSNotFound || rangePhone.location != NSNotFound) {
                        //str符合搜索结果
                        sousuo = YES;
                        fenzu = NO;
                        quanbu = NO;
                        [_resultArray addObject:model];
                    }
                }
            }
            
        }
    }
    
    if (sousuoView.sousuoTextField.text.length == 0) {
        if (segindex == 0) {
            sousuo = NO;
            fenzu = NO;
            quanbu = YES;
        }else if(segindex == 1){
            sousuo = NO;
            fenzu = YES;
            quanbu = NO;
        }
    }
    
    [_tableView reloadData];
    
    
}

#pragma mark - 切换seg

- (void)segmentedControlValueChanged:(UISegmentedControl *)seg{
    segindex = seg.selectedSegmentIndex;
    if (seg.selectedSegmentIndex == 0) {
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
            fenzu = NO;
            quanbu = YES;
            [self xiugaishuju];
        }
    }else{
        fenzu = YES;
        quanbu = NO;
        if (_dataArray.count == 0) {
            if ([NetWork isConnectionAvailable]) {
                [self loadData];
            }else{
                [self fenzuShuju];
            }
        }else{
            
            [_tableView reloadData];
        }
    }
}

 #pragma mark - 修改数据
 
- (void)xiugaishuju{

    [self yonghuShuju];
    
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
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (YonghuInfoDB *db in yonghuArray) {
            
            NSString *letter = [db.letter uppercaseString];
            if ([letter isEqualToString:Letter]) {
                
                XuanzeRenyuanModel *model = [[XuanzeRenyuanModel alloc] init];
                model.personsSM = db;
                
                if (_xuanzhongArray.count != 0) {
                    for (XuanzeRenyuanModel *renyuan in _xuanzhongArray) {
                        if ([renyuan.personsSM.userid isEqualToString:db.userid]) {
                            model.xuanzhong = YES;
                        }
                    }
                }
                
                for (NSString *add in _addArray) {
                    if ([model.personsSM.userid isEqualToString:add]) {
                        model.endure = YES;
                    }
                }
                
                if (_endureArray.count != 0) {
                    for (NSString *endureid in _endureArray) {
                        if (![model.personsSM.userid isEqualToString:endureid]) {
                            if (![letterArray containsObject:letter]) {
                                [letterArray addObject:letter];
                            }
                            [array addObject:model];
                            
                        }
                    }
                }else{
                    if (![letterArray containsObject:letter]) {
                        [letterArray addObject:letter];
                    }
                    [array addObject:model];
                    
                }
                
            }
        }
        if (array.count != 0) {
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    for (FenzuInfoDB *db in fenzuArray) {
        FenzuModel *model = [[FenzuModel alloc] init];
        model.deptsSM = db;
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}

- (void)quxiaoSelector{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)quedingSelector{
    if (!self.liaotian) {
        //转交审批
        if (self.zhuanjiao) {
            if (_xuanzhongArray.count != 0) {
                [self dismissViewControllerAnimated:NO completion:^{
                    [self xuanzhongRenyuan];
                }];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                [self xuanzhongRenyuan];
            }];
        }
        
    }else{
        //发起聊天
        
        if (_xuanzhongArray.count==1) {
            if (self.isDetail) {
                [self chuangjianQunzu];
            }else{
                [self chuangjianDanliao];
            }
        }else{
            [self chuangjianQunzu];
        }
        
    }
}

- (void)xuanzhongRenyuan{
//    if (_xuanzhongArray.count != 0) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_xuanzhongArray,@"xuanzhongArray",groupId,@"groupId",nil];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"xuanzhongArray" object:nil userInfo:dict];
//    }
}

- (void)chuangjianDanliao{
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self xuanzhongRenyuan];
    }];
}

- (void)chuangjianQunzu{
    if (_isAddMenbers){
        //群组加人
        if (_xuanzhongArray.count) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self xuanzhongRenyuan];
            }];
        }
    }else if (!_isAddMenbers){
        //创建群组
        if (_xuanzhongArray.count) {
            EMGroupStyleSetting *setting =[[EMGroupStyleSetting alloc]init];
            setting.groupStyle =eGroupStyle_PrivateMemberCanInvite;
            setting.groupMaxUsersCount =500;
            [self showHudInView:self.view hint:@"准备开始群聊"];
            
            NSMutableArray *Nametemp =[@[] mutableCopy];
            NSMutableArray *IDtemp=[@[] mutableCopy];
            NSMutableArray *touxiangArray=[@[] mutableCopy];
            for (XuanzeRenyuanModel *model in _xuanzhongArray) {
                //name
                [Nametemp addObject:model.personsSM.name.length?model.personsSM.name:@"AA"];
                //id number
                [touxiangArray addObject:model.personsSM.imgurl];
                [IDtemp addObject:[[model.personsSM.userid substringToIndex:20] lowercaseString]];
            }
            [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:[Nametemp componentsJoinedByString:@"、"] description:@"iOS" invitees:IDtemp initialWelcomeMessage:@"iOS" styleSetting:setting completion:^(EMGroup *group, EMError *error) {
                if (group && !error) {
                    [self hideHud];
                    groupId = group.groupId;
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self xuanzhongRenyuan];
                    }];
                }
            } onQueue:nil];
        }
    }
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
    
    /*
    NSLog(@"分组");
    [ServiceShell getCompanyDeptsWithCompanyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyDeptsSM *companyDeptsSM) {
        
        [_tableView.header endRefreshing];//停止刷新
        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        for (CompanyDeptsSM *deptsSM in companyDeptsSM.data) {
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            FenzuModel *model = [[FenzuModel alloc] init];
            model.deptsSM = deptsSM;
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    }];
    */
}

#pragma mark 全部
- (void)quanbuData{
    
    
    NSLog(@"全部");
    [ServiceShell getCompanyPersonsWithCompanyid:[AppStore getGongsiID] Start:Start Count:Count Priorityyouxianji:YES usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyPersonsSM *PersonsSM) {
        [_tableView.header endRefreshing];//停止刷新
        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        if (PersonsSM.data.count != 0) {
            
            if (PersonsSM.data.count != Count){
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
#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (quanbu || sousuo) {
        return 60;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //自动反选
    if (fenzu && _resultArray.count == 0) {
        
        FenzuModel *model = _dataArray[indexPath.row];
        
        if (model.deptsSM.isleaf == 0) {
            XiaofenXuanrenViewController *xiaofenzu = [[XiaofenXuanrenViewController alloc] init];
            xiaofenzu.ID = model.deptsSM._id;
            xiaofenzu.Title = model.deptsSM.name;
            xiaofenzu.xuanzhongArray = _xuanzhongArray;
            xiaofenzu.endureArray = _endureArray;
            xiaofenzu.addArray = _addArray;
            xiaofenzu.liaotian = self.liaotian;
            xiaofenzu.isDetail = self.isDetail;
            xiaofenzu.isAddMenbers = self.isAddMenbers;
            xiaofenzu.shengpi = self.shengpi;
            xiaofenzu.chaosong = self.chaosong;
            xiaofenzu.zhuanjiao = self.zhuanjiao;
            xiaofenzu.passValueFromXuanzhong = ^ (NSMutableArray *xuanzhong){
                _xuanzhongArray = xuanzhong;
                [self tianjiaTuanpian:xuanzhong isDel:NO];
            };
            
            [self.navigationController pushViewController:xiaofenzu animated:YES];
        }else{
            ZifenzuXuanrenViewController *zitongxunlu = [[ZifenzuXuanrenViewController alloc]init];
            zitongxunlu.ID = model.deptsSM._id;
            zitongxunlu.Title = model.deptsSM.name;
            zitongxunlu.xuanzhongArray = _xuanzhongArray;
            zitongxunlu.endureArray = _endureArray;
            zitongxunlu.addArray = _addArray;
            zitongxunlu.liaotian = self.liaotian;
            zitongxunlu.isDetail = self.isDetail;
            zitongxunlu.isAddMenbers = self.isAddMenbers;
            zitongxunlu.shengpi = _shengpi;
            zitongxunlu.chaosong = _chaosong;
            zitongxunlu.zhuanjiao = _zhuanjiao;
            zitongxunlu.passValueFromXuanzhong = ^ (NSMutableArray *xuanzhong){
                _xuanzhongArray = xuanzhong;
                [self tianjiaTuanpian:xuanzhong isDel:NO];
            };
            
            [self.navigationController pushViewController:zitongxunlu animated:YES];
        }
        //        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        
        XuanzeRenyuanModel *model;
        if (quanbu) {
            NSMutableArray *array = [_allDataArray objectAtIndex:indexPath.section];
            model = [array objectAtIndex:indexPath.row];
        }else{
            model = [_resultArray objectAtIndex:indexPath.row];
        }
        
        if (_addArray.count != 0) {
            for (NSString *add in _addArray) {
                if (![model.personsSM.userid isEqualToString:add]) {
                    [self xuanrenWithModel:model];
                    break;
                }
            }
        }else{
            [self xuanrenWithModel:model];
        }
        
        [_tableView reloadData];
    }

}

- (void)xuanrenWithModel:(XuanzeRenyuanModel *)model{
    if (self.shengpi || self.zhuanjiao) {
        if (_xuanzhongArray.count == 0) {
            if (!model.endure) {
                model.xuanzhong = !model.xuanzhong;
            }
        }else{
            if (!model.endure) {
                model.xuanzhong = NO;
            }
        }
    }else{
        if (!model.endure) {
            model.xuanzhong = !model.xuanzhong;
        }
    }
    
    if (model.personsSM.imgurl.length == 0) {
        model.personsSM.imgurl = @"";
    }
    
    if (model.xuanzhong) {
        [_xuanzhongArray addObject:model];
        [self tianjiaTuanpian:_xuanzhongArray isDel:NO];
    }else{
        for (XuanzeRenyuanModel *xuanzeModel in _xuanzhongArray) {
            if ([model.personsSM.userid isEqual:xuanzeModel.personsSM.userid]) {
                [_xuanzhongArray removeObject:xuanzeModel];
                break;
            }
        }
        [self tianjiaTuanpian:_xuanzhongArray isDel:YES];
        
    }
    
}

#pragma mark - table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //可以通过传递过来的tableView参数来判断，到底是通过哪个tableView调用的此方法
    //自己的创建的tableView
    if (quanbu) {
        return [_allDataArray count];
    }else{
        return 1;
    }
    
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

//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (quanbu) {
        return  [[_allDataArray objectAtIndex:section] count];
    }else if (sousuo){
        return [_resultArray count];
    }else{
        return [_dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (quanbu) {
        XuanzeRenyuanCellView *tongxunluCell = [XuanzeRenyuanCellView cellForTableView:tableView];
        
        NSMutableArray *array = [_allDataArray objectAtIndex:indexPath.section];
        XuanzeRenyuanModel *model = [array objectAtIndex:indexPath.row];
        tongxunluCell.model = model;
        return tongxunluCell;
    }else if(sousuo){
        XuanzeRenyuanCellView *tongxunluCell = [XuanzeRenyuanCellView cellForTableView:tableView];
        
        XuanzeRenyuanModel *model = [_resultArray objectAtIndex:indexPath.row];
        tongxunluCell.model = model;
        return tongxunluCell;
    }else if(fenzu){
        FenzuViewCell *fenzuCell = [FenzuViewCell cellForTableView:tableView];
        FenzuModel *model = [_dataArray objectAtIndex:indexPath.row];
        fenzuCell.model = model;
        
        return fenzuCell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (quanbu) {
        return [NSString stringWithFormat:@"%c",'A'+(int)section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (quanbu) {
        return 22;
    }
    return 0;
    
}

//为tableView设置索引,索引显示在tableView的右边
//返回值，数组中放的是所有索引标题的字符串
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:UITableViewIndexSearch];
    
    for (int i='A'; i<='Z'; i++) {
        NSString *title = [NSString stringWithFormat:@"%c",i];
        [array addObject:title];
    }
    [array addObject:@"#"];
    if (quanbu) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (IOSDEVICE) {
        _tableView.frame = CGRectMake(0, 50, ScreenWidth, ScreenHeight-50);
    }else{
        _tableView.frame = CGRectMake(0, 50, ScreenWidth, ScreenHeight-NavHeight-50);
    }
}

#pragma UiTextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_xuanzhongArray.count == 0) {
        sousuoView.tubiao.hidden = YES;
        sousuoView.sousuoTextField.frame = CGRectMake(15, 0, ScreenWidth-15, 50);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_xuanzhongArray.count == 0) {
        sousuoView.tubiao.hidden = NO;
        sousuoView.sousuoTextField.frame = CGRectMake(38, 0, ScreenWidth-38, 50);
    }
    return [textField resignFirstResponder];
}

#pragma mark 动态布局
- (void)tianjiaTuanpian:(NSMutableArray *)photoS isDel:(BOOL)isDelete{
    
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float imageFrameWidth = 33.0;
    float imageFrameHeight = 33.0;
    float panding = 5.0;
    
    for (int i = 0; i < photoS.count; i++) {
        NSLog(@"---%@",[[[photoS objectAtIndex:i] personsSM] phone]);
        NSLog(@"---%@",[[[photoS objectAtIndex:i] personsSM] userid]);
        UIImageView *imageFrame = [[UIImageView alloc] init];
        imageFrame.frame = CGRectMake(10+(imageFrameWidth+panding)*i, (50-33)/2.0, imageFrameWidth, imageFrameHeight);
        
        if ([((XuanzeRenyuanModel *)[photoS objectAtIndex:i]).personsSM.imgurl isEqualToString:@"头像80.png"]) {
            [imageFrame setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,((XuanzeRenyuanModel *)[photoS objectAtIndex:i]).personsSM.imgurl] fileName:@"头像80.png" Width:imageFrameWidth];
            
        }else{
            
            [imageFrame setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,((XuanzeRenyuanModel *)[photoS objectAtIndex:i]).personsSM.imgurl] fileName:@"头像80.png" Width:imageFrameWidth];
            
        }
        
        [_scrollView addSubview:imageFrame];
        
    }
    sousuoView.tubiao.hidden = YES;
    CGPoint offset = _scrollView.contentOffset;
    int count;
    
    count = (ScreenWidth - panding  - 100)/(imageFrameWidth + panding);
    
    if (photoS.count >= count) {
        _scrollView.frame = CGRectMake(0, 64, count*40,50);
        sousuoView.shuxian.hidden = NO;
        sousuoView.shuxian.frame = CGRectMake(_scrollView.frame.size.width+_scrollView.frame.origin.x, 0, 1, 50);
        
        sousuoView.sousuoTextField.frame = CGRectMake(sousuoView.shuxian.frame.size.width+sousuoView.shuxian.frame.origin.x+10, 0, ScreenWidth-sousuoView.shuxian.frame.size.width-sousuoView.shuxian.frame.origin.x, 50);
        if (photoS.count > count) {
            if (isDelete) {
                offset.x -= (imageFrameWidth+panding);
            }else{
                offset.x += (imageFrameWidth+panding);
            }
            [_scrollView setContentOffset:offset animated:YES];
        }
        
    }else{
        
        sousuoView.shuxian.hidden = YES;
        if (photoS.count == 1 || photoS.count == 2) {
            _scrollView.frame = CGRectMake(0, 64, photoS.count*43,50);
        }else{
            _scrollView.frame = CGRectMake(0, 64, photoS.count*40,50);
        }
        
        if (photoS.count == 0) {
            sousuoView.tubiao.hidden = NO;
            sousuoView.sousuoTextField.frame = CGRectMake(38, 0, ScreenWidth-38, 50);
        }else{
            sousuoView.sousuoTextField.frame = CGRectMake(_scrollView.frame.size.width+_scrollView.frame.origin.x+10, 0, ScreenWidth-_scrollView.frame.size.width-_scrollView.frame.origin.x, 50);
        }
        
    }
    
    _scrollView.contentSize = CGSizeMake(photoS.count*40, 50);
    
    if (self.liaotian) {
        if (_xuanzhongArray.count != 0) {
            self.itemBtn.enabled = YES;
            [self.itemBtn setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
        }else{
            self.itemBtn.enabled = NO;
            [self.itemBtn setTitleColor:RGBACOLOR(168, 171, 186, 1) forState:UIControlStateNormal];
        }
    }
}
//判断是否为空
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
