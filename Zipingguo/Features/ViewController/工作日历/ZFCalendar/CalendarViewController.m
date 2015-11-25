//
//  CalendarViewController.m
//  Calendar
//
//  Created by miao on 15-10-21.
//  Copyright (c) 2015年 miao. All rights reserved.
//




#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"
#import "RiliLIst.h"
#import "XinjianshijianVC.h"

#import "CalendarHomeViewController.h"
#import "RIliShall.h"

#import "RIliResultModelSM.h"

#import "RIlilistCellVM.h"

#import "RenWuDetailViewController.h"
@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,RIliDelegate,UIScrollViewDelegate,ShijianDelegate>
{
    
    //     NSTimer* timer;//定时器
    int gundong;
    
}
@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;
@property (nonatomic,weak)UIView *ToubuView;
@property (nonatomic,weak)RiliLIst *rililist;
@end
//#define CATDayLabelWidth  40.0f
#define CATDayLabelHeight 20.0f

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";
CGFloat CATDayLabelWidth;
int  section;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
        // Custom initialization
    }
    return self;
}
-(RiliLIst*)rililist
{
    if (!_rililist) {
        _rililist=[RiliLIst riliTableView];
        //        if (_rililist.shuju.count!=0) {
        //            NSLog(@"不添加");
        //        }
        [self.view addSubview:_rililist];
    }
    return _rililist;
}
- (void)viewDidLoad

{
    [super viewDidLoad];
    [self initView];
    //去除导航栏分隔线
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
    [self addItemWithTitle:@"" imageName:@"快捷操作+icon.png" selector:@selector(xinjian) location:NO];
    
    self.calendarMonthhongdian=[[NSMutableArray alloc]init];
    CGFloat with = [UIScreen mainScreen].bounds.size.width;
    [self loadData];
    if (with == 375 ) {
        CATDayLabelWidth=48.0;
    }else if (with == 414){
        CATDayLabelWidth=54.0;
    }else{
        CATDayLabelWidth=40.0;
    }
    gundong=0;
    _isguangdong=NO;
    
    [self addtouView];
    [self rililist];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delanniu)name:@"delanniu"object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ssshuidaojintian) name:@"huidaojintian" object:nil];
    
}

-(void)delanniu
{
    
    //  [self loadData];
    //  [_collectionView reloadData];
    //  [self.view removeAllSubviews];
    [self.collectionView removeAllSubviews];
    [self  viewDidLoad];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 -(void)DaohangaBtn
 {
 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
 
 UIBarButtonItem*xinjianBTn=[UIBarButtonItem itemWithTarget:self action:@selector(xinjian ) image:@"快捷操作+icon" highImage:@"快捷操作+icon-点击"];
 
 [xinjianBTn setTintColor:RGBACOLOR(69, 192, 197, 1)];
 [self.navigationItem setRightBarButtonItem:xinjianBTn];
 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]init];
 
 UIBarButtonItem*fanhui=[UIBarButtonItem itemWithTarget:self action:@selector(fanhui ) image:@"返回icon" highImage:@"返回icon点击"];
 
 [fanhui setTintColor:RGBACOLOR(69, 192, 197, 1)];
 [self.navigationItem setLeftBarButtonItem:fanhui];
 }
 */
//日历新建
-(void)xinjian
{
    XinjianshijianVC*shijianVC=[[XinjianshijianVC alloc]init];
    shijianVC.delegate=self;
    [self.navigationController pushViewController:shijianVC animated:YES];
}
-(void)shijianshuanxin
{
    [self.calendarMonthhongdian removeAllObjects];
    [self loadData];
    
}
-(void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setup{
    
    
    self.rililist.y = _collectionView.y+_collectionView.height+_ToubuView.y+_ToubuView.height;
    self.rililist.x = _collectionView.x;
    self.rililist.width = _collectionView.width;
    //    NSLog(@"%f",KScreen.height);
    self.rililist.delegate = self;
    self.rililist.height = self.view.height-_collectionView.height;
    self.rililist.riliTableView.height=120;
    if (ScreenWidth==375) {
        self.rililist.riliTableView.height= self.rililist.height-150;
    }else if (ScreenWidth==414){
        self.rililist.riliTableView.height=self.rililist.height-150;
    }else{
        
    }
    
    
}

//添加头标签
-(void)addtouView
{
    
    CGFloat xOffset = 5.0f;
    CGFloat yOffset = 0.0f;
    UIView*toubuView=[[UIView alloc]init];
    toubuView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CATDayLabelHeight);
    self.ToubuView=toubuView;
    self.ToubuView.backgroundColor=RGBACOLOR(53, 55, 68, 1);
    [self.view addSubview:self.ToubuView];
    //一，二，三，四，五，六，日
    UILabel *dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day1OfTheWeekLabel = dayOfTheWeekLabel;
    self.day1OfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.day1OfTheWeekLabel.textColor =RGBACOLOR(160, 160, 162, 1);
    [self.ToubuView addSubview:self.day1OfTheWeekLabel];
    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day2OfTheWeekLabel = dayOfTheWeekLabel;
    self.day2OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day2OfTheWeekLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    
    [self.ToubuView addSubview:self.day2OfTheWeekLabel];
    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day3OfTheWeekLabel = dayOfTheWeekLabel;
    self.day3OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day3OfTheWeekLabel.textColor =RGBACOLOR(160, 160, 162, 1);
    [self.ToubuView addSubview:self.day3OfTheWeekLabel];
    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day4OfTheWeekLabel = dayOfTheWeekLabel;
    self.day4OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day4OfTheWeekLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    [self.ToubuView addSubview:self.day4OfTheWeekLabel];
    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day5OfTheWeekLabel = dayOfTheWeekLabel;
    self.day5OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day5OfTheWeekLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    [self.ToubuView addSubview:self.day5OfTheWeekLabel];
    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day6OfTheWeekLabel = dayOfTheWeekLabel;
    self.day6OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day6OfTheWeekLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    
    [self.ToubuView addSubview:self.day6OfTheWeekLabel];
    
    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day7OfTheWeekLabel = dayOfTheWeekLabel;
    self.day7OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day7OfTheWeekLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    [self.ToubuView addSubview:self.day7OfTheWeekLabel];
    [self updateWithDayNames:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
    
}
//设置 @"日", @"一", @"二", @"三", @"四", @"五", @"六"
- (void)updateWithDayNames:(NSArray *)dayNames
{
    
    for (int i = 0 ; i < dayNames.count; i++) {
        switch (i) {
            case 0:
                self.day1OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 1:
                self.day2OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 2:
                self.day3OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 3:
                self.day4OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 4:
                self.day5OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 5:
                self.day6OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 6:
                self.day7OfTheWeekLabel.text = dayNames[i];
                break;
                
            default:
                break;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}


- (void)initView{
    
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout]; //初始化网格视图大小
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    // self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    self.collectionView.delegate = self;//实现网格视图的delegate
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.y=self.ToubuView.y+self.ToubuView.height+15;
    self.collectionView.width=self.view.width;
    if (ScreenWidth==375) {
        self.collectionView.height=self.view.height-350;
    }else if (ScreenWidth==414){
        self.collectionView.height=self.view.height-420;
    }else{
        self.collectionView.height=self.view.height-260;
    }
    
    self.collectionView.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0  blue:239/255.0  alpha:1];
    // self.collectionView.backgroundColor=[UIColor redColor];
    // self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    [self setup];
    
}



-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    
}

-(void)rilibianji:(RIlilistCellVM *)vm
{
    if (vm.isrenwu==1) {
        RenWuDetailViewController*renwuxiangqin=[[RenWuDetailViewController alloc]init];
        renwuxiangqin.isFinish = vm.isfinish;
        renwuxiangqin.isMyRenWu = YES;
        renwuxiangqin.renWuID=vm.ID;
        renwuxiangqin.finishRenWu = ^(NSString *renwuID){
            [self.collectionView removeAllSubviews];
            [self  viewDidLoad];
        };
        [self.navigationController pushViewController:renwuxiangqin animated:YES];
    }else{
        XinjianshijianVC*shijian=[[XinjianshijianVC alloc]init];
        shijian.ID=vm.ID;
        shijian.delegate=self;
        shijian.biaoti=vm.Name;
        shijian.beizhu=vm.beizhu;
        shijian.shijian=vm.endTime;
        shijian.tixingzhi=vm.Tingxingzhi;
        [self.navigationController pushViewController:shijian animated:YES];
        
    }
}

#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
    
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    for (rililistSM*sm  in _calendarMonthhongdian) {
        _year =[[NSString stringWithFormat:@"%@",[sm.time substringWithRange:NSMakeRange(0, 4)]]intValue];
        _month=[[NSString stringWithFormat:@"%@",[sm.time substringWithRange:NSMakeRange(5, 2)]]intValue];
        _day=[[NSString stringWithFormat:@"%@",[sm.time substringWithRange:NSMakeRange(8, 2)]]intValue];
        if (_year==model.year&&_month==model.month&&_day==model.day) {
            model.ishongdian=YES;
            NSLog(@"相同日期");
        }else{
            NSLog(@"没有获取到任务相同日期");
        }
    }
    cell.model = model;
    
    return cell;
    
}

//回到今天
-(void)huidaojintian
{
    gundong=1;
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    if (d.month == 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:-7 inSection:d.month] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        //         [self.rililist.jintbtn setTitle:@"今天" forState:  UIControlStateNormal];
        
    }else{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:-7 inSection:(d.month-1)] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        //        [self.rililist.jintbtn setTitle:@"今天" forState:  UIControlStateNormal];
        
    }
    
    
    //    self.isguangdong=NO;
    //            [self.rililist.jintbtn setTitle:@"今天" forState:  UIControlStateNormal];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];
        //头视图
        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        
        monthHeader.masterLabel.text = [NSString stringWithFormat:@" %lu月",(unsigned long)model.month];
        monthHeader.YearLabel.text=[NSString stringWithFormat:@"%lu ",(unsigned long)model.year];
        
        monthHeader.backgroundColor=RGBACOLOR(239, 239, 239,0.8);
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    //判断时间选择格式
    //    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick) {
    [self.Logic selectLogic:model];
    
    if (self.calendarblock) {
        
        self.calendarblock(model);//传递数组给上级
        [self DangqianriqiWith:model];
        //            timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    [self.collectionView reloadData];
    //    }
}
-(void)DangqianriqiWith:(CalendarDayModel*)vm
{
    NSLog(@"\n---------------------------");
    NSLog(@"1星期 %@",[vm getWeek]);
    NSLog(@"2字符串 %@",[vm toString]);
    NSLog(@"3节日  %@",vm.holiday);
    _rililist.xingqi.text=[vm getWeek];
    _rililist.nianyue.text=[vm Tonianyueri];
    if ([NSString stringWithFormat:@"%lu",(unsigned long)vm.day ].length==1) {
        _rililist.RI.text=[NSString stringWithFormat:@"0%lu",(unsigned long)vm.day];
    }else{
        _rililist.RI.text=[NSString stringWithFormat:@"%lu",(unsigned long)vm.day];
    }
    
    [self diliebiaoData];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
- (void)ssshuidaojintian{
    _isguangdong=NO;
}
//日历滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isguangdong==YES) {
        [self.rililist.jintbtn setTitle:@"回到今天" forState:  UIControlStateNormal];
        [self.rililist.jintbtn setTitleColor:[UIColor colorWithRed:4/255.0 green:175/255.0 blue:245/255.0 alpha:1] forState:UIControlStateNormal];
        self.rililist.jintbtn.userInteractionEnabled = YES;
    }else{
        [self.rililist.jintbtn setTitle:@"今天" forState:  UIControlStateNormal];
        [self.rililist.jintbtn setTitleColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:162/255.0 alpha:1] forState:UIControlStateNormal];
        self.rililist.jintbtn.userInteractionEnabled = NO;
        //        _isguangdong=YES;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isguangdong=YES;
    [self.rililist.jintbtn setTitle:@"回到今天" forState:  UIControlStateNormal];
    [self.rililist.jintbtn setTitleColor:[UIColor colorWithRed:4/255.0 green:175/255.0 blue:245/255.0 alpha:1] forState:UIControlStateNormal];
    self.rililist.jintbtn.userInteractionEnabled = YES;
}

-(void)loadData
{
    [_calendarMonthhongdian removeAllObjects];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSString*riqi=[NSString stringWithFormat:@"%ld-%0.2ld-%0.2ld", (long)dateComponent.year, (long)dateComponent.month,(long)dateComponent.day];
    if (_rililist.RI.text.length!=0) {
        
    }else{
        _rililist.RI.text=[NSString stringWithFormat:@"%@",[riqi substringWithRange:NSMakeRange(8, 2)]];
        _rililist.nianyue.text=[NSString stringWithFormat:@"%ld年%ld月", (long)dateComponent.year, (long)dateComponent.month];
        NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        NSInteger weekday = [componets weekday];
        if (weekday==1) {
            _rililist.xingqi.text=@"星期日";
        }else if (weekday==2){
            _rililist.xingqi.text=@"星期一";
        }else if (weekday==3){
            _rililist.xingqi.text=@"星期二";
        }else if (weekday==4){
            _rililist.xingqi.text=@"星期三";
        }else if (weekday==5){
            _rililist.xingqi.text=@"星期四";
        }else if (weekday==6){
            _rililist.xingqi.text=@"星期五";
        }else if (weekday==7){
            _rililist.xingqi.text=@"星期六";
        }
        
    }
    
    
    [RIliShall getThingOfDayWithID:[AppStore getYongHuID] usingCallback:^(DCServiceContext *Context, RIliResultModelSM *sm ) {
        
        if (Context.isSucceeded && sm.status == 0) {
            for (rililistSM*rilism in sm.data) {
                
                [_calendarMonthhongdian addObject:rilism];
            }
            [self diliebiaoData];
            [_collectionView reloadData];
            
        }
        
    }];
    
    
}
//底部列表
-(void)diliebiaoData
{
    NSMutableArray*shuju=[[NSMutableArray alloc]init];
    for(rililistSM*sm  in _calendarMonthhongdian) {
        for (memosSM*memos in sm.memos) {
            NSString*hao=[NSString stringWithFormat:@"%@",[memos.endtime substringWithRange:NSMakeRange(8, 2)]];
            if ([hao isEqualToString:_rililist.RI.text]) {
                RIlilistCellVM*VM=[[RIlilistCellVM alloc]init];
                VM.ID=memos.ID;
                VM.Name=memos.title;
                VM.beizhu=memos.content;
                VM.endTime=memos.endtime;
                VM.Tingxingzhi=[self panDuanIsNull:memos.remindmsg];
                if (![memos.remindmsg isEqualToString:@"不提醒"] && [self panDuanIsNull:memos.remindmsg].length != 0) {
                    VM.istixing=YES;
                }else{
                    VM.istixing=NO;
                }
                VM.shijian=[NSString stringWithFormat:@"%@",[memos.endtime substringWithRange:NSMakeRange(10, 6)]];
                VM.isrenwu=0;
                [shuju addObject: VM];
                
            }else{
                NSLog(@"没有");
            }
        }
        for (tasksSM*tasks in sm.tasks) {
            NSString*hao=[NSString stringWithFormat:@"%@",[tasks.endtime substringWithRange:NSMakeRange(8, 2)]];
            if ([hao isEqualToString:_rililist.RI.text]) {
                RIlilistCellVM*VM=[[RIlilistCellVM alloc]init];
                VM.ID=tasks.ID;
                VM.isrenwu=1;
                VM.Name=tasks.title;
                VM.Tingxingzhi=[self panDuanIsNull:tasks.remindmsg];
                VM.isfinish = tasks.isfinish;
                if (![tasks.remindmsg isEqualToString:@"不提醒"] && [self panDuanIsNull:tasks.remindmsg].length != 0) {
                    VM.istixing=YES;
                }else{
                    VM.istixing=NO;
                }
                VM.shijian=[NSString stringWithFormat:@"%@",[tasks.endtime substringWithRange:NSMakeRange(11, 5)]];
                
                [shuju addObject: VM];
                
            }else{
                NSLog(@"没有");
            }
        }
        _rililist.shuju=shuju;
    }
    
    
}

- (NSString *)panDuanIsNull:(id)text{
    if (text == nil || [text isEqual:[NSNull null]] || text == NULL) {
        return @"";
    }else{
        return text;
    }
}

@end
