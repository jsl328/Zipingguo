//
//  MyTiXingViewController.m
//  Zipingguo
//
//  Created by Apple on 15/10/23.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "MyTiXingViewController.h"
#import "CustomTableViewCell.h"


@interface MyTiXingViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *Titles;
    NSMutableArray *PunchSection;
    NSMutableArray *TextTime;
    NSMutableArray *ReportSection;
    NSMutableArray *Sections;
    NSIndexPath * clickedIdx;
    short gReminderStartTag;//00000000 00000111     从高位到低位分别为日报、下班，上班标志位
}
@end

@implementation MyTiXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gReminderStartTag=0;
    self.navigationItem.title = @"我的提醒";
    _tableview.dataSource = self;
    _tableview.delegate =self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorColor = Fenge_Color;
    PunchSection = [[NSMutableArray alloc] initWithObjects:@"打卡提醒", nil];
    ReportSection = [[NSMutableArray alloc] initWithObjects:@"工作报告提醒",nil];
    TextTime = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",nil];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    gReminderStartTag = [(NSNumber*)[defaults objectForKey:@"ReminderStartTag"] shortValue];
    NSString *dateStr = [[NSString alloc] init];

    if (gReminderStartTag&1 ||  gReminderStartTag&2) {//开启了上下班提醒
        [PunchSection addObject:@"上班打卡提醒"];
        [PunchSection addObject:@"下班打卡提醒"];
        if(gReminderStartTag&1){
            dateStr = [defaults objectForKey:@"onDutyTime"];
            if (dateStr.length != 0) {
                [TextTime replaceObjectAtIndex:0 withObject:[dateStr substringWithRange:NSMakeRange(11,5)]];
                [self scheduleReminder:dateStr ShowMsg:@"主银，要记得打卡哦" LookUp:@"onDutyTime"];
            }
        }
        if(gReminderStartTag&2){
            dateStr = [defaults objectForKey:@"offDutyTime"];
            if (dateStr.length != 0) {
                [TextTime replaceObjectAtIndex:1 withObject:[dateStr substringWithRange:NSMakeRange(11,5)]];
                [self scheduleReminder:dateStr ShowMsg:@"主银，可以打卡回家哦！" LookUp:@"offDutyTime"];
            }
        }
    }
    if(gReminderStartTag&4){//开启了工作日报提醒
        [ReportSection addObject:@"提醒时间"];
        if (dateStr.length != 0) {
            dateStr = [defaults objectForKey:@"reportTime"];
            [TextTime replaceObjectAtIndex:2 withObject:[dateStr substringWithRange:NSMakeRange(11,5)]];
            [self scheduleReminder:dateStr ShowMsg:@"主银，汇报工作哦！" LookUp:@"reportTime"];
        }
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.tableFooterView = footerView;

    Titles = [[NSMutableArray alloc] initWithObjects:@"打卡", @"工作报告", nil];
    Sections = [[NSMutableArray alloc] initWithObjects:PunchSection, ReportSection, nil];
    _datePickerView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    unsigned long d = [[Sections objectAtIndex:section] count];
//    NSLog(@"numberOfRowsInSection %lu \n",d);
    return [[Sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSLog(@"titleForHeaderInSection %lu \n",(long)section);
    return [Titles objectAtIndex:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 30.0)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0];
    headerLabel.font = [UIFont systemFontOfSize:11];
    headerLabel.frame = CGRectMake(15.0, 0.0, ScreenWidth, 30.0);
    headerLabel.text = [Titles objectAtIndex:section];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 0.01;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    NSLog(@"section=%ld,item=%ld",(long)indexPath.section,(long)indexPath.row);
    cell.labelText = [[Sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.row ==0) {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        switchview.onTintColor = RGBACOLOR(4, 175, 245, 1);
        switchview.tag = indexPath.section+111;
        if (indexPath.section == 0) {
            if (gReminderStartTag&1 ||  gReminderStartTag&2) {
                [switchview setOn:YES];
            }else{
                [switchview setOn:NO];
            }
        }else{
            if (gReminderStartTag&4) {
                [switchview setOn:YES];
            }else{
                [switchview setOn:NO];
            }
        }
        cell.accessoryView = switchview;
    }else{
        if (indexPath.section ==0 && indexPath.row ==1 && gReminderStartTag&1) {
            cell.labelTime = [TextTime objectAtIndex:0];
        }else if(indexPath.section ==0 && indexPath.row ==2 && gReminderStartTag&2){
            cell.labelTime = [TextTime objectAtIndex:1];
        }else if(indexPath.section ==1 && indexPath.row ==1 &&gReminderStartTag&4){
            cell.labelTime = [TextTime objectAtIndex:2];
        }
    }
    [cell layoutSubviews];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select=%ld,item=%ld",(long)indexPath.section,(long)indexPath.row);
    CustomTableViewCell *cell = [_tableview cellForRowAtIndexPath:indexPath];
    UISwitch *switchView = (UISwitch *)cell.accessoryView;
    if (switchView == nil) {
        [self showDatePicker];
        _datePickerView.hidden = NO;
        clickedIdx = indexPath;
    }
}

-(void)switchAction:(id)sender{
    UISwitch *switchview = (UISwitch*)sender;
    if (switchview.isOn) {
        if (switchview.tag == 111) {//section=0
            [PunchSection insertObject:@"上班打卡提醒" atIndex:1];
            gReminderStartTag |= 1;
            [_tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [PunchSection insertObject:@"下班打卡提醒" atIndex:2];
            [_tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            gReminderStartTag |= 2;
        }else{
            [ReportSection insertObject:@"提醒时间" atIndex:1];
            gReminderStartTag |= 4;
            [_tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
        }

    }else{
        if (switchview.tag ==111) {//section=0
            [self cancelReminder:@"offDutyTime"];
            [self cancelReminder:@"onDutyTime"];
            gReminderStartTag &= ~3;
            [PunchSection removeObjectAtIndex:1];
            [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationBottom];
            [PunchSection removeObjectAtIndex:1];
            [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationBottom];
        }else{
            [self cancelReminder:@"reportTime"];
            gReminderStartTag &= ~4;
            [ReportSection removeObjectAtIndex:1];
            [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]]
                              withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithShort:gReminderStartTag] forKey:@"ReminderStartTag"];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) scheduleReminder:(NSString*) strTime ShowMsg:(NSString*)description LookUp:(NSString*)key
{
    NSArray *localArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (localArray){
        for (UILocalNotification *noti in localArray){
            NSDictionary *dict = noti.userInfo;
            if (dict){
                NSString *inKey = [dict objectForKey:key];
                if ([inKey isEqualToString:key]){
                    [[UIApplication sharedApplication] cancelLocalNotification:noti];
                    break;
                }
            }
        }
    }

    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification == nil) return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    notification.fireDate= [formatter dateFromString:strTime];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval=NSDayCalendarUnit;
    notification.alertBody=description;
    notification.applicationIconBadgeNumber=1;
    notification.alertAction=@"打开应用";
    notification.alertLaunchImage=@"Default";
    notification.soundName = @"ring.caf";
    notification.userInfo = [NSDictionary dictionaryWithObject:key forKey:key];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void) cancelReminder:(NSString*)key
{
    NSArray *localArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (localArray){
        for (UILocalNotification *noti in localArray){
            NSDictionary *dict = noti.userInfo;
            if (dict){
                NSString *inKey = [dict objectForKey:key];
                if ([inKey isEqualToString:key]){
                    [[UIApplication sharedApplication] cancelLocalNotification:noti];
                    return;
                }
            }
        }
    }
}


- (IBAction)toolbarClicked:(id)sender {
    UIBarButtonItem *bar = (UIBarButtonItem *)sender;
    if([bar.title  isEqual: @"确定"]){
        NSDate *date = _datePicker.date;
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateStr = [fmt stringFromDate:date];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        if(clickedIdx.section==0 && clickedIdx.row==1){
            gReminderStartTag |= 1;
            [defaults setObject:dateStr forKey:@"onDutyTime"];
            [self scheduleReminder:dateStr ShowMsg:@"主银，要记得打卡哦" LookUp:@"onDutyTime"];
        }else if(clickedIdx.section==0 && clickedIdx.row==2){
            gReminderStartTag |= 2;
            [defaults setObject:dateStr forKey:@"offDutyTime"];
            [self scheduleReminder:dateStr ShowMsg:@"主银，可以打卡回家哦！" LookUp:@"offDutyTime"];
        }else if(clickedIdx.section==1 && clickedIdx.row==1){
            gReminderStartTag |= 4;
            [defaults setObject:dateStr forKey:@"reportTime"];
            [self scheduleReminder:dateStr ShowMsg:@"主银，汇报工作哦！" LookUp:@"reportTime"];
        }
        CustomTableViewCell *cell = [_tableview cellForRowAtIndexPath:clickedIdx];
        if(cell!=nil){
            cell.labelTime = [dateStr substringWithRange:NSMakeRange(11,5)];
            cell.Timelabel.text = [dateStr substringWithRange:NSMakeRange(11,5)];        }
        NSNumber *number =[NSNumber numberWithShort:gReminderStartTag];
        [defaults setObject:number forKey:@"ReminderStartTag"];
        [self endDatePicker];
    }else{
        [self endDatePicker];
    }
}

#pragma showDatePicker
- (void)showDatePicker{

    [UIView animateWithDuration:0.25
                     animations:^{
                         _datePickerView.frame = CGRectMake(0, ScreenHeight-200-NavHeight, ScreenWidth, 200);
                         
                         
                     } completion:nil];
    
}

#pragma endShowDatePicker
- (void)endDatePicker{
    [UIView animateWithDuration:0.25
                     animations:^{
                         _datePickerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
                         
                     } completion:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight);
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins:UIEdgeInsetsZero];
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



@end
