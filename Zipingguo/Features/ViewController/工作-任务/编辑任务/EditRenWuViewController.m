//
//  EditRenWuViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "EditRenWuViewController.h"
#import "XinJianRenWuModel.h"
#import "XinJianRenWuTableViewCell.h"
#import "XinJianRenWuTextViewCell.h"
#import "NSDate+Category.h"
#import "RenWuSheZhiViewController.h"
#import "TongxunluViewController.h"
#import "EditRenWuNameViewController.h"
#import "XuanzeRenyuanViewController.h"
#import "RenWuViewController.h"
#import "RenWuServiceShell.h"
#import "IQKeyboardManager.h"
//MH
#import "RenwuStores.h"
#import "RenwuLM.h"
@interface EditRenWuViewController ()<UITextViewDelegate,XinJianRenWuTextViewCellDelegate>
{
    NSMutableArray *dataArray;
    NSInteger currentTiXingIndex;
    NSInteger currentPerson;
    ChuangjianRenwuSM *param;
    RenwuLM*lm;
    
    NSMutableArray *fuzerenModel;
    NSMutableArray *canyurenModel;
    
}
@end

@implementation EditRenWuViewController
@synthesize detailSM;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 58)];
    view.backgroundColor = [UIColor clearColor];
    baseTableView.tableFooterView = view;
    
    fuzerenModel = [@[] mutableCopy];
    canyurenModel = [@[] mutableCopy];
    lm=[[RenwuLM alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self addItemWithTitle:@"完成" imageName:@"" selector:@selector(queDingButtonClick) location:NO];
    self.title = @"编辑";
    
    [baseTableView setSeparatorColor:Fenge_Color];
    if ([baseTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [baseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([baseTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [baseTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    param = [[ChuangjianRenwuSM alloc] init];
    dataArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSArray *titles = @[@"任务名称",@"负责人",@"参与人",@"截止日期",@"提醒",@"重要度",@"任务内容",@"备注"];
    
    NSString *import;
    if (detailSM.data.task.type == 1) {
        if (detailSM.data.task.importance==2)
            import = @"重要";
        else
            import = @"普通";
    }
    
    for (int i=0; i<titles.count; i++) {
        XinJianRenWuModel *model = [[XinJianRenWuModel alloc] init];
        model.isCanEdit = YES;
        if (i<6) {
            model.cellHeight = 44;
            model.cellTypeName = @"xinJianCell";
            NSMutableArray *leaders = [@[] mutableCopy];
            NSMutableArray *leaderids = [@[] mutableCopy];
            NSMutableArray *participants = [@[] mutableCopy];
            NSMutableArray *participantids = [@[] mutableCopy];
            NSString *desc;
            switch (i) {
                case 0:
                    desc = FeiKongPanDuanNSString(detailSM.data.task.title);
                    break;
                case 1:
                    
                    for (LeadersSM *leadersSM in detailSM.data.leaders) {
                        [leaders addObject:leadersSM.username];
                        [leaderids addObject:leadersSM.userid];
                    }
                    param.leaders = leaderids;
                    desc = [leaders componentsJoinedByString:@","];
                    break;
                case 2:
                    for (ParticipantsSM *participantSM in detailSM.data.participants) {
                        [participants addObject:participantSM.username];
                        [participantids addObject:participantSM.userid];
                    }
                    param.participants = participantids;
                    desc = [participants componentsJoinedByString:@","];
                    break;
                case 3:
                    desc = FeiKongPanDuanNSString(detailSM.data.task.endtime);
                    param.endtime = desc;
                    break;
                case 4:
                    desc = FeiKongPanDuanNSString(detailSM.data.task.remindmsg);
                    break;
                case 5:
                    desc = import;
                    break;
                default:
                    break;
            }
            model.cellValue = desc;
            
        }else{
            model.cellHeight = 200;
            if (i==6) {
                model.cellTypeName = @"xinJianNeiRong";
                model.cellValue = detailSM.data.task.content;
                param.content = model.cellValue;
            }else{
                model.cellTypeName = @"xinJianBeiZhu";
                model.cellValue = detailSM.data.task.memo;
                param.memo = model.cellValue;
            }
        }
        model.cellName = titles[i];
        model.tag = i;
        if (i!=5) {
            model.width = 15;
        }
        
        [dataArray addObject:model];
    }
    
    choseTimePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    [choseTimePickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置    为中文显示
    choseTimePickerView.locale = locale;
    choseTimePickerView.datePickerMode = UIDatePickerModeDateAndTime;
}

- (void)RenyuanShuju:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    NSArray *array = noti.userInfo[noti.name];
    NSMutableArray *mArray = [@[] mutableCopy];
    NSMutableArray *idsArray = [@[] mutableCopy];
    for (XuanzeRenyuanModel *m in array) {
        [mArray addObject:m.personsSM.name];
        [idsArray addObject:m.personsSM.userid];
    }
    XinJianRenWuModel *model = dataArray[currentPerson];
    model.cellValue = [mArray componentsJoinedByString:@"、"];
    [baseTableView reloadData];
    if (currentPerson==1) {
        param.leaders = idsArray;
        fuzerenModel = [noti.userInfo objectForKey:@"xuanzhongArray"];
    }else{
        param.participants = idsArray;
        canyurenModel = [noti.userInfo objectForKey:@"xuanzhongArray"];
    }
}



- (void)dateChanged:(UIDatePicker *)pickerView{
    if ([choseTimePickerView.date isInPast])
    {
        [choseTimePickerView setDate:[NSDate date]];
    }
}
- (void)queDingButtonClick{
    param.ID=detailSM.data.task.taskID;
    param.title = [dataArray[0] cellValue];
    if (![param.title length]) {
        [ToolBox Tanchujinggao:@"任务名称不能为空" IconName:nil];
        return;
    }
    if (!param.leaders.count) {
        [ToolBox Tanchujinggao:@"负责人不能为空" IconName:nil];
        return;
    }
    
    if (![param.endtime length]) {
        [ToolBox Tanchujinggao:@"请选择任务截止日期" IconName:nil];
        return;
    }
    if (![param.content length]) {
        [ToolBox Tanchujinggao:@"请输入任务内容" IconName:nil];
        return;
    }
    
    param.remindmsg = [dataArray[4]cellValue];
    if ([[dataArray[5]cellValue] isEqualToString:@"重要"])
        param.importance = 2;
    else
        param.importance = 1;
    param.companyid = [AppStore getGongsiID];
    param.type = 1;
    param.createid=[AppStore getYongHuID];

    [LDialog showWaitBox:@"编辑任务中"];
    [RenWuServiceShell updateTaskWithCreateid:param usingCallback:^(DCServiceContext*context,TaskBaseSM*sm){
        [LDialog closeWaitBox];
        if (context.isSucceeded && sm.status == 0) {
            if (_passValueFromXiugai) {
                self.passValueFromXiugai(param);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToolBox Tanchujinggao:@"修改失败" IconName:nil];
        }
    }];
}

- (void)textViewText:(NSString *)text tag:(NSInteger)tag{
    if (tag==1001) {
        NSLog(@"任务内容:%@",text);
        param.content = text;
    }else{
        NSLog(@"备注内容:%@",text);
        param.memo = text;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XinJianRenWuModel *model = dataArray[indexPath.row];
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    switch (model.tag) {
        case 0:// 任务名称
        {
            EditRenWuNameViewController *vc = [EditRenWuNameViewController alloc].init;
            vc.oldContent = model.cellValue;
            vc.isXinjian = YES;
            vc.editFinish = ^(NSString *content){
                model.cellValue = content;
                [baseTableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:case 2:
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
            XuanzeRenyuanViewController *vc = [[XuanzeRenyuanViewController alloc] init];
            currentPerson = indexPath.row;
            vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            if (currentPerson == 1) {
                vc.xuanzhongArray = fuzerenModel;
            }else{
                vc.xuanzhongArray = canyurenModel;
            }
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        case 3:// 日期选择
        {
            [self showRiQiView];
        }
            break;
        case 4:case 5:// 4任务提醒 5任务重要度
        {
            RenWuSheZhiViewController *vc = [[RenWuSheZhiViewController alloc] init];
            vc.vcTitle = model.cellName;
            vc.subTitle = ^(NSString *name){
                model.cellValue = name;
                [baseTableView reloadData];
            };
            vc.valueName = model.cellValue;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XinJianRenWuModel *model = dataArray[indexPath.row];
    static NSString *cellName;
    if ([model.cellTypeName isEqualToString:@"xinJianCell"]) {
        cellName = @"xinJianCell";
    }else if ([model.cellTypeName isEqualToString:@"xinJianNeiRong"]){
        cellName = @"xinJianNeiRong";
    }else{
        cellName = @"xinJianBeiZhu";
    }
    if ([model.cellTypeName isEqualToString:@"xinJianCell"]) {
        XinJianRenWuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[XinJianRenWuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        [cell bindDataWithModel:model];
        return cell;
    }else{
        XinJianRenWuTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[XinJianRenWuTextViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        cell.delegate = self;
        [cell bindDataWithModel:model];
        return cell;
    }
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XinJianRenWuModel *model = dataArray[indexPath.row];
    return model.cellHeight;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showRiQiView{/**<显示日期选择view*/
    XinJianRenWuModel *model = dataArray[3];
    [choseTimePickerView setDate:[model.cellValue formatterTime:model.cellValue]];
    [UIView animateWithDuration:0.5 animations:^{
        riQiView.center = CGPointMake(ScreenWidth/2, ScreenHeight-riQiView.frame.size.height/2-64);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenRiQiView{
    [UIView animateWithDuration:0.5 animations:^{
        riQiView.center = CGPointMake(ScreenWidth/2, ScreenHeight+riQiView.frame.size.height/2-64);
    } completion:^(BOOL finished) {
        maskView.hidden = YES;
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    riQiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, riQiView.frame.size.height);
    baseTableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}

// 日期选择View的按钮点击事件
- (IBAction)cancelItem:(id)sender {
    [self hiddenRiQiView];
}

- (IBAction)doneItem:(id)sender {
    [self hiddenRiQiView];
    NSDateFormatter *nsDF = [[NSDateFormatter alloc] init];
    [nsDF setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *time = [nsDF stringFromDate:choseTimePickerView.date];
    [nsDF setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    param.endtime = [nsDF stringFromDate:choseTimePickerView.date];
    if ([choseTimePickerView.date isInPast])
    {
        
    }
    XinJianRenWuModel *model = dataArray[3];
    model.cellValue = time;
    [baseTableView reloadData];
}
- (IBAction)delButtonClick:(id)sender {
    [RenWuServiceShell shanChuRenWuWithID:detailSM.data.task.taskID usingCallback:^(DCServiceContext *context, ResultMode *sm){
        if (context.isSucceeded && sm.status == 0) {
            [self showHint:@"该任务已成功删除" finishCallBack:^{
                NSArray *controllers =self.navigationController.viewControllers;
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.indexPath,@"indexPath",nil];
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"indexPath" object:nil userInfo:dict];
                for (int i = 0; i < controllers.count; i++) {
                    UIViewController *subController = [controllers objectAtIndex:i];
                    if ([subController isKindOfClass:[RenWuViewController class]]) {
                        [self.navigationController popToViewController:[controllers objectAtIndex:i] animated:YES];
                    }
                    
                }
            }];
        }else{
            [self showHint:@"删除失败"];
        }
    }];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInset];
    }
}

@end
