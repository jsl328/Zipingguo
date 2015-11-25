//
//  RenWuDetailViewController.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuDetailViewController.h"
#import "RenWuDetailTopView.h"
#import "RenWuPingLunTableViewCell.h"
#import "RenWuPingLunModel.h"
#import "UIView+Extensions.h"
#import "XinJianRenWuModel.h"
#import "XinJianRenWuTableViewCell.h"
#import "RenWuContentCell.h"
#import "EditRenWuNameViewController.h"
#import "XuanzeRenyuanViewController.h"
#import "XuanzeRenyuanModel.h"
#import "DeptPersonsSM.h"
#import "NSDate+Category.h"
#import "RenWuSheZhiViewController.h"
#import "RenWuServiceShell.h"
#import "IQKeyboardManager.h"
#import "EditRenWuViewController.h"

@interface RenWuDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UIButton *sendButton;
    NSMutableArray *dataArray;
    NSInteger currentPerson;
    UIView *headerView;
    float oldOffset_y;
    float newOffset_y;
    BOOL cellIsSelected;
    NSMutableArray *aiTeArray;/**<被@的人员数组*/
    RenWuDetailSM *taskSM;
    NSString *topparid;// 顶级评论id
    NSString *isreplyid;// 评论id
    
    NSString *YaoqingRenName;
    
    RenWuPingLunModel *renwuPinglunModel;
}
@end

@implementation RenWuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"任务详情";
    [self setNavRightButton];
    [baseTableView setSeparatorColor:Fenge_Color];
    if ([baseTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [baseTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([baseTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [baseTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    riQiView.hidden = YES;
    [self registerForKeyboardNotifications];
    aiTeArray = [[NSMutableArray alloc] init];
    isreplyid = @"";
    topparid = @"";
    choseTimePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    [choseTimePickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置    为中文显示
    choseTimePickerView.locale = locale;
    choseTimePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self loadRenWuDetailData];
    
}
// 加载任务详情
- (void)loadRenWuDetailData{
    dataArray = [[NSMutableArray alloc]init];
    [LDialog showWaitBox:@"数据加载中"];
    [RenWuServiceShell getRenWuDetailWithID:self.renWuID createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *context, RenWuDetailSM *sm) {
        [LDialog closeWaitBox];
        if (context.isSucceeded && sm.status == 0) {
            taskSM = sm;
            TaskSM *task = sm.data.task;
            NSString *import;
            if (task.type == 1) {
                if (task.importance==2)
                    import = @"重要";
                else
                    import = @"普通";
            }
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:6];
            NSArray *titles = @[@"任务名称",@"负责人",@"参与人",@"截止日期",@"提醒",@"重要度"];
            for (int i=0; i<titles.count; i++) {
                XinJianRenWuModel *model = [[XinJianRenWuModel alloc] init];
                model.cellHeight = 44;
                model.cellName = titles[i];
                model.tag = i;
                if (i!=5) {
                    model.width = 15;
                }
                
                if (!self.tongzhiRili) {
                    if (self.isMyRenWu && !self.isFinish) {
                        if (i==3||i==4) {
                            model.isCanEdit = YES;
                        }else{
                            model.isCanEdit = NO;
                        }
                    }
                }

                
                NSMutableArray *leaders = [@[] mutableCopy];
                NSMutableArray *participants = [@[] mutableCopy];
                NSString *desc;
                switch (i) {
                    case 0:
                        desc = FeiKongPanDuanNSString(task.title);
                        break;
                    case 1:
          
                        for (LeadersSM *leadersSM in sm.data.leaders) {
                            [leaders addObject:leadersSM.username];
                        }
                        
                        desc = [leaders componentsJoinedByString:@","];
                        break;
                    case 2:
                        for (ParticipantsSM *participantSM in sm.data.participants) {
                            [participants addObject:participantSM.username];
                        }
                        
                        desc = [participants componentsJoinedByString:@","];
                        break;
                    case 3:
                        desc = FeiKongPanDuanNSString(task.endtime);
                        break;
                    case 4:
                        desc = FeiKongPanDuanNSString(task.remindmsg);
                        break;
                    case 5:
                        desc = import;
                        break;
                    default:
                        break;
                }
                model.cellValue = desc;
                [mArray addObject:model];
            }
            
            XinJianRenWuModel *model = [[XinJianRenWuModel alloc] init];
            model.cellTypeName = @"neiRong";
            model.taskContent = task.content;
            model.remark = task.memo;
            model.cellHeight = 134;
            model.tag = 6;
            [mArray addObject:model];
            NSMutableArray *pingLuArray = [[NSMutableArray alloc] init];
            for (TaskcommentsSM *comment in sm.data.taskcomments) {
                RenWuPingLunModel *pingLun = [[RenWuPingLunModel alloc] init];
                pingLun.bName = comment.relusername;
                pingLun.pingLunPersonName = comment.createname;
                pingLun.personID = comment.createid;
                pingLun.headerUrl = [URLKEY stringByAppendingString:comment.createimg];
                pingLun.content = comment.content;
                pingLun.time = comment.createtime;
                pingLun.commentsID = comment.commentsID;
                pingLun.isreply = comment.isreply;
                pingLun.topparid = comment.topparid;
                [pingLuArray addObject:pingLun];
            }
            if (pingLuArray.count==0) {
                [dataArray addObject:mArray];
            }else{
                [dataArray addObject:mArray];
                [dataArray addObject:pingLuArray];

            }
            [baseTableView reloadData];
        }else{
            [ToolBox Tanchujinggao:sm.msg IconName:nil];
        }
    }];
}

- (void)RenyuanShuju:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    NSArray *tempArray = [noti.userInfo[noti.name] copy];
    NSMutableArray *mArray = [@[] mutableCopy];
    if (currentPerson==-1) {
        [aiTeArray removeAllObjects];
    }
    for (XuanzeRenyuanModel *m in tempArray) {
        [mArray addObject:m.personsSM.name];
        [aiTeArray addObject:m.personsSM.userid];
    }
    if (currentPerson==-1) {
        if (mArray.count != 0) {
            [messageTF becomeFirstResponder];
            
            NSString *wenzi =  [messageTF.text substringFromIndex:YaoqingRenName.length];
            
            YaoqingRenName = [NSString stringWithFormat:@"@%@ ",[mArray componentsJoinedByString:@" @"]];
            messageTF.text = [YaoqingRenName stringByAppendingString:wenzi];
            
            [sendButton setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
            sendButton.userInteractionEnabled = YES;
        }
    }else{
        
        [RenWuServiceShell upDateRenWuCanYuPersonWithTaskid:self.renWuID Type:(int)currentPerson IDS:[aiTeArray componentsJoinedByString:@","] usingCallback:^(DCServiceContext *context, ResultMode *sm) {
            if (context.isSucceeded && sm.status == 0) {
                XinJianRenWuModel *model = dataArray[0][currentPerson];
                model.cellValue = [mArray componentsJoinedByString:@"、"];
                [baseTableView reloadData];
                [self showHint:sm.msg];
            }else{
                [self showHint:@"修改失败"];
            }
        }];
        
        
    }
}
// @按钮点击事件
- (IBAction)messageClick:(UIButton *)sender {
    NSLog(@"@xxx");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
    XuanzeRenyuanViewController *vc = [[XuanzeRenyuanViewController alloc] init];
    currentPerson = -1;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([textView.text quKongGe].length == 0) {//去掉空格回车后的字符串
            textView.text = @"";
            return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }else{
            NSLog(@"发送");
            [self sendMessage];
            return NO;
        }
    }
    return YES;
}
- (IBAction)sendMessageClick:(UIButton *)sender {
    NSLog(@"发送");
    [self sendMessage];
}
- (void)sendMessage{
    if (![messageTF.text length]) {
        [SDialog showTipViewWithText:@"发送内容不能为空" hideAfterSeconds:1];
        return;
    }
    if (aiTeArray.count==0) {
        [aiTeArray addObject:[AppStore getYongHuID]];
        isreplyid = @"";
    }
    [RenWuServiceShell renWuPingLunWithcreateid:[AppStore getYongHuID] content:messageTF.text taskid:self.renWuID isreply:FeiKongPanDuanNSString(isreplyid) topparid:FeiKongPanDuanNSString(topparid) IDS:[aiTeArray componentsJoinedByString:@","] usingCallback:^(DCServiceContext *context, RenWuPingLunSM *sm) {
        if (context.isSucceeded && sm.status == 0) {
            [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1 finishCallBack:^{
                isreplyid = @"";
                topparid = @"";
                [aiTeArray removeAllObjects];
                [messageTF resignFirstResponder];
                messageTF.text = nil;
                [sendButton setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
                sendButton.userInteractionEnabled = NO;
                RenWuPingLunModel *pingLun = [[RenWuPingLunModel alloc] init];
                pingLun.bName = sm.data.relusername;
                pingLun.pingLunPersonName = sm.data.createname;
                pingLun.personID = sm.data.createid;
                pingLun.headerUrl = [URLKEY stringByAppendingString:sm.data.createimg];
                pingLun.content = sm.data.content;
                pingLun.time = sm.data.createtime;
                pingLun.commentsID = sm.data.id;
                pingLun.isreply = sm.data.isreply;
                pingLun.topparid = sm.data.topparid;
                if (dataArray.count==2) {
                    NSMutableArray *tempArray = [dataArray lastObject];
                    [tempArray insertObject:pingLun atIndex:0];
                }else{
                    NSMutableArray *tempArray = [NSMutableArray arrayWithObject:pingLun];
                    [dataArray addObject:tempArray];
                }
                [baseTableView reloadData];
            }];
        }else{
            [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1];
        }
    }];
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]) {
        [sendButton setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = YES;
    }else{
        [sendButton setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = NO;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    if (indexPath.section==0) {
        if (indexPath.row < [dataArray[indexPath.section] count]-2) {
            edgeInset = UIEdgeInsetsMake(0, 15, 0, 0);;
        }
    }else{
        if (indexPath.row < [dataArray[indexPath.section] count]-1) {
            edgeInset = UIEdgeInsetsMake(0, 15, 0, 0);;
        }
    }
   
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInset];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 如果有键盘，先取消键盘
    if (messageTF.isFirstResponder) {
        [messageTF resignFirstResponder];
        [tableView setContentOffset:CGPointMake(0, oldOffset_y) animated:YES];
        cellIsSelected = NO;
        return;
    }
    
    if (!riQiView.hidden) {
        [self hiddenRiQiView];
        return;
    }

    
    if (indexPath.section==1) {
        
        RenWuPingLunModel *model = dataArray[indexPath.section][indexPath.row];
        if ([model.personID isEqualToString:[AppStore getYongHuID]]) {
            renwuPinglunModel = model;
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            action.actionSheetStyle =UIActionSheetStyleDefault;
            [action showInView:self.view];
        }else{
            [aiTeArray removeAllObjects];
            [aiTeArray addObject:model.personID];
            isreplyid = model.commentsID;
            topparid = model.topparid;
            if (![model.personID isEqualToString:[AppStore getYongHuID]])
                messageTF.placeholder = [NSString stringWithFormat:@"回复 %@",model.pingLunPersonName];
            float zongHeight = 0.0;
            for (XinJianRenWuModel *m in dataArray[0]) {
                zongHeight += m.cellHeight;
            }
            for (int i = 0; i<=indexPath.row; i++) {
                RenWuPingLunModel *m = dataArray[1][i];
                zongHeight += m.cellHeight;
            }
            oldOffset_y = tableView.contentOffset.y;
            newOffset_y = zongHeight+headerView.height;
            cellIsSelected = YES;
            [messageTF becomeFirstResponder];
        }
    }else{
        if (![dataArray[indexPath.section][indexPath.row] isCanEdit]) {
            return;
        }
        switch (indexPath.row) {
            case 3:// 日期选择
            {
                [self showRiQiView];
            }
                break;
            case 4:// 任务提醒
            {
                XinJianRenWuModel *model = dataArray[indexPath.section][indexPath.row];
                RenWuSheZhiViewController *vc = [[RenWuSheZhiViewController alloc] init];
                vc.vcTitle = model.cellName;
                vc.renWuID = self.renWuID;
                vc.subTitle = ^(NSString *name){
                    
                    [RenWuServiceShell upDateRenWuValueWithColumn:RenWuColumn_RemindMsg value:name id:self.renWuID createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *context, ResultMode *sm) {
                        if (context.isSucceeded && sm.status == 0) {
                            model.cellValue = name;
                            [baseTableView reloadData];
                            if (self.updataRenWu) {
                                self.updataRenWu(self.renWuID);
                            }
                            [self showHint:sm.msg];
                        }else{
                            [self showHint:@"修改失败"];
                        }
                    }];
                };
                vc.valueName = model.cellValue;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;

        }
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1) {
        RenWuPingLunTableViewCell *cell = [RenWuPingLunTableViewCell cellWithtableView:tableView];
        //    cell.contenString = [pingLuArray[indexPath.row] content];
        [cell bindData:dataArray[indexPath.section][indexPath.row]];
        return cell;
    }else{
        if (indexPath.row == [dataArray[indexPath.section] count]-1) {
            RenWuContentCell *cell = [RenWuContentCell cellWithtableView:tableView];
            [cell bindDataWithModel:dataArray[indexPath.section][indexPath.row]];
            return cell;
        }else{
            static NSString *cellName = @"XinJianRenWuTableViewCell";
            XinJianRenWuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[XinJianRenWuTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
            }
            [cell bindDataWithModel:dataArray[indexPath.section][indexPath.row]];
            return cell;
        }
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    // 评论的headerview
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    view.frame = CGRectMake(0, 0, self.view.width, 35);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, 100, 20);
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"评论";
    label.textColor = RGBACOLOR(140, 140, 140, 1);
    label.center = CGPointMake(label.center.x, view.height/2);
    [view addSubview:label];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissJianPan)]];
    headerView = view;
    return view;
}
- (void)disMissJianPan{
    [messageTF resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.0;
    }
    return 35.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 64;
    if (indexPath.section==1) {
        RenWuPingLunTableViewCell *cell = [RenWuPingLunTableViewCell cellWithtableView:tableView];
        RenWuPingLunModel *model = dataArray[indexPath.section][indexPath.row];
        if ([model.bName length]) {
            cell.contentLabel.text = [NSString stringWithFormat:@"@%@ %@",model.bName,model.content];
        }else
            cell.contenString = model.content;
        CGRect f = cell.contentLabel.frame;
        CGSize size = [cell.contentLabel.text sizeWithFont:cell.contentLabel.font constrainedToSize:CGSizeMake(cell.contentLabel.width, 1000.0) lineBreakMode:NSLineBreakByClipping];
        f.size.height = size.height;
        cell.contentLabel.frame = f;
        height = f.size.height+f.origin.y+15;
        if (height<=64)
            height = 64.0;
        model.cellHeight = height;
        
    }else{
        XinJianRenWuModel *m  = dataArray[indexPath.section][indexPath.row];
        
        height = m.cellHeight;
    }
    return height;
}

- (void)setNavRightButton{
    // 完成按钮
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setFrame:CGRectMake(0,0,18,18)];
    [finishButton setImage:[UIImage imageNamed:@"已完成icon"] forState:UIControlStateNormal];
    [finishButton setImage:[UIImage imageNamed:@"已完成icon点击.png"] forState:UIControlStateHighlighted];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishButton addTarget:self action:@selector(finishRenWuClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    // 删除按钮
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [delButton setFrame:CGRectMake(0,0,18,18)];
    [delButton setImage:[UIImage imageNamed:@"删除icon"] forState:UIControlStateNormal];
    [delButton setImage:[UIImage imageNamed:@"删除icon点击"] forState:UIControlStateHighlighted];
    [delButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    delButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [delButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    // 编辑按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setFrame:CGRectMake(0,0,18,18)];
    [editButton setImage:[UIImage imageNamed:@"编辑icon"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"编辑icon-点击"] forState:UIControlStateHighlighted];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [editButton addTarget:self action:@selector(edaitClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    // 空白按钮
    UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spaceButton.userInteractionEnabled = NO;
    [spaceButton setFrame:CGRectMake(0,0,0,18)];
    [spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    spaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:spaceButton];
    NSArray *items;
    if (!self.tongzhiRili) {
        if(self.isMyRenWu){
            if (!self.isFinish) {
                items = @[finishItem];
            }else{
                items = @[delItem];
            }
        }else{
            if (self.isFinish) {
                items = @[delItem];
            }else{
                items = @[finishItem,spaceItem,editItem];
            }
        }
    }
    self.navigationItem.rightBarButtonItems = items;
}

#pragma mark 编辑
- (void)edaitClick{
    EditRenWuViewController *bianji = [[EditRenWuViewController alloc] init];
    bianji.indexPath = self.indexPath;
    bianji.passValueFromXiugai = ^(ChuangjianRenwuSM *sm){
        [self loadRenWuDetailData];
        if (self.updataRenWu) {
            self.updataRenWu(self.renWuID);
        }
    };
    bianji.detailSM = taskSM;
    [self.navigationController pushViewController:bianji animated:YES];
}

#pragma mark 删除
- (void)deleteClick{
    NSLog(@"删除");
    [RenWuServiceShell shanChuRenWuWithID:self.renWuID usingCallback:^(DCServiceContext *context, ResultMode *sm){
        if (context.isSucceeded && sm.status == 0) {
            
            [self showHint:@"该任务已成功删除" finishCallBack:^{
                if (self.deleteRenWu) {
                    self.deleteRenWu(self.renWuID);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];

        }else{
            [self showHint:@"删除失败"];
        }
    }];
}

#pragma mark 完成
- (void)finishRenWuClick{
    [RenWuServiceShell markTaskStateWithID:self.renWuID isFinish:YES usingCallback:^(DCServiceContext *context, ResultMode *sm) {
        if (context.isSucceeded && sm.status == 0) {
            [self showHint:@"该任务已标记为已完成" finishCallBack:^{
                if (self.finishRenWu) {
                    self.finishRenWu(self.renWuID);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];

        }else{
            [self showHint:@"修改完成失败"];
        }
    }];
   
}
// 显示
- (void)keyboardWasShown:(NSNotification *)noti{
    NSDictionary* info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    toolViewBottomConst.constant = kbSize.height;
    tableViewBottomConstraint.constant = kbSize.height+toolView.height;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        if (cellIsSelected) {
            [baseTableView setContentOffset:CGPointMake(0, newOffset_y-baseTableView.height) animated:YES];
        }
    }];
}
// 隐藏
- (void)keyboardWillBeHidden:(NSNotification *)noti{
    NSDictionary* info = [noti userInfo];
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    toolViewBottomConst.constant = 0;
    tableViewBottomConstraint.constant = 49;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 注册键盘通知
- (void)registerForKeyboardNotifications
{
    messageTF.returnKeyType = UIReturnKeySend;
    messageTF.font = [UIFont systemFontOfSize:13];
    messageTF.textColor = RGBACOLOR(53, 55, 68, 1);
    
//    [messageTF setBianKuangWithCornerRadius:5 andBorderWidth:1 andColor:[UIColor lightGrayColor]];
    messageTF.placeholder = @"说点什么吧";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
 
}
// 日期选择View的按钮点击事件
- (IBAction)riQiQuViewButtonClick:(UIButton *)sender {
    [self hiddenRiQiView];
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        NSDateFormatter *nsDF = [[NSDateFormatter alloc] init];
        [nsDF setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSString *time = [nsDF stringFromDate:choseTimePickerView.date];
        if ([choseTimePickerView.date isInPast])
        {
            
        }
        [nsDF setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [RenWuServiceShell upDateRenWuValueWithColumn:RenWuColumn_Endtime value:[nsDF stringFromDate:choseTimePickerView.date] id:self.renWuID createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *context, ResultMode *sm) {
            if (context.isSucceeded && sm.status == 0) {
                XinJianRenWuModel *model = dataArray[0][3];
                model.cellValue = time;
                [baseTableView reloadData];
                if (self.updataRenWu) {
                    self.updataRenWu(self.renWuID);
                }
                [self showHint:sm.msg];
            }else{
                 [self showHint:@"修改失败"];
            }
        }];
    }
}

- (void)dateChanged:(UIDatePicker *)pickerView{
    if ([choseTimePickerView.date isInPast])
    {
        [choseTimePickerView setDate:[NSDate date]];
    }
}
- (void)showRiQiView{/**<显示日期选择view*/
    [choseTimePickerView setDate:[NSDate date]];
    riQiView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        riQiView.center = CGPointMake(ScreenWidth/2, ScreenHeight-riQiView.frame.size.height/2-64);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenRiQiView{
    [UIView animateWithDuration:0.5 animations:^{
        riQiView.center = CGPointMake(ScreenWidth/2, ScreenHeight+riQiView.frame.size.height/2-64);
    } completion:^(BOOL finished) {
        riQiView.hidden = YES;
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    riQiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, riQiView.frame.size.height);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (messageTF.isFirstResponder) {
        [messageTF resignFirstResponder];
    }
    if (!riQiView.hidden) {
        [self hiddenRiQiView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (buttonIndex == 0) {
            NSLog(@"ff");
            [RenWuServiceShell ShanshurenupinglunWithCreateid:[AppStore getYongHuID] ID:renwuPinglunModel.commentsID usingCallback:^(DCServiceContext *context, ResultMode *sm){
                if (context.isSucceeded && sm.status == 0) {
                    [dataArray[1] removeObject:renwuPinglunModel];
                    [baseTableView reloadData];
                }
            }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
