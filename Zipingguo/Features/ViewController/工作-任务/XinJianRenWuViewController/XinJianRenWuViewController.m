//
//  XinJianRenWuViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "XinJianRenWuViewController.h"
#import "XinJianRenWuModel.h"
#import "XinJianRenWuTableViewCell.h"
#import "XinJianRenWuTextViewCell.h"
#import "NSDate+Category.h"
#import "RenWuSheZhiViewController.h"
#import "TongxunluViewController.h"
#import "EditRenWuNameViewController.h"
#import "XuanzeRenyuanViewController.h"

#import "RenWuServiceShell.h"
#import "IQKeyboardManager.h"
//MH
#import "RenwuStores.h"
#import "RenwuLM.h"
@interface XinJianRenWuViewController ()<UITextViewDelegate,XinJianRenWuTextViewCellDelegate>
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

@implementation XinJianRenWuViewController
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
    
    fuzerenModel = [@[] mutableCopy];
    canyurenModel = [@[] mutableCopy];
     lm=[[RenwuLM alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self addItemWithTitle:@"确定" imageName:@"" selector:@selector(queDingButtonClick) location:NO];
    self.title = @"新建任务";

    
    
    
    param = [[ChuangjianRenwuSM alloc] init];
    dataArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSArray *titles = @[@"任务名称",@"负责人",@"参与人",@"截止日期",@"提醒",@"重要度",@"任务内容",@"备注"];
    for (int i=0; i<titles.count; i++) {
        XinJianRenWuModel *model = [[XinJianRenWuModel alloc] init];
        model.isCanEdit = YES;
        if (i<6) {
            model.cellHeight = 44;
            model.cellTypeName = @"xinJianCell";
            if (i==4)
                model.cellValue = @"不提醒";// 默认
            if (i==5){
                model.cellValue = @"普通";// 默认
                param.importance = 1;
            }
        }else{
            model.cellHeight = 200;
            if (i==6) {
                model.cellTypeName = @"xinJianNeiRong";
            }else{
                model.cellTypeName = @"xinJianBeiZhu";
            }
        }
        if (i!=5) {
            model.width = 15;
        }
        model.cellName = titles[i];
        model.tag = i;
        [dataArray addObject:model];
    }

    
    [baseTableView setSeparatorColor:Fenge_Color];
    if ([baseTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [baseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([baseTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [baseTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    choseTimePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    [choseTimePickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置    为中文显示
    choseTimePickerView.locale = locale;
    choseTimePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    
    //负责人解档
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path=[documentPath stringByAppendingString:[@"/fuzeren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
    fuzerenModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self chuliDataArray:fuzerenModel isFuzeRen:YES isArchive:NO];
    
    //参与人解档
    NSString *path1 = [documentPath stringByAppendingString:[@"/canyuren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
    canyurenModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
    [self chuliDataArray:canyurenModel isFuzeRen:NO isArchive:NO];
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
        [self chuliDataArray:array isFuzeRen:YES isArchive:YES];
    }else{
        [self chuliDataArray:array isFuzeRen:NO isArchive:YES];
       
    }
}

// 日期选择View的按钮点击事件
- (IBAction)riQiQuViewButtonClick:(UIBarButtonItem *)sender {
    [self hiddenRiQiView];
    if ([sender.title isEqualToString:@"确定"]) {
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
}

- (void)dateChanged:(UIDatePicker *)pickerView{
    if ([choseTimePickerView.date isInPast])
    {
        [choseTimePickerView setDate:[NSDate date]];
    }
}
- (void)queDingButtonClick{
    NSString *UUID= DCUUIDMake();
    param.ID=UUID;
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
    [LDialog showWaitBox:@"新建任务中"];
    [RenWuServiceShell xinjianrenwuWithCreateid:param usingCallback:^(DCServiceContext*context,TaskBaseSM*sm){
        [LDialog closeWaitBox];
        if (context.isSucceeded) {
            if (_passValueFromXinjian) {
                self.passValueFromXinjian(param);
            }
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"创建任务上传成功");
           
           

        }else{
            
            NSLog(@"创建任务上传失败");
            //存数据库
            lm.ISshangchuan=1;
            lm.ID=UUID;
            [lm initWithSM:param];
            [lm save];
            [self.navigationController popViewControllerAnimated:YES];

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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
   
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInset];
    }
}
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
    [choseTimePickerView setDate:[NSDate date]];
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
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  数据处理
 *
 *  @param resultArray 数组
 *  @param isPiyueren  是否是负责人 no -- 参与人
 *  @param isArchive   是否需要归档，通知回来的要归档；解档完处理不用再归档
 */
- (void)chuliDataArray:(NSArray *)resultArray isFuzeRen:(BOOL)isFuzeren isArchive:(BOOL)isArchive{
    
    //取出名字放到数组里链接成字符串
    NSMutableArray *tempNameArray = [@[] mutableCopy];
    NSMutableArray *tempIDArray = [@[] mutableCopy];
    
    for (XuanzeRenyuanModel *model in resultArray) {
        [tempNameArray addObject:model.personsSM.name];
        [tempIDArray addObject:model.personsSM.userid];
    }
    NSString *tempNameStr = [tempNameArray componentsJoinedByString:@" "];
    
    if(isFuzeren){//批阅人
        if(isArchive){
            //归档负责人--- 拼接GongsiID
            //直接放在沙盒根目录在真机上不好使，改成放在document下

            //document
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path=[documentPath stringByAppendingString:[@"/fuzeren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
            
            
            BOOL success=[NSKeyedArchiver archiveRootObject:resultArray toFile:path];
            if (success) {
                NSLog(@"负责人归档成功");
            }
        }
        param.leaders = tempIDArray;
        XinJianRenWuModel *model = dataArray[1];
        model.cellValue = tempNameStr;
        [baseTableView reloadData];
        
        fuzerenModel = [resultArray mutableCopy];//负责人数组
        
    }else{//参与人
        if(isArchive){
            //归档参与人
            //document
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path=[documentPath stringByAppendingString:[@"/canyuren" stringByAppendingFormat:@"%@",[AppStore getGongsiID]]];
            
            BOOL success=[NSKeyedArchiver archiveRootObject:resultArray toFile:path];
            if (success) {
                NSLog(@"参与人归档成功");
            }
        }
         param.participants = tempIDArray;
        XinJianRenWuModel *model = dataArray[2];
        model.cellValue = tempNameStr;
        [baseTableView reloadData];
        
        canyurenModel = [resultArray mutableCopy];//参与人数组
    }
    
}


@end
