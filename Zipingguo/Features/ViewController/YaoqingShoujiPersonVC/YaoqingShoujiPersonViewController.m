//
//  YaoqingShoujiPersonViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YaoqingShoujiPersonViewController.h"
#import "ShoujiTongxunluModel.h"
#import "ShoujiTongxunluCellView.h"
#import "ZCAddressBook.h"
@interface YaoqingShoujiPersonViewController ()
{
    //原始数据源
    NSMutableArray *_dataArray;
    ///
    //用于存放搜索结果
    NSMutableArray *_resultArray;
    
    //搜索条(普通视图控件)
    UISearchBar  *_searchBar;
    //搜索控制器(用于开启搜索模式，并呈现搜索结果)
    UISearchDisplayController *_displayController;
    
    ShoujiTongxunluModel *yaoqingModel;
    
    NSMutableArray *_xuanzhongArray;
    
    NSMutableArray *letterArray;
    
    NSMutableArray *phoneArray;

}
@end

@implementation YaoqingShoujiPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请手机联系人";
    [self addItemWithTitle:@"全选" imageName:nil selector:@selector(rightSelector) location:NO];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 58)];
    view.backgroundColor = [UIColor clearColor];
    shoujiTabelView.tableFooterView = view;
    
    shoujiTabelView.separatorColor = Fenge_Color;
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    if (!self.isDenglu) {
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                        UITextAttributeFont : [UIFont systemFontOfSize:16]};
        [self customBackItemWithImage:@"返回icon" Color:RGBACOLOR(4, 175, 245, 1) IsHidden:NO];
        [self.backbtn setFrame:CGRectMake(0,0,18,18)];
        [self.backbtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    _dataArray = [@[] mutableCopy];
    _resultArray = [@[] mutableCopy];
    _xuanzhongArray = [@[] mutableCopy];
    letterArray = [@[] mutableCopy];
    phoneArray = [@[] mutableCopy];
    
    // Do any additional setup after loading the view from its nib.
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    shoujiTabelView.tableHeaderView = _searchBar;
    _searchBar.placeholder = @"请输入关键词";
    _searchBar.delegate = self;
    //创建搜索控制器
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //为搜索控制器中tableView设置数据源和代理
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
    
    [self loadData];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)rightSelector{
    NSMutableArray *muArray = [@[] mutableCopy];
    for ( NSArray *array in _dataArray) {
        [muArray addObjectsFromArray:array];
    }
    
    
    if (_xuanzhongArray.count == muArray.count) {
        [_xuanzhongArray removeAllObjects];
        [phoneArray removeAllObjects];
        [self addItemWithTitle:@"全选" imageName:nil selector:@selector(rightSelector) location:NO];
        if (!self.isDenglu) {
            [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.itemBtn setFrame:CGRectMake(0,0,40,18)];
        for(int i = 0;i < _dataArray.count; i++)
        {
            NSArray *subArr = _dataArray[i];
            
            for(int j = 0;j< subArr.count; j++)
            {
                ShoujiTongxunluModel *model = subArr[j];
                
                if (!model.endure) {
                    model.isSelect = NO;
                    model.selIcon = @"未选icon.png";
                    yaoqingModel = model;
                    
                }else{
                    model.isSelect = NO;
                    model.selIcon = @"未选icon.png";
                    yaoqingModel = model;
                }
                
            }
        }
    }else{
        [self addItemWithTitle:@"取消全选" imageName:nil selector:@selector(rightSelector) location:NO];
        if (!self.isDenglu) {
            [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        self.itemBtn.frame = CGRectMake(0,0,70,18);
        for(int i = 0;i < _dataArray.count; i++)
        {
            NSArray *subArr = _dataArray[i];
            
            for(int j = 0;j< subArr.count; j++)
            {
                ShoujiTongxunluModel *model = subArr[j];
                
                if (!model.endure) {
                    model.isSelect = YES;
                    model.selIcon = @"选中圆.png";
                    yaoqingModel = model;
                    
                    if (![_xuanzhongArray containsObject:model]) {
                        [_xuanzhongArray addObject:model];
                        [phoneArray addObject:[NSString stringWithFormat:@"%@,%@",model.phone,model.name]];
                    }
                    
                }else{
                    model.isSelect = YES;
                    model.selIcon = @"选中圆.png";
                    yaoqingModel = model;
                    
                    if (![_xuanzhongArray containsObject:model]) {
                        [_xuanzhongArray addObject:model];
                        [phoneArray addObject:[NSString stringWithFormat:@"%@,%@",model.phone,model.name]];
                    }
                }
                
            }
        }
    }
    [shoujiTabelView reloadData];
}

- (void)loadData{
    [_dataArray removeAllObjects];
    [LDialog showWaitBox:@"获取通讯录"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict2 = [[ZCAddressBook shareControl] getPersonInfo];
        NSArray *arr = [[ZCAddressBook shareControl] sortMethod];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSString *s in arr) {
                if ([s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
                    continue;
                }
                [letterArray addObject:s.uppercaseString];
                NSMutableArray *items = [NSMutableArray array];
                for (NSDictionary *dict in [dict2 objectForKey:s]) {
                    ShoujiTongxunluModel *model = [[ShoujiTongxunluModel alloc] init];
                    model.icon = @"未选icon.png";
                    model.isSelect = NO;
                    model.name = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"last"],[dict objectForKey:@"first"]];
                    model.phone = [[dict objectForKey:@"telphone"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    if (_enduleArray.count) {
                        for (NSString *endue in _enduleArray) {
                            if ([endue isEqualToString:model.phone]) {
                                model.endure = YES;
                                model.endueIcon = @"已选icon.png";
                            }
                        }
                    }
                    
                    yaoqingModel = model;
                    if (model.phone.length != 0) {
                        [items addObject:model];
                    }
                }
                [_dataArray addObject:items];
            }
            [shoujiTabelView reloadData];
            [LDialog closeWaitBox];
        });
    });
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

#pragma mark tableView代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //可以通过传递过来的tableView参数来判断，到底是通过哪个tableView调用的此方法
    if (tableView != shoujiTabelView) {
        //搜索控制器所对应的tableView
        return 1;
    }else{
        //自己的创建的tableView
        return [_dataArray count];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView != shoujiTabelView) {
        //
        return nil;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        headerView.backgroundColor = RGBACOLOR(244, 247, 252, 1);
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 20)];
        headerLabel.text = letterArray[section];
        headerLabel.textColor = RGBACOLOR(160, 160, 162, 1);
        headerLabel.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:headerLabel];
        return headerView;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView != shoujiTabelView) {
        //收集搜索结果,收集完成后 返回搜索结果的数目
        //搜索之前，先清除旧的搜索结果
        [_resultArray removeAllObjects];
        //根据用户在搜索框中输入的关键字，从_dataArray中筛选包含关键字的字符串,放入_resultArray中
        //_searchBar.text 能够拿到用户在搜索框中输入的文字
        for (NSMutableArray *array in _dataArray) {
            for (ShoujiTongxunluModel *model in array) {
                NSRange range = [model.name rangeOfString:_searchBar.text];
                if (range.location!=NSNotFound) {
                    //str符合搜索结果
                    [_resultArray addObject:model];
                }
            }
            
        }
        return [_resultArray count];
    }else{
        if (_dataArray.count != 0) {
            return [[_dataArray objectAtIndex:section] count];
        }
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != shoujiTabelView) {
        return 0.01;
    }else{
        if (_dataArray.count != 0) {
            if ([[_dataArray objectAtIndex:(section)] count] != 0)
            {
                return 30;
            }
        }
        return 0.01;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoujiTongxunluCellView *cell = [ShoujiTongxunluCellView cellForTableView:tableView];
    ShoujiTongxunluModel *model;
    
    if (tableView != shoujiTabelView) {
        model = _resultArray[indexPath.row];
    }else{
        model = _dataArray[indexPath.section][indexPath.row];
    }
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoujiTongxunluModel *model;
    if (tableView != shoujiTabelView) {
        model = _resultArray[indexPath.row];
    }else{
       model = _dataArray[indexPath.section][indexPath.row];
    }
    
    if (!model.endure) {
        model.isSelect = !model.isSelect;
        model.selIcon = @"选中圆.png";
        yaoqingModel = model;
        
        if (model.isSelect) {
            [_xuanzhongArray addObject:model];
            [phoneArray addObject:[NSString stringWithFormat:@"%@,%@",model.phone,model.name]];
        }else{
            [_xuanzhongArray removeObject:model];
            [phoneArray removeObject:[NSString stringWithFormat:@"%@,%@",model.phone,model.name]];
        }
        
        NSMutableArray *muArray = [@[] mutableCopy];
        for ( NSArray *array in _dataArray) {
            [muArray addObjectsFromArray:array];
        }
        
        if (_xuanzhongArray.count == muArray.count) {
            [self addItemWithTitle:@"取消全选" imageName:nil selector:@selector(rightSelector) location:NO];
            self.itemBtn.frame = CGRectMake(0,0,70,18);
            if (!self.isDenglu) {
                [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }else{
            [self addItemWithTitle:@"全选" imageName:nil selector:@selector(rightSelector) location:NO];
            self.itemBtn.frame = CGRectMake(0,0,40,18);
            if (!self.isDenglu) {
                [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
    }
    
    [shoujiTabelView reloadData];
}
- (IBAction)yaoqingButtonClick:(UIButton *)sender {
    if (sender == yaoqingBtn) {
        
        if (phoneArray.count == 0) {
            [ToolBox Tanchujinggao:@"请选择邀请人,进行邀请" IconName:nil];
            return;
        }
        
        YaoqingYuangongSM *yaoqingSM =[[YaoqingYuangongSM alloc] init];
        yaoqingSM.companyid = [AppStore getGongsiID];
        yaoqingSM.userid = [AppStore getYongHuID];
        yaoqingSM.invitephones = phoneArray;
        [ZhuceServiceShell YaoqingWithYaoqingYuangong:yaoqingSM usingCallback:^(DCServiceContext *serviceContext, YaoqingSM *model) {
            if (serviceContext.isSucceeded && model.status == 0) {
                
                if (model.data.count != 0) {
                    NSMutableArray *pARR = [@[] mutableCopy];
                    for (NSString *str in model.data) {
                        [pARR addObject:[[str componentsSeparatedByString:@","]lastObject]];
                    }
                    
                    [SDialog showTipViewWithText:[NSString stringWithFormat:@"%@,但%@已被邀请",model.msg,[pARR componentsJoinedByString:@","]]hideAfterSeconds:1.5f];
                }else{
                    [ToolBox Tanchujinggao:model.msg IconName:@"提醒_成功icon.png"];
                }
            }
        }];
    }
}

@end
