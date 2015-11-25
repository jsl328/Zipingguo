//
//  GongZuoBaoGaoXiangQViewController.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "GongZuoBaoGaoXiangQViewController.h"
#import "PingLunTableViewCell.h"
#import "BaoGaoNeiRongTableViewCell.h"
#import "PiYueRenTableViewCell.h"
#import "NSString+Ext.h"
#import "FujianCellView.h"
#import "FujianModel.h"
#import "UIKeyboardCoView.h"
#import "FujianXiazaiViewController.h"
#import "BaoGaoServiceShell.h"
#import "IQKeyboardManager.h"
#import "NSString+Ext.h"
#import "XuanzeRenyuanViewController.h"
#import "XuanzeRenyuanModel.h"
#import "WenjianYulanViewController.h"
#import "AiTeModel.h"
@interface GongZuoBaoGaoXiangQViewController ()<PiYueRenTableViewCellDelegate>
{
    ///附件
    NSMutableArray *_fujianArray;
    ///评论
    NSMutableArray *_pinglunArray;
    ///@用户id字符串
//    NSString *_aiTeIDStr;
//    NSMutableArray *_aiTeIDArray;

    ///@用户名字+@空格拼串
//    NSString *_aiTeNameStr;
    ///@XXX 的range
    NSMutableArray *_aiTeArray;

    
    ///批阅人
    PiYueRenTableViewCellModel *_piyuerenModel;
    ///抄送人
    PiYueRenTableViewCellModel *_chaosongrenModel;
    ///内容
    BaoGaoNeiRongTableViewCellModel *_neirongModel;
    ///报告数据模型;
    WorkPaper *_baogaoSM;
    ///是否加载过 （不用了）
    BOOL _isLoaded;
    ///这是0组除附件的行数，为了让界面看起来更流畅，初始为0，数据加载成功为4
    int number_0;
    
    ///正在被回复的那条评论的model，即上级评论
    PingLunTableViewCellModel * _currentPingLunModel;

}
@end

@implementation GongZuoBaoGaoXiangQViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作报告";
    
    _fujianArray = [@[] mutableCopy];
    _pinglunArray = [@[] mutableCopy];
    _aiTeArray = [@[] mutableCopy];
//    _aiTeIDArray = [@[] mutableCopy];
    _isLoaded = NO;
    number_0 = 0;
//    _aiTeIDStr = @"";
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    if ([_mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    _huifuTextView.placeholderColor = RGBACOLOR(194, 194, 194, 1);
    _huifuTextView.font = [UIFont systemFontOfSize:12];
    _huifuTextView.delegate = self;
    _huifuTextView.backgroundColor = [UIColor whiteColor];
    _huifuTextView.placeholder = @"回复";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuanwanle:) name:@"xuanzhongArray" object:nil];
    
    if (!self.isRead) {
        [self Read];
    }
    
//    [self addKeyboardCoView];
      [self loadData];
    
    
    //下拉刷新
    MJYaMiRefreshHeader *header = [MJYaMiRefreshHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    _mTableView.header = header;
    
    

}

- (void)Read{
    /*
    [ServiceShell getDecreaseReddotWithUserid:[AppStore getYongHuID] Key:@"WORKPAPER" usingCallback:^(DCServiceContext *serviceContext, ResultMode *sm) {
        if (!serviceContext.isSucceeded) {
            return ;
        }
        if (sm.status == 0) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"xiaoxiJianyi" object:nil];
        }
        NSLog(@"%@",sm.msg);
    }];
     */
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(float)cellheight:(NSString *)str{
    CGSize s = [str calculateSize:CGSizeMake(ScreenWidth - 125, FLT_MAX) font:[UIFont systemFontOfSize:14]];
       if ((s.height + 28) > 44) {
        return s.height + 28 ;
    }
    return 44;
}

#pragma mark - 加载数据
- (void)loadData{
    [LDialog showWaitBox:@"数据加载中"];
    [BaoGaoServiceShell getPaperDetailWithID:_baogaoId Userid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *sc, ZhoubaoxiangqingSM *sm) {
        [LDialog closeWaitBox];
        [_mTableView.header endRefreshing];
        if (sc.isSucceeded) {
            [_fujianArray removeAllObjects];
            [_pinglunArray removeAllObjects];
            [self fillDataWithModel:sm.data];
        }
    }];
}

-(void)fillDataWithModel:(BaoGaoData *)datamodel{
    number_0 = 4;
    //取得所有批阅人的名字，放到数组中
    NSMutableArray *namearray =[ @[] mutableCopy];
    for (Zhoubaoapproverusers *sm in datamodel.approverusers) {
        [namearray addObject:sm.username];
    }
    _piyuerenModel = [[PiYueRenTableViewCellModel alloc]init];
    _piyuerenModel.title = @"批阅人";
    _piyuerenModel.name = namearray;
    _piyuerenModel.isCanShouQi = YES;
    _piyuerenModel._isShouQi = NO;
    _piyuerenModel.cellHeight = [self cellheight:[_piyuerenModel.name componentsJoinedByString:@" "]];

    //取得所有抄送人的名字，放到数组中
    NSMutableArray *chaosongrenArray =[ @[] mutableCopy];
    for (Zhoubaoapproverusers *sm in datamodel.ccusers) {
        [chaosongrenArray addObject:sm.username];
    }
    _chaosongrenModel = [[PiYueRenTableViewCellModel alloc]init];
    _chaosongrenModel.title = @"抄送人";
    _chaosongrenModel.name = chaosongrenArray;
    _chaosongrenModel.isCanShouQi = NO;
    _chaosongrenModel.cellHeight = [self cellheight:[_chaosongrenModel.name componentsJoinedByString:@" "]];
    
    //报告内容
    _baogaoSM = datamodel.workpaper;
    _neirongModel  = [[BaoGaoNeiRongTableViewCellModel alloc]init];
    _neirongModel.jinrihtml = _baogaoSM.summary;
    _neirongModel.leixing = _leixing;
    _neirongModel.mingrihtml = _baogaoSM.plan;
    //35+25+10+20*2
    _neirongModel.cellHeight = 100 + [self height:_neirongModel.jinrihtml] + [self height:_baogaoSM.plan];
    NSLog(@"外面%f,%f",[self height:_neirongModel.jinrihtml],[self height:_baogaoSM.plan]);
    
    //附件
    for (NoticeAnnexsSM *annexsSM  in datamodel.workpaperAnnexs) {
        FujianModel *fujianModel = [[FujianModel alloc]init];
        fujianModel.noticeAnnexsSM = annexsSM;
        fujianModel.isBaogao = YES;
        [_fujianArray addObject:fujianModel];
    }
    
    //评论
    for (DailyCommentsSM *sm in datamodel.workpaperComments) {
        
        PingLunTableViewCellModel *model = [[PingLunTableViewCellModel alloc]init];
        model.name = sm.createname;
        model.huifurenName = sm.relusername;
        model.neiRong = sm.content;
        model.ID = sm.ID;
        model.createid = sm.createid;
        model.shijian = sm.createtime;
        model.topparid = sm.topparid;
        
        CGSize s = [sm.content calculateSize:CGSizeMake(ScreenWidth - 80, FLT_MAX) font:[UIFont systemFontOfSize:12]];
        if ((s.height + 50) > 64) {
            model.cellHeight = s.height + 50 ;
        }else{
            model.cellHeight = 64;
        }
        if (sm.createimgurl) {
            model.touxiangUrl = [URLKEY stringByAppendingString:sm.createimgurl];
        }
        [_pinglunArray addObject:model];
    }
    [_mTableView reloadData ];

}
-(float )height:(NSString *)str{

    CGSize size = [str calculateSize:CGSizeMake(ScreenWidth - 30, FLT_MAX) font:[UIFont systemFontOfSize:13]];
    return size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate&
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0://标题时间
            {
                static NSString *cellIndentifier = @"biaotiCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                }

                cell.textLabel.text = _baogaoSM.papername;
                //时间格式转化 10-10 18:04----》10月10日
                NSString *yue = [_baogaoSM.createtime substringWithRange:NSMakeRange(5, 2)];
                NSString *ri = [_baogaoSM.createtime substringWithRange:NSMakeRange(8, 2)];
                NSString *riqi = [NSString stringWithFormat:@"%@月%@日",yue,ri];
                cell.detailTextLabel.text = [riqi stringByAppendingString:_baogaoSM.weekday];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = RGBACOLOR(53, 55, 68, 1);
                cell.detailTextLabel.textColor = RGBACOLOR(53, 55, 68, 1);
                return cell;
            }
                break;
            case 1://批阅人
            {
                PiYueRenTableViewCell *piyuecell = [PiYueRenTableViewCell cellForTableView:tableView];
                piyuecell.delegate = self;
                piyuecell.model = _piyuerenModel;
                return piyuecell;
            }
                break;
            case 2://抄送人
            {
                PiYueRenTableViewCell *chaosongCell = [PiYueRenTableViewCell cellForTableView:tableView];
                chaosongCell.model = _chaosongrenModel;
                return chaosongCell;
            }
                break;
            case 3://内容
            {
                BaoGaoNeiRongTableViewCell *neirongCell = [BaoGaoNeiRongTableViewCell cellForTableView:tableView];
                neirongCell.isload = !_isLoaded;
                neirongCell.model = _neirongModel;
//                _isLoaded = YES;
                return neirongCell;
            }
                break;
            default:
            {
                //附件
                FujianCellView *fujiancell = [FujianCellView cellForTableView:tableView];
                fujiancell.model = _fujianArray[indexPath.row - 4];
                return fujiancell;
            }
                break;
        }
    }
    
    PingLunTableViewCell *cell = [PingLunTableViewCell cellForTableView:tableView];
    cell.model = _pinglunArray[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIEdgeInsets edgeInset = UIEdgeInsetsZero;
    if(indexPath.section == 0 && indexPath.row == 1 && !_piyuerenModel._isShouQi){
        edgeInset = UIEdgeInsetsMake(0, 15, 0, 0);;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edgeInset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edgeInset];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return number_0 + _fujianArray.count;
            break;
        case 1:
            return _pinglunArray.count;
            break;
        default:
            break;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 55;
        }
        if (indexPath.row == 1 ) {
            return _piyuerenModel.cellHeight;
        }
        if (indexPath.row == 2) {
            if(_piyuerenModel._isShouQi){//收起状态
                return 0;
            }
            return _chaosongrenModel.cellHeight;
        }
        if (indexPath.row == 3) {//内容
            return _neirongModel.cellHeight;
        }
        return 64;
        
    }else{//评论
//        return 64;
        
        PingLunTableViewCellModel *model = _pinglunArray[indexPath.row];
        return model.cellHeight;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1 && _pinglunArray.count > 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        headerView.backgroundColor = Bg_Color;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,100, 30 )];
        label.textColor = RGBACOLOR(140, 140, 140, 1);
        label.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:label];
        label.text = @"评论";
        return headerView;

    }
    
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 && _pinglunArray.count > 0) {
        return 30;
    }
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    footerView.backgroundColor = Bg_Color;
    return footerView;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
        _currentPingLunModel = nil;//清空选中的品论，默认评论报告
        if(indexPath.row > 3){//附件
            
            FujianModel *model = [_fujianArray objectAtIndex:indexPath.row - 4];
            
            NSRange range = [model.noticeAnnexsSM.fileurl rangeOfString:@"last"];
            
            if (range.location != NSNotFound) {
                model.noticeAnnexsSM.fileurl = [model.noticeAnnexsSM.fileurl stringByReplacingCharactersInRange:range withString:@"big"];
            }
            
            NSArray *arr = [model.noticeAnnexsSM.fileurl componentsSeparatedByString:@"."];
            NSString* filePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.noticeAnnexsSM.fileurl] fileName:[arr lastObject]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
                WenjianYulanViewController *yulan = [[WenjianYulanViewController alloc] init];
                yulan.url = [self yulan:[NSString stringWithFormat:@"%@%@",URLKEY,model.noticeAnnexsSM.fileurl]];
                yulan.biaoti = model.noticeAnnexsSM.filename;
                [self.navigationController pushViewController:yulan animated:YES];
            }else{
                FujianXiazaiViewController *fujian = [[FujianXiazaiViewController alloc] init];
                fujian.noticeAnnexsSM = model.noticeAnnexsSM;
                [self.navigationController pushViewController:fujian animated:YES];
            }
        }
    }else{
    
        [_huifuTextView becomeFirstResponder];
        PingLunTableViewCellModel *pinglunModel = _pinglunArray[indexPath.row];
        _currentPingLunModel = pinglunModel;
        _huifuTextView.placeholder = [NSString stringWithFormat:@"回复%@",pinglunModel.name];
    }
}

- (NSString *)yulan:(NSString *)url{
    
    NSArray *arr = [url componentsSeparatedByString:@"."];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *path=[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"Downloaded/"];
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",DCMD5ForString(url),[arr lastObject]]];
    return pathName;
}
#pragma mark -
-(void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    _huiFuView.frame  = CGRectMake(0, self.view.height - _huiFuView.height, ScreenWidth, _huiFuView.height);
    _mTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - _huiFuView.height);
}

#pragma mark - PiYueRenTableViewCellDelegat
-(void)shouqiOrZhankaiChaoSongRen:(BOOL)isShouqi{
    _piyuerenModel._isShouQi = isShouqi;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    //刷新批阅人和抄送人
    [_mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - 控制dibuview

- (void)addKeyboardCoView
{
    /*
     不隐藏时 使用
     可以不遵守delegate
     */
    UIKeyboardCoView *view = [[UIKeyboardCoView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
    view.beginRect = ^(CGRect beginRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            _huiFuView.frame  = CGRectMake(0, beginRect.origin.y - _huiFuView.height, ScreenWidth, _huiFuView.height);
  
        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            _huiFuView.frame  = CGRectMake(0, self.view.height - _huiFuView.height, ScreenWidth, _huiFuView.height);
        }];
    };
    [self.view addSubview:view];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text quKongGe].length > 0) {
        _faSongBtn.userInteractionEnabled = YES;
        [_faSongBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        
    }else{
        _faSongBtn.userInteractionEnabled = NO;
        [_faSongBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([textView.text quKongGe].length == 0) {//去掉空格回车后的字符串
            textView.text = @"";
            return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }else{
            [self fabiaoPinLun];
            return NO;
        }
    }
    
    NSInteger delLength = range.length;
    NSLog(@"delLength:%ld,",(long)delLength);
    if(range.length > 0){//删除
        //遍历@数组
        for (int i = 0; i < _aiTeArray.count ; i ++ ) {
            AiTeModel *model = _aiTeArray[i];
            NSRange ran = model.range ;
            if (range.location >= ran.location && range.location < ran.location + ran.length) {//删除的是@
                NSMutableString *temptext = [_huifuTextView.text mutableCopy];
                [_aiTeArray removeObject:model];
                [temptext deleteCharactersInRange:NSMakeRange(ran.location, ran.length-1)];
                delLength = ran.length;//删除的长度变为整个@name的长度
                _huifuTextView.text = temptext;
                _huifuTextView.selectedRange = NSMakeRange(ran.location + 1, 0);
                break;
            }
        }
        //后面的前移
        [self aiTeNameLocationConfigWithRange:NSMakeRange(range.location, delLength) isDelete:YES];
    }else{//增加字符
        //后面的后移
        [self aiTeNameLocationConfigWithRange:NSMakeRange(range.location, text.length) isDelete:NO];
    }
    return YES;
}

-(void)aiTeNameLocationConfigWithRange:(NSRange)range isDelete:(BOOL)isdelete{
    if (isdelete) {
        //后面的@ 位置前移
        for (int i = 0; i < _aiTeArray.count ; i ++ ) {
            AiTeModel *model1 = _aiTeArray[i];
            NSRange ran1 = model1.range ;
            if (range.location <= ran1.location) {//删除光标后面的内容
                //位置前移
                model1.range = NSMakeRange(ran1.location - range.length, ran1.length);
            }
        }
    }else{
        //后面的@ 位置后移
        for (int i = 0; i < _aiTeArray.count ; i ++ ) {
            AiTeModel *model1 = _aiTeArray[i];
            NSRange ran1 = model1.range ;
            if (range.location <= ran1.location) {//光标后面的内容
                //位置后移
                model1.range = NSMakeRange(ran1.location + range.length, ran1.length);
            }
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return YES;
}
//光标位置
- (void)textViewDidChangeSelection:(UITextView *)textView{

    for (int i = 0; i < _aiTeArray.count ; i ++ ) {
        AiTeModel *model = _aiTeArray[i];
        NSRange ran = model.range ;
        
        if (textView.selectedRange.location > ran.location && textView.selectedRange.location < ran.location + ran.length) {//光标在名字之间
            //让光标移到最后
            _huifuTextView.selectedRange = NSMakeRange(textView.text.length + 1, 0);
            return;
        }
        
    }
    
}

#pragma mark - @
- (IBAction)aiTeClick:(UIButton *)sender {
    
    XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
    xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
    xuanze.endureArray = [@[[AppStore getYongHuID]] mutableCopy];
    [self presentViewController:nav animated:YES completion:nil];
    
}

/**
 *  选完了 通知
 *
 *  @param notice 通知
 */
-(void)xuanwanle:(NSNotification *)notice{
    
    NSDictionary *dict = notice.userInfo;
    NSArray *resultArray = [dict objectForKey:@"xuanzhongArray"];
    
    //取出名字放到数组里链接成字符串
    NSMutableArray *tempNameArray = [@[] mutableCopy];
//    NSMutableArray *tempIDArray = [@[] mutableCopy];
    
    for (XuanzeRenyuanModel *model in resultArray) {
        //名字前面+@
        NSString *aiteName = [NSString stringWithFormat:@"@%@",model.personsSM.name];
        [tempNameArray addObject: aiteName];
//        [tempIDArray addObject:model.personsSM.userid];
//        [_aiTeIDArray addObject:model.personsSM.userid];
        NSRange range = NSMakeRange(_huifuTextView.selectedRange.location, aiteName.length);
        _huifuTextView.text = [_huifuTextView.text  stringByReplacingCharactersInRange:_huifuTextView.selectedRange withString:aiteName];
        //先后移再插入
        [self aiTeNameLocationConfigWithRange:NSMakeRange(range.location , range.length) isDelete:NO];

        
        AiTeModel * aitemodel = [[AiTeModel alloc]init];
        aitemodel.name = aiteName;
        aitemodel.xuanzeRenyuanModel = model;
        aitemodel.range = range;
        aitemodel.ID = model.personsSM.userid;
        [_aiTeArray addObject:aitemodel];
        //后面的@name Range后移
    
    }
    
}

#pragma mark - 发送
- (IBAction)faSongClick:(UIButton *)sender {

    [self fabiaoPinLun];
}

-(void)fabiaoPinLun{
    [_huifuTextView resignFirstResponder];
    NSString * isreply;
    NSString * topparid;
    if (_currentPingLunModel) {//二级评论
        isreply = _currentPingLunModel.ID;
        topparid = _currentPingLunModel.topparid;
    }else{
        isreply = @"0";
        topparid = @"0";
    }
    
    NSMutableArray *tempIdArray = [@[] mutableCopy];
    for (AiTeModel *aiteModel in _aiTeArray) {
        if ([tempIdArray containsObject:aiteModel.ID] == NO) {
            [tempIdArray addObject:aiteModel.ID];

        }
    }
    
    

    [BaoGaoServiceShell commentWorkWithCreateid:[AppStore getYongHuID] Content:_huifuTextView.text WeekPaperid:_baogaoId Isreply:isreply Topparid:topparid IDS:[tempIdArray componentsJoinedByString:@","] usingCallback:^(DCServiceContext *sc, RibaopinglunSM *sm) {
        if(sc.isSucceeded){
            //先移除数组，再移除text
            [_aiTeArray removeAllObjects];
            _huifuTextView.text = @"";//清空输入框

            DailyCommentsSM *dailyCommentsSM = sm.ribaopinglun;
            PingLunTableViewCellModel *model = [[PingLunTableViewCellModel alloc]init];
            model.name = dailyCommentsSM.createname;
            model.huifurenName = dailyCommentsSM.relusername;
            model.neiRong = dailyCommentsSM.content;
            model.ID = dailyCommentsSM.ID;
            model.createid = dailyCommentsSM.createid;
            model.shijian = dailyCommentsSM.createtime;
            model.topparid = dailyCommentsSM.topparid;
            model.touxiangUrl = [URLKEY stringByAppendingString:[AppStore getYonghuImageView]];
            [_pinglunArray addObject:model];
            [_mTableView reloadData];
     
//            [_mTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}


@end

