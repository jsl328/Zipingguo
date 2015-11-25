//
//  MutipleSlectFormViewController.m
//  Lvpingguo
//
//  Created by jiangshilin on 15/6/5.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import "MutipleSlectFormViewController.h"
#import "BianjiVC.h"
#import "UIViewController+DismissKeyboard.h"
#import "ApplyCcsSm.h"
#import "TextViewTableViewCell.h"
#import "XuanzeRenyuanModel.h"
#import "XuanzeRenyuanViewController.h"
#import "UIKeyboardCoView.h"
#import "LFDatePickerView.h"
#import "ShengpiLieBiaoViewController.h"
#import "ToolBox.h"
@interface MutipleSlectFormViewController ()
{
    BOOL isShengPI;
    NSString *Approl;
    NSString *chaosongStr;
    NSString *other;
    NSString *_zhengJianStr;
    NSMutableString *qingjiashiyouString;
    NSMutableArray *shengpirenArray;
    NSMutableArray *chaosongRenArray;
    
    NSMutableArray *shengpirenModelArray;
    NSMutableArray *chaosongRenModelArray;
    
    NSMutableArray *_contenArr;
    //_contenArr
    UIView *blackBackView;
    UIPickerView *_picker;
    UIBarButtonItem *confirm;
    NSInteger indexFlag;
    UITextField *_currentTextField;
    UIPlaceHolderTextView *palacerTextView;
    LFDatePickerView *_shijianView;
}
@end

@implementation MutipleSlectFormViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:palacerTextView];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
    [palacerTextView resignFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (_titleStr) {
        self.title = _titleStr;
        [self addItemWithTitle:@"确定" imageName:@"" selector:@selector(tijiaoshengpi) location:NO];
    }
    
    _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor =Fenge_Color;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    shengpirenModelArray = [@[] mutableCopy];
    chaosongRenModelArray = [@[] mutableCopy];
    dataSoure = [@[] mutableCopy];
    
    
    UISwipeGestureRecognizer *pes =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperOn)];
    pes.direction = UISwipeGestureRecognizerDirectionDown;
    [_tableView addGestureRecognizer:pes];
    
    //审批人数组
    shengpirenArray = [@[] mutableCopy];
    if (_transformModel.deaulfDealRenID) {
        [shengpirenArray addObject:_transformModel.deaulfDealRenID];
    }
    //抄送人数组
    chaosongRenArray=[@[] mutableCopy];
    if (_appcssArr.count) {
        chaosongRenArray = _appcssArr;
    }
    
    //
    qingjiashiyouString =[[NSMutableString alloc]init];
    _contenArr =[[NSMutableArray alloc]init];
    dealName = [_contentArray objectAtIndex:0];
    
    [self DownLoadData];
    [self Uiflag];
    [self initDateController];
}

-(void)Uiflag
{
    _shijianView  = [[LFDatePickerView alloc]init];
    //NSLog(@"高度%f",self.view.height);
    //NSLog(@"高度2%f",ScreenHeight);
    _shijianView.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 200);
    [self.view addSubview:_shijianView];
    
    __weak typeof(self)  weakSelf = self;
    __weak NSMutableArray * data = dataSoure;
    __weak UITableView * tableview = _tableView;
    [_shijianView setType:UIDatePickerModeDate confirmCallBack:^(NSDate *shijian) {
        if (shijian) {
            for (BiaoDanModel *model in data) {
                if (_shijianView.mDatePicker.tag ==model.indexFlag) {
                    //由于返回类型改变，用工具类转化nsdate为字符串
                    model.content = [ToolBox shijianStringWith:shijian isTime:NO];
                }
            }
        }
        [tableview reloadData];
        [weakSelf hiddenShijianView];
    } cancelCallBack:^{
        [weakSelf hiddenShijianView];
    }];
}

-(void)DownLoadData
{
    //创建dynanmicList 往单子里面填写数据操作
    [LDialog showWaitBox:@"获取表单中..."];
    if (_transformModel) {
        [ServiceShell getAllFlowWithflowid:_transformModel.ID usingCallback:^(DCServiceContext *context, ResultModelOfGetApplicationformSM *applicationasSM) {
            [LDialog closeWaitBox];
            if ([applicationasSM.data count]>0) {
                //赋值数据
                [self updateDataofTableview:applicationasSM];
            }else{
                [SDialog showTipViewWithText:@"没有定义相应的表单，请联系后台" hideAfterSeconds:1.5f];
            }
        }];
    }
}
-(void)updateDataofTableview:(ResultModelOfGetApplicationformSM *)sm
{
    [dataSoure removeAllObjects];
    for (int i=0; i<2; i++) {
        BiaoDanModel *model = [[BiaoDanModel alloc]init];
        if (i==0) {
            model.title =@"审批人";
            model.type = kshengPI;
            model.indexFlag= Origin+i;
            model.flowid = @"1";
            model.content =!_contenArr.count?@"":_contenArr[i];
            dealName = _contentArray[i];
        }else if (i==1){
            model.title =@"抄送人";
            model.type = kchaoSong;
            model.indexFlag = Origin+i;
            model.flowid =@"2";
            model.content = _contentArray[i];
        }
        [dataSoure addObject:model];
    }
    
    //分离出来数据
    NSMutableArray *flowidArr=[NSMutableArray array];
    NSMutableArray *temp =[NSMutableArray array];
    for (int j=0 ; j<sm.data.count;j++) {
        ApplicationformSM *am =[sm.data objectAtIndex:j];
        //
        self.applicationsArr =sm.data;
        BiaoDanModel *model= [[BiaoDanModel alloc]init];
        model.title = am.chname;
        model.content =!_contenArr.count?nil:_contentArray[j+2];
        model.flowid = am._id;
        model.indexFlag = NowType+j;
        [flowidArr addObject:am._id];
        if (am.type ==4||am.type==5) {
            //单选,多选择的数据源
            xuanzeArr = [am.strs componentsSeparatedByString:@","];
        }
        
        if (am.type  ==1) {
            model.type = ktextFiled;
        }else if (am.type  ==2){
            model.type = kDatePicker;
        }else if (am.type ==3){
            model.type = ktextView;
        }else if (am.type ==4){
            model.type = ksigleChoice;
        }else{
            model.type = kdoubleChoice;
        }
        [temp addObject:model];
    }

    [dataSoure addObjectsFromArray:temp];
    //描述为内容;
    _miaoshuStr = sm.data1;
    [self createFooterView];
    [_tableView reloadData];
    
    //审批人解档
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentPath stringByAppendingString:[@"/jslshengpiren" stringByAppendingFormat:@"%@%@",[AppStore getGongsiID],[AppStore getYongHuID]]];
    shengpirenModelArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self chuliDataArray:shengpirenModelArray isShengpiren:YES isArchive:NO];
    
    //抄送人解档
    NSString *path1 = [documentPath stringByAppendingString:[@"/jslchaosongren" stringByAppendingFormat:@"%@%@",[AppStore getGongsiID],[AppStore getYongHuID]]];
    chaosongRenModelArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
    [self chuliDataArray:chaosongRenModelArray isShengpiren:NO isArchive:NO];
}

-(void)createFooterView
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, [self sizetoMiaoshu:[NSString stringWithFormat:@"描述:%@",_miaoshuStr]]+20)];
    view.backgroundColor =[UIColor clearColor];
    
    NSString *str =[NSString stringWithFormat:@"描述:%@",_miaoshuStr];
    UILabel *miaoshiLabel =[[UILabel alloc]initWithFrame:CGRectMake(15,10, ScreenWidth-30,[self sizetoMiaoshu:str])];
    miaoshiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    miaoshiLabel.numberOfLines=0;
    miaoshiLabel.font =[UIFont systemFontOfSize:13.f];
    miaoshiLabel.textColor =[UIColor colorWithRed:140./255 green:140./255. blue:140./255. alpha:1];
    miaoshiLabel.text = str;
    [view addSubview:miaoshiLabel];
    
    _tableView.tableFooterView =view;
}

-(float)getHeightofTitleOrContentWithSize:(BiaoDanModel *)model
{
    CGSize TSize=[model.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.view.width-45.f, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize CCSize =[model.content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.view.width-45.f, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    float mutpleHeight=TSize.height+CCSize.height;
    if (model.type ==kchaoSong) {
        if (TSize.width<ScreenWidth-45.f) {
            if (mutpleHeight<=44.f) {
                return 44.f;
            }
            return mutpleHeight;
        }
    }else if (model.type ==ktextFiled ||model.type ==ktextView){
        return 150.f;
    }
    return 44.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView1
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView1 numberOfRowsInSection:(NSInteger)section
{
    return dataSoure.count;
}

-(CGFloat)tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj =[dataSoure objectAtIndex:indexPath.row];
    BiaoDanModel *ml=nil;
    if (indexPath.row <dataSoure.count) {
        //复用问题没有解决....
        if ([obj isKindOfClass:[BiaoDanModel class]]) {
            ml = (BiaoDanModel *)obj;
            return [self getHeightofTitleOrContentWithSize:ml];
        }
    }
    return 0.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [dataSoure objectAtIndex:indexPath.row];
    BiaoDanModel *ml=nil;

    BiaoDanViewCopy *cell =[BiaoDanViewCopy cellForTableview:tableView];
    TextViewTableViewCell *Textcell =[TextViewTableViewCell cellForTableview:tableView];
    
    //复用问题没有解决....
    if ([obj isKindOfClass:[BiaoDanModel class]]) {
        ml= (BiaoDanModel *)obj;
        if (ml.type == ktextFiled || ml.type ==ktextView) {
            palacerTextView = Textcell.shuruTextView;
            //Textcell.shuruTextView.delegate =self;
            Textcell.biaodanModel = ml;
            Textcell.biaodanModel.delegate =self;
            return Textcell;
        }else{
            cell.model =ml =(BiaoDanModel*)obj;
            cell.model.delegate =self;
            return cell;
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id obj = [dataSoure objectAtIndex:indexPath.row];
    BiaoDanModel *ml=nil;
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    
    if ([obj isKindOfClass:[BiaoDanModel class]]) {
        ml= (BiaoDanModel *)obj;
        [self biaodanWithModel:ml withIndex:ml.indexFlag];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)biaodanWithModel:(BiaoDanModel *)model withIndex:(NSInteger)index
{
    //NSLog(@"点击谁了");
//    if (model.type !=ktextFiled ||model.type !=ktextView){
//        [palacerTextView resignFirstResponder];
//    }

    if (model.type == kshengPI) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuanzeShenren:) name:@"xuanzhongArray" object:nil];
        //审批人
        XuanzeRenyuanViewController *xuan=[[XuanzeRenyuanViewController alloc]init];
        isShengPI =YES;
        xuan.shengpi = YES;
        xuan.endureArray = [@[[AppStore getYongHuID]]mutableCopy];
        xuan.xuanzhongArray = shengpirenModelArray;

        xuan.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuan];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (model.type == kchaoSong){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuanzeShenren:) name:@"xuanzhongArray" object:nil];
        //抄送
        XuanzeRenyuanViewController *xuan=[[XuanzeRenyuanViewController alloc]init];
        isShengPI =NO;
        xuan.chaosong = YES;
        xuan.endureArray = [@[[AppStore getYongHuID]]mutableCopy];
        xuan.xuanzhongArray = chaosongRenModelArray;
        
        xuan.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuan];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (model.type == kDatePicker){
        [self showShijianViewWithModel:model];
    }else if (model.type == ksigleChoice){
        //单选
        indexFlag = index;
        [self addTimeBlackWithHeight:_timeBackView.frame withModel:model withIndexPathRow:index];
    }else if (model.type == kdoubleChoice){
        indexFlag = index;
        //多选
        [self addTimeBlackWithHeight:_timeBackView.frame withModel:model withIndexPathRow:index];
    }else{
        //输入框
        if (palacerTextView) {
            [self reloadTableDataAndRemoveSuperView:NO];
        }
    }
}
#pragma mark -  选人delegate
//name
- (void)xuanzeShenren:(NSNotification *)noto{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    [self chuliDataArray:[noto.userInfo objectForKey:@"xuanzhongArray"] isShengpiren:isShengPI isArchive:YES];
    
//    NSDictionary *DictObject =noto.userInfo;
//    NSArray *obj =[DictObject objectForKey:@"xuanzhongArray"];
//    if (isShengPI) {
//        shengpirenModelArray = [DictObject objectForKey:@"xuanzhongArray"];
//        [shengpirenArray removeAllObjects];
//        if (obj.count) {
//            XuanzeRenyuanModel *vm = [obj objectAtIndex:0];
//            //审批人的名字
//            Approl = vm.personsSM.name;
//            [shengpirenArray addObject:vm.personsSM.userid];
//            for (BiaoDanModel *model in dataSoure) {
//                if (model.indexFlag == 500) {
//                    model.content =vm.personsSM.name;
//                    break;
//                }
//            }
//        }
//        
//    }else{
//        chaosongRenModelArray = [DictObject objectForKey:@"xuanzhongArray"];
//        [chaosongRenArray removeAllObjects];
//        if (obj.count) {
//            NSMutableArray *temp=[NSMutableArray array];
//            for (XuanzeRenyuanModel *model in obj) {
//                [chaosongRenArray addObject:model.personsSM.userid];
//                [temp addObject:model.personsSM.name];
//            }
//
//            //抄送人的名字
//            chaosongStr = [temp componentsJoinedByString:@","];
//            for (BiaoDanModel *model in dataSoure) {
//                if (model.indexFlag == 501) {
//                    model.content =chaosongStr;
//                    break;
//                }
//            }
//        }
//    }
//    //刷新数据
//    [self reloadTableDataAndRemoveSuperView:YES];
//    [_tableView reloadData];
}

-(void)reloadTableDataAndRemoveSuperView:(BOOL)flag
{
    //取消blackView
    [_timeBackView removeFromSuperview];
    if ([_tableView respondsToSelector:@selector(reloadData)]) {
        if (flag) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

-(void)tijiaoshengpi{
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    if (palacerTextView) {
        [palacerTextView resignFirstResponder];
    }
    
    CreateApplySM *apply = [[CreateApplySM alloc] init];
    //    apply.dealname
    apply.createid = [AppStore getYongHuID];
    apply.createname =[AppStore getYongHuMing].length?[AppStore getYongHuMing]:@"佟大为";
    
    apply.flowid = self.flowid;
    
    apply.flowname = self.titleStr;
    apply.companyid = [AppStore getGongsiID];
    if (!shengpirenArray.count) {
        [LDialog showMessage:@"审批人不能为空"];
        return;
    }else{
        apply.dealid = [shengpirenArray firstObject];
    }
    apply.ccs = chaosongRenArray;
    
    //NSLog(@"chaosong=%d",chaosongRenArray.count);
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *shuru =[[NSMutableArray alloc]init];
    //BOOL isRet =NO;
    for (int i = 2;i< dataSoure.count;i++) {
        BiaoDanModel *model = [dataSoure objectAtIndex:i];
        //NSLog(@"typ,,,,%d",model.type);
        [shuru addObject:model];
    }
    //
    for (BiaoDanModel *ml in shuru) {
        for (int i=0; i<self.applicationsArr.count; i++) {
            ApplicationformSM *model = [self.applicationsArr objectAtIndex:i];
            MapsSM *ms=[[MapsSM alloc]init];
            ms.chname = model.chname;
            ms.sort = model.sort;
            ms.type = model.type;
            if ([ml.flowid isEqualToString:model._id]) {
                //NSLog(@"-----=====%@",ml.content);
                ms.content = ml.content;
                [arr addObject:ms];
                break;
            }
        }
    }
    //
    BOOL ret = NO;
    for (MapsSM *sm in arr) {
        if (sm.content.length==0) {
            ret =YES;
            break;
        }
    }
    
    apply.applyexts = arr;
    if (!ret) {
        [LDialog showWaitBox:@"提交审批中"];
        [ServiceShell getApplyListWithCreateApply:apply usingCallback:^(DCServiceContext *serviceContext, ResultMode *result){
            if (!result.status||serviceContext.httpCode== 200 ) {
                [LDialog closeWaitBox];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ShengpiLieBiaoViewController class]]) {
                        
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"fabiaoShengpiFanhui" object:nil];
                        
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
        }];
    }else{
        [SDialog showTipViewWithText:@"该表单只有抄送人可以为空" hideAfterSeconds:1.5f];
    }
    [palacerTextView resignFirstResponder];
}

//添加时间选择器
-(void)addTimeBlackWithHeight:(CGRect)radomRect withModel:(BiaoDanModel *)model withIndexPathRow:(NSInteger )rowIndex
{
    if (palacerTextView) {
        [palacerTextView resignFirstResponder];
    }
    _timeBackView.frame = radomRect;
    [self.view addSubview:_timeBackView];
    confirm.tag = model.indexFlag;
    
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:model.indexFlag-NowType+2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//取消backView
- (void)CancleClicked
{
    [_timeBackView removeFromSuperview];
    [blackBackView removeFromSuperview];
    [palacerTextView resignFirstResponder];
}

#pragma mark pickerview function

/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return xuanzeArr.count;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [xuanzeArr objectAtIndex:row];
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // NSLog(@"font %@ is selected.",row);
    if (row==-1) {
        _zhengJianStr =[xuanzeArr objectAtIndex:[_picker selectedRowInComponent:row]];
    }else{
        _zhengJianStr = [xuanzeArr objectAtIndex:row];
    }
}
#pragma mark - UItextViewDelegate

-(CGFloat)sizetoMiaoshu:(NSString *)miaoshu
{
    CGSize ze =[_miaoshuStr sizeWithFont:[UIFont systemFontOfSize:13.f] constrainedToSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return ze.height;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeTodRact];
}
-(void)sizeTodRact
{
    _tableView.frame = CGRectMake(0,0,ScreenWidth, ScreenHeight+_tableView.tableFooterView.height);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:palacerTextView];
    [palacerTextView resignFirstResponder];
    [_datePicker removeFromSuperview];
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

#pragma mark - 收键盘
-(void)shoujianpan{
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}

-(BOOL)textViewShouldBeginEditing:(UIPlaceHolderTextView *)textView
{
    //NSLog(@"dd%@",textView.placeholder);
    return YES;
}

-(void)textViewDidBeginEditing:(UIPlaceHolderTextView *)textView
{
    palacerTextView = (UIPlaceHolderTextView *)textView;
}
-(void)textViewDidEndEditing:(UIPlaceHolderTextView *)textView
{
    if (palacerTextView.text.length) {
        for (BiaoDanModel *bm in dataSoure) {
            if (bm.indexFlag == palacerTextView.tag) {
                bm.content = textView.text;
            }
        }
    }else{
        palacerTextView.placeholder =textView.placeholder;
    }
    [_tableView reloadData];
}

#pragma mark - 选择时间View
//显示时间选择View
-(void)showShijianViewWithModel:(BiaoDanModel *)model{
    _shijianView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _shijianView.frame = CGRectMake(0, self.view.height - 200, ScreenWidth, 200);
        _shijianView.mDatePicker.tag =model.indexFlag;
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:model.indexFlag-NowType+2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
}
//隐藏时间选择view
-(void)hiddenShijianView{
    [UIView animateWithDuration:0.5 animations:^{
//        [_tableView reloadData];
//        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        _shijianView.frame = CGRectMake(0, self.view.height, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        _shijianView.hidden = YES;
    }];
}

#pragma mark -datePicker
//时间控件
- (void)initDateController
{
    float fHeight = [[UIScreen mainScreen]bounds].size.height;
    float fWidht = [[UIScreen mainScreen]bounds].size.width;
    float datePickerHeight = 200;
    float padding =44;
    if (IOSDEVICE) {
        padding =64;
    }
    
    _timeBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fWidht, fHeight)];
    _timeBackView.backgroundColor = [UIColor clearColor];
    
    UIControl *controller = [[UIControl alloc]initWithFrame:_timeBackView.bounds];
    [controller addTarget:self action:@selector(controllerViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [_timeBackView addSubview:controller];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, fHeight-200, fWidht, 240)];
    view.backgroundColor = [UIColor whiteColor];
    [_timeBackView addSubview:view];
    
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40, fWidht, datePickerHeight)];
    _picker.delegate=self;
    _picker.dataSource = self;
    _picker.backgroundColor =[UIColor clearColor];
    [view addSubview:_picker];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *leftItemButton =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(CancleClicked)];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    confirm =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(ConfirmClicked:)];
    //confirm.tag = timeConfirm1;
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:leftItemButton,btnSpace,confirm,nil];
    [topView setItems:buttonsArray];
    [view addSubview:topView];
}
- (void)controllerViewClicked
{
    [_timeBackView removeFromSuperview];
}

- (void)ConfirmClicked:(UIBarButtonItem*)btn
{
    [_timeBackView removeFromSuperview];
    [_contenArr addObjectsFromArray:xuanzeArr];
    if (_zhengJianStr.length ==0 &&!_zhengJianStr) {
        NSInteger row= [_picker selectedRowInComponent:0];
        _zhengJianStr=[xuanzeArr objectAtIndex:row];
    }
    //确定按钮的事件触发....
    for (BiaoDanModel *model in dataSoure) {
        if (model.indexFlag ==btn.tag) {
            model.content = _zhengJianStr;
        }
    }
    [_tableView reloadData];
}

-(void)swiperOn
{
    if (palacerTextView) {
        [palacerTextView resignFirstResponder];
    }
}

/**
 *  数据处理
 *  @param resultArray 数组
 *  @param isShengpiRen  是否是审批人 no -- 抄送人
 *  @param isArchive   是否需要归档，通知回来的要归档；解档完处理不用再归档
 */
- (void)chuliDataArray:(NSArray *)resultArray isShengpiren:(BOOL)isShengpiren isArchive:(BOOL)isArchive{
    
    //取出名字放到数组里链接成字符串
    NSMutableArray *tempNameArray = [@[] mutableCopy];
    NSMutableArray *tempIDArray = [@[] mutableCopy];
    
    for (XuanzeRenyuanModel *model in resultArray) {
        [tempNameArray addObject:model.personsSM.name];
        [tempIDArray addObject:model.personsSM.userid];
    }
    NSString *tempNameStr = [tempNameArray componentsJoinedByString:@" "];
    
    if(isShengpiren){
        //审批人
        [shengpirenArray removeAllObjects];
        if(isArchive){
            //归档批阅人--- 拼接GongsiID
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path=[documentPath stringByAppendingPathComponent:[@"jslshengpiren" stringByAppendingFormat:@"%@%@",[AppStore getGongsiID],[AppStore getYongHuID]]];
            BOOL success=[NSKeyedArchiver archiveRootObject:resultArray toFile:path];
            if (success) {
                NSLog(@"审批人归档成功");
            }
        }
        shengpirenModelArray = [resultArray mutableCopy];//批阅人数组
        shengpirenArray = tempIDArray;//需要上传的批阅人id数组
        Approl = tempNameArray.count?[tempNameArray objectAtIndex:0]:@"";
        for (BiaoDanModel *model in dataSoure) {
            if (model.indexFlag == 500) {

                model.content =tempNameArray.count?[tempNameArray objectAtIndex:0]:@"";

                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.indexFlag-Origin inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    }else{
        //抄送人
        [chaosongRenArray removeAllObjects];
        if(isArchive){
            //归档抄送人
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path=[documentPath stringByAppendingPathComponent:[@"jslchaosongren" stringByAppendingFormat:@"%@%@",[AppStore getGongsiID],[AppStore getYongHuID]]];
            BOOL success=[NSKeyedArchiver archiveRootObject:resultArray toFile:path];
            if (success) {
                NSLog(@"抄送人归档成功");
            }
        }
        chaosongRenModelArray = [resultArray mutableCopy];//抄送人数组
        chaosongRenArray = tempIDArray;//需要上传的抄送人id数组
        chaosongStr = tempNameStr;
        for (BiaoDanModel *model in dataSoure) {
            if (model.indexFlag == 501) {
                model.content =tempNameStr;
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.indexFlag-Origin inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    }
}
@end
