//
//  ShengpiDetailViewController.m
//  Zipingguo
//
//  Created by jiangshilin on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShengpiDetailViewController.h"
#import "UIViewController+BarButtonItemPostion.h"
#import "ShengPiCellView.h"
#import "ApplyrecordsSM.h"
#import "ApplyCcsSm.h"
#import "ApplyrecordsSM.h"
#import "ApplyDetailsSM.h"
#import "ShengpiDetailViewCell.h"
#import "ShengpiHeaderViewCell.h"
#import "NSString+Ext.h"
#import "BianjiVC.h"
#import "KaiShiShengPiViewController.h"
#import "XuanzeRenyuanViewController.h"
#import "XuanzeRenyuanModel.h"
#import "BodyTableViewCell.h"
#define  CHAT_BUTTON_SIZE 50

@interface ShengpiDetailViewController ()
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *HeaderSectionArr;
@property (nonatomic,strong)NSMutableArray *SecSectionArr;

@end

@implementation ShengpiDetailViewController
{
    ApplyDetailSM *soureData;
    ShengPiCellVM *headerVM;
    UIButton *shouqiBtn;
    int qufenType;
    UIView *diview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    if ([_mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _mTableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    _mTableView.separatorColor =Fenge_Color;
    _mTableView.scrollEnabled=YES;
    [self setExtraCellLineHidden:_mTableView];
    
    diview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    diview.backgroundColor =[UIColor clearColor];
    
    _dataArray =[@[] mutableCopy];
    _HeaderSectionArr =[@[] mutableCopy];
    _SecSectionArr =[@[] mutableCopy];
    
    if ([_vm.createid isEqualToString:[AppStore getYongHuID]]) {
       self.title = @"申请详情";
    }else{
        self.title = @"审批详情";
    }
    
    if (self.vm.extendType == 2) {
        qufenType = 0;
    }else if (self.vm.extendType == 3){
        qufenType = 1;
    }
    
    [self setupBarButtonItemBackGroudImage:nil withleftItem:@"返回icon" withPriviousPage:@"上一页" withNextPage:@"下一页"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhuanjiaoFanhui) name:@"zhuanjiaoFanhui" object:nil];
    
    [self loadData];
}
-(void)loadData
{
    if (_vm._ID) {
        [LDialog showWaitBox:@"数据加载中"];
        [ServiceShell getApplyListWithID:_vm._ID usingCallback:^(DCServiceContext *service, ResultModelOfApplyDetailSM *results) {
            [LDialog closeWaitBox];
            if (service.isSucceeded && results.status == 0) {
                if (results.data) {
                    [self updateDataForresults:results.data];
                }
            }
        }];
    }
}


-(void)updateDataForresults:(ApplyDetailSM*)data
{
    [_dataArray removeAllObjects];
    [_SecSectionArr removeAllObjects];
    [_HeaderSectionArr removeAllObjects];
    
    if (data) {
        soureData = data;
        if ([data.apply.statusValue isEqualToString:@"通过"] ||  [data.apply.statusValue isEqualToString:@"未通过"]) {
            _dibuView.hidden = YES;
        }else{
            _dibuView.hidden = NO;
            //判断是自己创建的还是别人提交给我的
            if ([_vm.createid isEqualToString:[AppStore getYongHuID]]) {
                //自己创建的
                _mTableView.tableFooterView =diview;
                _Pizhunbtn.hidden =YES;
                _bupizhunBtn.hidden =YES;
                _zhuanjianBtn.hidden =YES;
                _shanchuBtn.hidden = NO;
            }else{
                if (![data.apply.dealid isEqualToString:[AppStore getYongHuID]]) {
                    //审批人不是自己
                    _dibuView.hidden = YES;
                }else{
                    //审批人是自己
                    _mTableView.tableFooterView = diview;
                    _Pizhunbtn.hidden = NO;
                    _bupizhunBtn.hidden = NO;
                    _zhuanjianBtn.hidden = NO;
                    
                }
            }
        }
        
        ShengPiCellVM *VM =[[ShengPiCellVM alloc]init];
        VM.flowName = soureData.apply.flowname;

        VM.dealTime =[NSString stringWithFormat:@"审批时间:%@",soureData.apply.dealtime?soureData.apply.dealtime:@""];
        VM.cellHeight = 68.f;
        VM.Leixing = soureData.apply.status;
        VM.type =99999;
        [_SecSectionArr addObject:VM];
        
        [self badyViewLoadData:data];
    }
}

-(void)badyViewLoadData:(ApplyDetailSM *)data {
    [_HeaderSectionArr removeAllObjects];
    [_dataArray removeAllObjects];
    if (data) {
        for (int i=0; i<4; i++) {
            ShengPiCellVM *vm =[[ShengPiCellVM alloc]init];
            vm.extendType =2;
            vm.type=2;
            vm.iszhuanJiao=NO;
            vm.isSelected=NO;
            if (i==0) {
                vm.chname =@"申请人";
                vm.content = data.apply.createname;
                vm.isfirst =YES;
                vm.delegate=self;
            }else if (i==1){
                vm.chname =@"审批人";
                vm.content = data.apply.dealname.length?data.apply.dealname:@"";
                vm.isfirst =NO;
            }else if (i==2){
                vm.chname =@"抄送人";
                NSMutableArray *temp =[NSMutableArray array];
                for (ApplyCcsSm *sm in data.applyccs) {
                    [temp addObject:sm.username];
                }
                vm.content =temp.count?[temp componentsJoinedByString:@","]:@"";
                vm.isfirst =NO;
                vm.cellHeight =[self cellheight:vm.content withIsBody:NO];
            }
            else{
                vm.chname =@"发送时间";
                vm.content = data.apply.createtime;
                if (!data.applyrecords.count) {
                    vm.Subtype=2;
                    vm.isfirst =NO;
                    vm.islast =YES;
                }
            }
            [_HeaderSectionArr addObject:vm];
        }
        
        for (int j=0; j<data.applyrecords.count; j++) {
            
            ApplyrecordsSM *sm =[data.applyrecords objectAtIndex:j];
            
            if (sm.status == 3 || sm.status == 4) {
                ShengPiCellVM *vm =[[ShengPiCellVM alloc]init];
                vm.extendType =2;
                vm.type =2;
                vm.chname =@"转交";
                vm.iszhuanJiao =YES;
                vm.content =[NSString stringWithFormat:@"%@转交给%@",!sm.passname?@"AA":sm.dealname,sm.passname];
                [_HeaderSectionArr addObject:vm];
                
                ShengPiCellVM *vm1 =[[ShengPiCellVM alloc]init];
                vm1.extendType =2;
                vm1.type =2;
                vm1.chname =@"转交理由";
                vm1.iszhuanJiao= YES;
                vm1.content =sm.content;
                vm1.cellHeight =[self cellheight:vm1.content withIsBody:NO];
                if (j==data.applyrecords.count-1) {
                    vm1.Subtype =2;
                    vm1.islast =YES;
                    vm1.isfirst =NO;
                }
                [_HeaderSectionArr addObject:vm1];
            }
            
            if (sm.status == 1 || sm.status == 2) {
                
                ShengPiCellVM *vm1 =[[ShengPiCellVM alloc]init];
                vm1.extendType =2;
                vm1.type =2;
                vm1.chname =@"审批理由";
                vm1.iszhuanJiao= NO;
                vm1.content =sm.content;
                vm1.cellHeight =[self cellheight:vm1.content withIsBody:NO];
                if (j==data.applyrecords.count-1) {
                    vm1.Subtype =2;
                    vm1.isfirst =NO;
                    vm1.islast =YES;
                }
                [_HeaderSectionArr addObject:vm1];
            }
        }
        
        for (int i=0; i<data.applyexts.count; i++) {
            ApplyDetailsSM*sm =[data.applyexts objectAtIndex:i];
            ShengPiCellVM *vm =[[ShengPiCellVM alloc]init];
            vm.extendType =2;
            vm.type =8888;
            if (sm.type ==2) {
                vm.istime =YES;
                vm.cellHeight = 45.f;
                vm.content = sm.content;
            }else{
                vm.istime =NO;
                vm.content =@"wqljr地区就忘记发了文件却为了家人来去忘记了几千万人理解起来我减肥卡勒季斯的罚款将阿萨德看来放假发";
                //sm.content;
                vm.cellHeight =[self cellheight:sm.content withIsBody:YES]+10;
            }
            
            if (i == data.applyexts.count-1) {
                vm.islast =YES;
            }else{
                vm.islast =NO;
            }
            vm.iszhuanJiao =NO;
            vm.title = sm.chname;
            [_dataArray addObject:vm];
        }
        [_mTableView reloadData];
    }
}

-(float)cellheight:(NSString *)str withIsBody:(BOOL)isBody{
    CGSize s;
    if (!isBody) {
        //section ==1
        s=[str calculateSize:CGSizeMake(ScreenWidth - 130, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
        if ((s.height+14) > 30.0) {
            return s.height+14;
        }
        return 30;
    }else{
        //NSLog(@"ff%@",str);
        //section ==2
        s=[str calculateSize:CGSizeMake(ScreenWidth-60, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
        if (s.height+24 >45.f) {
            return s.height+24.f;
        }
        return 45.f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 68.f;
    }else if (indexPath.section ==1){
        ShengPiCellVM *vm=[_HeaderSectionArr objectAtIndex:indexPath.row];
        if (vm.isSelected) {
            return 44.;
        }else{
            if (vm.isfirst) {
                return 30;
            }
            return [self cellheight:vm.content withIsBody:NO];
        }
    }else{
        ShengPiCellVM *vm=[_dataArray objectAtIndex:indexPath.row];
        if (vm.istime) {
            return [self cellheight:vm.content withIsBody:YES];
        }else{
            return [self cellheight:vm.content withIsBody:YES]+20;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_SecSectionArr.count&&_dataArray.count) {
        if (section ==0) {
            return 1;
        }else if (section ==1){
            ShengPiCellVM *vm =[_HeaderSectionArr objectAtIndex:0];
            if (vm.isSelected) {
                return 1;
            }
            return _HeaderSectionArr.count;
        }else{
            return _dataArray.count;
        }
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShengpiHeaderViewCell *headerCell =[ShengpiHeaderViewCell cellForTableview:tableView];
    if (indexPath.section==0) {
        if (_SecSectionArr.count) {
            headerCell.vm =[_SecSectionArr objectAtIndex:0];
        }
        return headerCell;
    }else if (indexPath.section ==1){
        ShengpiDetailViewCell *cellView =[ShengpiDetailViewCell cellForTableview:tableView];
        cellView.vm = [_HeaderSectionArr objectAtIndex:indexPath.row];
        return cellView;
    }else{
        BodyTableViewCell *cellView =[BodyTableViewCell  cellForTableview:tableView];
        cellView.vm = [_dataArray objectAtIndex:indexPath.row];
        return cellView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //左对齐
    UIEdgeInsets dd =UIEdgeInsetsMake(0, 0, 0, 0);
    //右对齐
    UIEdgeInsets subdd =UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
    //标准首缩进
    UIEdgeInsets bodyEdge =UIEdgeInsetsMake(0, 15, 0, 0);
    if (indexPath.section==0) {
        [self setedgeforCell:cell foredge:dd];
    }else if (indexPath.section==1){
        ShengPiCellVM *vm =[_HeaderSectionArr objectAtIndex:indexPath.row];
        if (vm.islast) {
            [self setedgeforCell:cell foredge:dd];
        }else{
            [self setedgeforCell:cell foredge:subdd];
        }
        
        if (vm.isSelected &&vm.isfirst) {
            [self setedgeforCell:cell foredge:dd];
        }
    }else{
        ShengPiCellVM *bodyVm =[_dataArray objectAtIndex:indexPath.row];
        if (bodyVm.islast) {
            [self setedgeforCell:cell foredge:dd];
        }else{
            [self setedgeforCell:cell foredge:bodyEdge];
        }
    }
}

-(void)setedgeforCell:(UITableViewCell *)cell foredge:(UIEdgeInsets )edge
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edge];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edge];
    }
}

- (void)shengpiVm:(ShengPiCellVM *)vm
{
    [_mTableView reloadData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zhuanjiaoFanhui{
    [self loadData];
    self.passValueFromShenpi(0);
}

- (IBAction)ButtonOnClick:(UIButton *)sender {
    if (sender ==_Pizhunbtn) {
        //批准
        KaiShiShengPiViewController *kaishi =[[KaiShiShengPiViewController alloc]init];
        kaishi.hidesBottomBarWhenPushed =YES;
        kaishi.isPass =1;
        kaishi.ID = _vm._ID;
        kaishi.applyid =_vm._ID;
        kaishi.passValueFromShengpi = ^(int start){
            [self loadData];
            self.passValueFromShenpi(start);
        };
        [self.navigationController pushViewController:kaishi animated:YES];
    }else if (sender ==_bupizhunBtn){
        //不批准
        KaiShiShengPiViewController *kaishi =[[KaiShiShengPiViewController alloc]init];
        kaishi.hidesBottomBarWhenPushed =YES;
        kaishi.ID = _vm._ID;
        kaishi.isPass =0;
        kaishi.applyid =_vm._ID;
        kaishi.passValueFromShengpi = ^(int start){
            [self loadData];
            self.passValueFromShenpi(start);
        };
        [self.navigationController pushViewController:kaishi animated:YES];
    }else if (sender ==_zhuanjianBtn){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
        //转交
        XuanzeRenyuanViewController *xuan =[[XuanzeRenyuanViewController alloc]init];
        xuan.endureArray = [@[[AppStore getYongHuID]]mutableCopy];
        xuan.shengpi =YES;
        xuan.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuan];
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        //删除
        [ServiceShell DeleteApplyWithApplyid:_vm._ID usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (!serviceContext.isSucceeded) {
                return ;
            }
            if (!model.status) {
                [self showHint:@"删除成功"];
                self.passValueFromShanchu(self.row);
            }else{
                [SDialog showTipViewWithText:@"申请已经通过, 不能进行操作" hideAfterSeconds:.5];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


#pragma @人员数据
- (void)RenyuanShuju:(NSNotification *)not{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    
    NSDictionary *dict = [not userInfo];
    NSMutableArray *array = [@[] mutableCopy];
    NSString *userid;
    for (XuanzeRenyuanModel *model in [dict objectForKey:@"xuanzhongArray"]) {
        [array addObject:model.personsSM.name];
        userid = model.personsSM.userid;
    }
    BianjiVC *vc =[[BianjiVC alloc]init];
    vc.ID = userid;
    vc.applyid =_vm._ID;
    vc.ispass = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)proviousPageMethod
{
    //上一个
    [ServiceShell getPreOrNextApplyWithUserid:[AppStore getYongHuID] Createtime:soureData.apply.createtime PrveOrNext:1 Type:qufenType Companyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfApplyDetailSM *detailSM) {
        if (serviceContext.isSucceeded && detailSM.status == 0) {
            if (![detailSM.msg isEqualToString:@"已经到头啦！"]) {
                [self updateDataForresults:detailSM.data];
            }else{
                [self showHint:@"已经到头啦!"];
            }
        }
    }];
    
}

-(void)nextPageMethod
{   //下一个
    [ServiceShell getPreOrNextApplyWithUserid:[AppStore getYongHuID] Createtime:soureData.apply.createtime PrveOrNext:0 Type:qufenType Companyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfApplyDetailSM *detailSM) {
        if (serviceContext.isSucceeded && detailSM.status == 0) {
            if (![detailSM.msg isEqualToString:@"已经到头啦！"]) {
                [self updateDataForresults:detailSM.data];
            }else{
                [self showHint:@"已经到尾啦!"];
            }
        }
    }];
}

//设置多于的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
@end
