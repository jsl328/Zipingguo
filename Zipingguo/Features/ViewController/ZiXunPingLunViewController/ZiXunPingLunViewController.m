//
//  ZiXunPingLunViewController.m
//  Zipingguo
//
//  Created by sunny on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunPingLunViewController.h"
#import "ZiXunCommentCell.h"
#import "ZiXunServiceShell.h"
#import "UIKeyboardCoView.h"
#import "NSString+Ext.h"
#import "XuanzeRenyuanViewController.h"
#import "XuanzeRenyuanModel.h"
#import "CustomActionSheet.h"

@interface ZiXunPingLunViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    NSMutableArray *dataArray;
    int startIndex;
    NSMutableArray *cellHeightArray;
    
    
    // 提交信息
    /// 回复的那个cell
    ZiXunCommentModel *huiFuModel;
    NSString *isReply;
    NSString *topParid;
    NSString *atUserIDs;
    NSMutableArray *atUserIDsArray;
    NSMutableArray *xuanZhongModelArray;
    
    NSString *YaoqingRenName;
}

@end

@implementation ZiXunPingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资讯评论";
    startIndex = 0;
    dataArray = [@[] mutableCopy];
    cellHeightArray = [@[] mutableCopy];
    xuanZhongModelArray = [@[] mutableCopy];
    atUserIDsArray = [@[] mutableCopy];
    atUserIDs = @"";
    [self createTableView];
    [self createBottomView];
    [self loadData];
    NSLog(@"%@",self.ziXunID);
}
- (void)createTableView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.tableFooterView = footerView;
    myTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight- NavHeight - 49);
    myTableView.separatorColor = Fenge_Color;
    
}
- (void)createBottomView{
    shuRuTextView.delegate = self;
    shuRuTextView.placeholder = @"请输入评论（1000字以内）";
    [self resetDibuViewFrameForKeyboard];
}
- (void)loadData{
    [ZiXunServiceShell ziXunPingLunListWithZiXunID:self.ziXunID UsingCallback:^(DCServiceContext *context, ZiXunPingLunResultSM *sm) {
        if (context.isSucceeded && sm.status == 0) {
            [self fillDataWith:sm];
        }else{
            [SDialog showTipViewWithText:sm.msg hideAfterSeconds:1];
        }
    }];
    
}
- (void)fillDataWith:(ZiXunPingLunResultSM *)resultSM{
    if (startIndex == 0) {
        [dataArray removeAllObjects];
        [cellHeightArray removeAllObjects];
    }
    for (ZiXunCommentSM *commentSM in resultSM.data) {
        ZiXunCommentModel *model = [[ZiXunCommentModel alloc] init];
        [model bindModelWithSM:commentSM];
        NSMutableArray *tempArray = [@[] mutableCopy];
        for (ZiXunSingleCommentSM *singleCommentSM in commentSM.childComments) {
            ZiXunSingleCommentModel *model = [[ZiXunSingleCommentModel alloc] init];
            [model bindModelWithSM:singleCommentSM];
            [tempArray addObject:model];
        }
        model.childComments = tempArray;
        model.isExpand = NO;
        // 计算每个cell高度
        [cellHeightArray addObject:[NSNumber numberWithFloat:[self getHeightWithSM:model]]];
        [dataArray addObject:model];
    }
    [myTableView reloadData];
    [self viewDidLayoutSubviews];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZiXunCommentCell *cell = [ZiXunCommentCell cellForTableView:tableView];
    cell.model = dataArray[indexPath.row];
    // 点击删除
    cell.ziXunSingleCommentCellDelete = ^(ZiXunCommentModel *ziXunmodel,ZiXunSingleCommentModel *singleModel){
        [shuRuTextView resignFirstResponder];
        CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"删除"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
        [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
        [ShareApp.window addSubview:customActionSheet];
        [self showMoHuView];
        [customActionSheet showButtons:^(NSInteger index) {
            [ZiXunServiceShell ziXunPingLunDeleteWithYongHuID:[AppStore getYongHuID] PingLunID:singleModel.commentID UsingCallback:^(DCServiceContext *context, ResultMode *sm) {
                if (context.isSucceeded ) {
                    if (sm.status == 0) {
                        [ziXunmodel.childComments removeObject:singleModel];  //删除数组里的数据
                        if ([dataArray indexOfObject:ziXunmodel] != NSNotFound) {
                            NSInteger tempIndex = [dataArray indexOfObject:ziXunmodel];
                            // 更换数据源
                            [dataArray replaceObjectAtIndex:tempIndex withObject:ziXunmodel];
                            // 更换cell高度
                            [cellHeightArray replaceObjectAtIndex:tempIndex withObject:[NSNumber numberWithFloat:[self getHeightWithSM:ziXunmodel]]];
                            [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                    }
                    [self showHint:sm.msg];
                }else{
                    [self showHint:@"删除失败，请重新删除"];
                }
            }];
            
            [self hideMoHuView];
        } cancle:^{
            [self hideMoHuView];
        }];
        return;
    };
    // 点击评论
    cell.ziXunSingleCommentCellClick = ^(ZiXunCommentModel *model,ZiXunSingleCommentModel *singleModel){
        if ([shuRuTextView isFirstResponder]) {
            [shuRuTextView resignFirstResponder];
             shuRuTextView.placeholder = @"请输入评论（1000字以内）";
            return ;
        }
        huiFuModel = model;
        [shuRuTextView becomeFirstResponder];
        shuRuTextView.placeholder = [NSString stringWithFormat:@"回复%@",singleModel.createname];
        isReply = singleModel.commentID;
        topParid = singleModel.topparid;
    };
    /// 查看更多或者收起
    cell.chaKanMoreClick = ^(ZiXunCommentModel *ziXunmodel,ZiXunSingleCommentModel *singleModel){
        ziXunmodel.isExpand = !ziXunmodel.isExpand;
        shuRuTextView.placeholder = @"请输入评论（1000字以内）";
         if ([dataArray indexOfObject:ziXunmodel] != NSNotFound) {
              NSInteger tempIndex = [dataArray indexOfObject:ziXunmodel];
            // 更换数据源
            [dataArray replaceObjectAtIndex:tempIndex withObject:ziXunmodel];
            // 更换cell高度
            [cellHeightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:[self getHeightWithSM:ziXunmodel]]];
            [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         [shuRuTextView resignFirstResponder];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [cellHeightArray[indexPath.row] floatValue];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myTableView) {
        ZiXunCommentModel *commentModel = dataArray[indexPath.row];
        if ([commentModel.createid isEqualToString:[AppStore getYongHuID]]) {
            [shuRuTextView resignFirstResponder];
            CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"删除"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
            [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
            [ShareApp.window addSubview:customActionSheet];
            [self showMoHuView];

            [customActionSheet showButtons:^(NSInteger index) {
                [ZiXunServiceShell ziXunPingLunDeleteWithYongHuID:[AppStore getYongHuID] PingLunID:commentModel.commentID UsingCallback:^(DCServiceContext *context, ResultMode *sm) {
                    if (context.isSucceeded ) {
                        if (sm.status == 0) {
                            [cellHeightArray removeObjectAtIndex:indexPath.row];
                            [dataArray removeObjectAtIndex:indexPath.row];  //删除数组里的数据
                            [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                        [self showHint:sm.msg];
                    }else{
                        [self showHint:@"删除失败，请重新删除"];
                    }
                }];
                [self hideMoHuView];
            } cancle:^{
                [self hideMoHuView];
            }];
            return;
        }
        if ([shuRuTextView isFirstResponder]) {
            [shuRuTextView resignFirstResponder];
            shuRuTextView.placeholder = @"请输入评论（1000字以内）";
            return ;
        }
        [shuRuTextView becomeFirstResponder];
        shuRuTextView.placeholder = [NSString stringWithFormat:@"回复%@",commentModel.createname];
        isReply = commentModel.commentID;
        topParid = commentModel.commentID;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}
#pragma  mark - action
- (IBAction)yaoQingPesonBtnClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(atMembers:) name:@"xuanzhongArray" object:nil];
    XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
    xuanze.xuanzhongArray = xuanZhongModelArray;
    xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)atMembers:(NSNotification *)not{
    // 清空数组
    [atUserIDsArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSMutableArray *nameArray = [@[] mutableCopy];
    NSDictionary *dict = [not userInfo];
    xuanZhongModelArray = [dict objectForKey:@"xuanzhongArray"];
    for (XuanzeRenyuanModel *model in [dict objectForKey:@"xuanzhongArray"]) {
        [nameArray addObject:model.personsSM.name];
        [atUserIDsArray addObject:model.personsSM.userid];
    }
    
    if (nameArray.count != 0) {
        [shuRuTextView becomeFirstResponder];
        NSString *wenzi =  [shuRuTextView.text substringFromIndex:YaoqingRenName.length];
        
        YaoqingRenName = [NSString stringWithFormat:@"@%@ ",[nameArray componentsJoinedByString:@" @"]];
        shuRuTextView.text = [YaoqingRenName stringByAppendingString:wenzi];
        [sendBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        sendBtn.userInteractionEnabled = YES;
    }

    
}
- (IBAction)faSongBtnClick:(UIButton *)sender {
    
    [self zixunpinglun];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([textView.text quKongGe].length == 0) {//去掉空格回车后的字符串
            textView.text = @"";
            return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }else{
            [self zixunpinglun];
            return NO;
        }
    }
    return YES;
}

#pragma mark - layout
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
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
#pragma mark - 键盘处理
- (void)resetDibuViewFrameForKeyboard{
    UIKeyboardCoView *view = [[UIKeyboardCoView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
    view.beginRect = ^(CGRect beginRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            bottomView.frame = CGRectMake(0, beginRect.origin.y- 49, ScreenWidth, 49);

        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            bottomView.frame = CGRectMake(0, ScreenHeight - NavHeight- 49, ScreenWidth, 49);
        }];
    };
    [self.view addSubview:view];
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]) {
        [sendBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        sendBtn.userInteractionEnabled = YES;
    }else{
        [sendBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
        sendBtn.userInteractionEnabled = NO;
    }
}

- (float)getHeightWithSM:(ZiXunCommentModel *)ziXunCommentModel{
    NSMutableArray *huiFuDataArray = [@[] mutableCopy];
    // 评论内容label的y
    float cellHeight = 32;
    float commentHeight = [ziXunCommentModel.content calculateSize:CGSizeMake(ScreenWidth - 70 - 15, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height;
    // 此时为topView高度
    if (commentHeight + cellHeight < 52) {
        cellHeight =  52 + 11;
    }else{
        
        cellHeight = cellHeight + commentHeight + 11;
    }
    
    float huiFuTableHeight = 0.0f;
    if (ziXunCommentModel.childComments.count > 3) {
        huiFuTableHeight = 0.0f;
        if (ziXunCommentModel.isExpand == YES) {
            [huiFuDataArray addObjectsFromArray:ziXunCommentModel.childComments];
        }else{
            [huiFuDataArray addObject:ziXunCommentModel.childComments[0]];
            [huiFuDataArray addObject:ziXunCommentModel.childComments[1]];
            [huiFuDataArray addObject:ziXunCommentModel.childComments[2]];
        }
        for (ZiXunSingleCommentModel *commentModel in huiFuDataArray) {
            NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",commentModel.createname,commentModel.relusername,commentModel.content];
            CGFloat h = [str calculateSize:CGSizeMake(ScreenWidth - 85, MAXFLOAT) font:[UIFont systemFontOfSize:12]].height + 8;
            huiFuTableHeight = huiFuTableHeight + h;
        }
        // 9为header
        huiFuTableHeight = huiFuTableHeight + 28 ;
    }else if ( ziXunCommentModel.childComments.count > 0 && ziXunCommentModel.childComments.count <=3){
        huiFuTableHeight = 0.0f;
        for (ZiXunSingleCommentModel *commentModel in ziXunCommentModel.childComments) {
            NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",commentModel.createname,commentModel.relusername,commentModel.content];
            CGFloat h = [str calculateSize:CGSizeMake(ScreenWidth - 85, MAXFLOAT) font:[UIFont systemFontOfSize:12]].height + 8;
            huiFuTableHeight = huiFuTableHeight + h;
        }
//        huiFuTableHeight = huiFuTableHeight;
    }else{
        huiFuTableHeight = 0.0f;
    }
    return cellHeight + (huiFuTableHeight == 0 ? 0 : huiFuTableHeight + 11);
}

- (void)zixunpinglun{
    // 是评论还是回复
    // 此时是评论文章
    NSLog(@"%@",shuRuTextView.placeholder);
    BOOL isPingLun ;
    if ([shuRuTextView.placeholder isEqualToString:@"请输入评论（1000字以内）"]) {
        isReply = @"0";
        topParid = @"0";
        isPingLun = YES;
    }else{
        isPingLun = NO;
    }
    
    // @人
    NSString *ids;
    if (atUserIDsArray.count != 0) {
        ids = [atUserIDsArray componentsJoinedByString:@","];
    }else{
        ids = @"";
    }
    [shuRuTextView resignFirstResponder];
    [LDialog showWaitBox:@"发送中"];
    [ZiXunServiceShell ziXunTiJiaoPingLunWithYongHuID:[AppStore getYongHuID] Content:shuRuTextView.text ZiXunID:self.ziXunID IsReply:isReply TopParid:topParid ATIDs:ids UsingCallback:^(DCServiceContext *context, ZiXunTiJiaoPingPunSM *sm) {
        [LDialog closeWaitBox];
        if (context.isSucceeded && sm.status == 0) {
            [self showHint:@"发送成功"];
            self.ziXunCellModel.commentCount ++;
            self.pingLunChange(self.ziXunCellModel);
            shuRuTextView.placeholder = @"请输入评论（1000字以内）";
            shuRuTextView.text = @"";
            [sendBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
            sendBtn.userInteractionEnabled = NO;
            if (isPingLun) {
                [self loadData];
            }else{
                if ([dataArray indexOfObject:huiFuModel] != NSNotFound && huiFuModel.isExpand == YES) {
                    ZiXunSingleCommentModel *singleModel = [[ZiXunSingleCommentModel alloc] init];
                    [singleModel bindModelWithSM:sm.data];
                    
                    [huiFuModel.childComments insertObject:singleModel atIndex:huiFuModel.childComments.count];
                    [cellHeightArray replaceObjectAtIndex:[dataArray indexOfObject:huiFuModel] withObject:[NSNumber numberWithFloat:[self getHeightWithSM:huiFuModel]]];
                    [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[dataArray indexOfObject:huiFuModel] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else {
                    [self loadData];
                }
            }
            
        }else{
            [self showHint:@"发送失败，请重新发送"];
        }
    }];
}

@end
