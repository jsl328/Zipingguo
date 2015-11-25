

#import "ZuDetailViewController.h"
#import "UserinfoByHuanxinSM.h"
#import "EMGroup.h"
#import "UIViewController+BarButtonItemPostion.h"
#import "XuanzeRenyuanViewController.h"
#import "XiugaiXinxiViewController.h"
#import "ChatSendHelper.h"

@interface ZuDetailViewController ()
@end

@implementation ZuDetailViewController
- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //itemBox
    [self addItemBox];
    
    //初始化数组
    [self initDulipteMutableArr];
}

-(void)initDulipteMutableArr
{
    AllMembersID =[[NSMutableArray alloc]init];
    dataArray =[[NSMutableArray alloc]init];
    nameArray =[[NSMutableArray alloc]init];
    TouxiangArray =[[NSMutableArray alloc]init];
    idArray =[[NSMutableArray alloc]init];
    yonghuArr =[@[] mutableCopy];
    yonghuArr =[YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
    
    self.title = @"聊天详情";
    //信息
    NSArray *dd =@[_chatter,[[[AppStore getYongHuID]substringToIndex:20]lowercaseString]];
    if (_ConversationType ==eConversationTypeChat) {
        _chatter = _userid;
        _zuyuanXinxiView.hidden =YES;
        _exitionAction.hidden=YES;
        if (yonghuArr.count ||![NetWork isConnectionAvailable]) {
            NSMutableArray *temp =[NSMutableArray array];
            for (NSString *ss in dd) {
                UserinfoByHuanxinSM *sm =[[UserinfoByHuanxinSM alloc]init];
                for (YonghuInfoDB *db in yonghuArr) {
                    if ([[[db.userid substringToIndex:20] lowercaseString] isEqualToString:ss]) {
                        sm._id = db.userid;
                        sm.name =db.name.length?db.name:@"AA";
                        sm.imgurl =db.imgurl.length?db.imgurl:@"头像80.png";
                        sm.phone = db.phone;
                        
                        [temp addObject:sm];
                        
                        [AllMembersID addObject:sm._id];
                        [nameArray addObject:sm.name];
                        [TouxiangArray addObject:sm.imgurl];
                        [idArray addObject:sm._id];
                    }
                }
            }
            membersArray = (NSArray *)temp;
            [self HuoquQunzuXinxi:(NSArray *)temp withType:YES withIsGroup:NO];
        }else{
            [ServiceShell getUserinfoByHxnameWithAppIds:[dd componentsJoinedByString:@","] usingCallback:^(DCServiceContext *serv, ResultModelOfUserinfoByHxnameSM *result) {
                if (serv.isSucceeded&&result.data.count) {
                    _zuyuanXinxiView.hidden =YES;
                    _exitionAction.hidden=YES;
                    for (UserinfoByHuanxinSM *sm in result.data) {
                        [AllMembersID addObject:sm._id];
                        [nameArray addObject:sm.name];
                        if (!sm.imgurl||!sm.imgurl.length) {
                            sm.imgurl = @"头像80.png";
                        }
                        [TouxiangArray addObject:sm.imgurl];
                        [idArray addObject:sm._id];
                    }
                    membersArray = result.data;
                    [self HuoquQunzuXinxi:result.data withType:YES withIsGroup:NO];
                }
            }];
        }
    }else{
        _chatter = _groupID;
        [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatter
                                                       completion:^(EMGroup *group, EMError *error) {
            if (group.occupants.count&&!error) {
                //暂时存住
                gr = group;
                
                if (yonghuArr.count||![NetWork isConnectionAvailable]) {
                    NSMutableArray *temp =[@[] mutableCopy];
                    NSMutableArray *userinfo =[@[] mutableCopy];
                    for (NSString *bundy in group.occupants) {
                        UserinfoByHuanxinSM *sm =[[UserinfoByHuanxinSM alloc]init];
                        for (YonghuInfoDB *db in yonghuArr) {
                            if ([bundy isEqualToString:[[db.userid substringToIndex:20] lowercaseString]]) {
                                sm._id = db.userid;
                                sm.name = db.name.length?db.name:@"AA";
                                sm.phone = db.phone;
                                sm.imgurl =db.imgurl.length?db.imgurl:@"头像80.png";
                                
                                if (sm._id) {
                                    [AllMembersID addObject:sm._id];
                                }
                                if (sm.name) {
                                    [temp addObject:sm.name];
                                }
                                [userinfo addObject:sm];
                            }
                        }
                    }
                    //再次布局的时候用
                    membersArray =(NSArray*)userinfo;
                    _zuMingChengLabel.text=!group.groupSubject?[temp componentsJoinedByString:@","]:group.groupSubject;
                    
                    if ([group.owner isEqualToString:[[[AppStore getYongHuID] substringToIndex:20] lowercaseString]]) {
                        [_exitionAction setTitle:@"删除并且退出" forState:UIControlStateNormal];
                        _exitionAction.hidden =NO;
                    }else{
                        [_exitionAction setTitle:@"退出" forState:UIControlStateNormal];
                        _arrowImageView.hidden =YES;
                    }
                    
                    [self HuoquQunzuXinxi:userinfo
                                 withType:YES
                              withIsGroup:YES];
                }else{
                    //群组信息
                    [ServiceShell getUserinfoByHxnameWithAppIds:[group.occupants componentsJoinedByString:@","] usingCallback:^(DCServiceContext *serv, ResultModelOfUserinfoByHxnameSM *result) {
                        if (serv.isSucceeded&&result.data.count) {
                            //存下来
                            NSMutableArray *temp =[@[] mutableCopy];
                            for (UserinfoByHuanxinSM *ss in result.data) {
                                if (ss._id) {
                                    [AllMembersID addObject:ss._id];
                                }
                                if (ss.name) {
                                    [temp addObject:ss.name];
                                }
                            }
                            
                            //再次布局的时候用
                            membersArray =result.data;
                            _zuMingChengLabel.text=!group.groupSubject?[temp componentsJoinedByString:@","]:group.groupSubject;
                            
                            if ([group.owner isEqualToString:[[[AppStore getYongHuID] substringToIndex:20] lowercaseString]]) {
                                [_exitionAction setTitle:@"删除并且退出" forState:UIControlStateNormal];
                            }else{
                                [_exitionAction setTitle:@"退出" forState:UIControlStateNormal];
                                _arrowImageView.hidden =YES;
                            }
                            
                            [self HuoquQunzuXinxi:result.data
                                         withType:YES
                                      withIsGroup:YES];
                        }
                    }];
                }
            }
        } onQueue:nil];
    }
}

//清除聊天记录试图窗口
- (void)creatActionSheet{
    CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"清空聊天记录"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    customActionSheet.delegate = self;
    [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
    [ShareApp.window addSubview:customActionSheet];
    [customActionSheet show];
    [self showMoHuView];
}

- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton
                              customActionView:(CustomActionSheet *)customActionSheet
{
    if (indexButton == 1) {
        //删除聊天记录
        if ([_converSation.chatter isEqualToString:_chatter]) {
            //[_converSation removeAllMessages];
            self.removeAllConverstionMessage();
        }
    }
    [self hideMoHuView];
}
- (void)CustomActionSheetDelegateDidClickCancelButton:(CustomActionSheet *)customActionSheet
{
    [self hideMoHuView];
}

-(void)back{
    if ([self.delegate respondsToSelector:@selector(BackRefresh)]) {
        [self.delegate BackRefresh];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)addItemBox{
    [dataArray removeAllObjects];
    NSArray *subviews = _itemsView.subviews;
    //这边不能一边遍历一遍删除
    for (UIView *subView in subviews) {
        [subView removeFromSuperview];
    }
    itemsBox = [[DCItemsBox alloc] init];
    itemsBox.frame = CGRectMake(0, 0, _itemsView.frame.size.width, _itemsView.frame.size.height);
    [_itemsView addSubview:itemsBox];
}

#pragma mark - 核心布局
- (void)HuoquQunzuXinxi:(NSArray *)data
               withType:(BOOL)type
            withIsGroup:(BOOL)isgroup{
    //    [self addItemBox];
    [dataArray removeAllObjects];
    DCItemsBoxGridLayout *grid = [[DCItemsBoxGridLayout alloc] initWidthDefaultColumnCount:5]; //每行几个
    grid.rowHeight = 100; //每个高度
    grid.itemGap = 0;//间距
    itemsBox.cellBorderColor = [UIColor clearColor];
    itemsBox.layout = grid;
    NSInteger cout = isgroup&&data.count?(data.count+2):3;
    for (int i = 0;i < cout;i++) {
        ZuyuanXinxiCellVM *model = [[ZuyuanXinxiCellVM alloc] init];
        model.delegate = self;
        if (i < data.count) {
            UserinfoByHuanxinSM *sm =[data objectAtIndex:i];
            if (type) {
                model.anNiuZhuangtai = NO;
            }else{
                if ([[sm._id uppercaseString] isEqualToString:[[AppStore getYongHuID] uppercaseString]]) {
                    model.anNiuZhuangtai = NO;
                }else{
                    model.anNiuZhuangtai = YES;
                }
            }
            
            if (!sm.imgurl||!sm.imgurl.length) {
                model.touxiangString = @"头像80.png";
            }else{
                model.touxiangString =  [NSString stringWithFormat:@"%@%@",URLKEY,sm.imgurl];;
            }
            model.name =!sm.name?@"测试群组":sm.name;
            model.key = sm._id;
            model.shanrenZhuangtai = NO;
            model.jiarenZhuangtai = NO;
            [dataArray addObject:model];
        }else if(i == data.count){
            //加人
            model.jiarenZhuangtai = YES;
            [dataArray addObject:model];
            
        }else if (i == data.count+1){
            //减号
            if ([[gr.owner lowercaseString] isEqualToString:[[[AppStore getYongHuID] lowercaseString] substringToIndex:20]]) {
                model.shanrenZhuangtai = YES;
                [dataArray addObject:model];
            }
        }
    }
    itemsBox.items = dataArray;
    [self size];
}

#pragma mark -
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == _XiugaiMingchengBtn) {
        //组名称
        if (![gr.owner isEqualToString:[[[AppStore getYongHuID] substringToIndex:20] lowercaseString]]&&gr.groupSetting.groupStyle==eGroupStyle_PrivateMemberCanInvite) {
            //无权修改
            //[weakSelf showHint:@"无权修改群组名称"];
            return;
        }else{
            XiugaiXinxiViewController *xiugai =[[XiugaiXinxiViewController alloc]init];
            xiugai.titleText = @"群组名称";
            xiugai.chuanzhiStr =_zuMingChengLabel.text;
            [self.navigationController pushViewController:xiugai animated:YES];
            xiugai.returnValue =^(NSString *ss){
                //self.title = ss;
                self.zuMingChengLabel.text = ss;
                [self xiugaiZuSubject:ss withforGroup:_chatter];
            };
        }
    }else if (sender==_exitionAction){
        //自己退出该群
        [self exitAction];
    }else{
        [self creatActionSheet];
    }
}
#pragma mark - 加人方法
//加人方法
- (void)jiarenFangfa{
    //记录下群组id
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
    
    XuanzeRenyuanViewController *xuanze =[[XuanzeRenyuanViewController alloc]init];
    xuanze.liaotian = YES;
    xuanze.isDetail = YES;
    xuanze.addArray = AllMembersID;
    if (_ConversationType ==eConversationTypeChat) {
        //是创建群组
        xuanze.isAddMenbers = NO;
    }else{
        xuanze.isAddMenbers = YES;
    }
    
    xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)jiarenHuitiao:(NSString *)addBuddys{
    NSMutableArray * menbers =[NSMutableArray array];
    //删除掉本身就在dcitembox上的对象
    for (NSString *subStrs in AllMembersID) {
        NSString *longSubStr = [[subStrs substringToIndex:20] lowercaseString];
        [menbers addObject:longSubStr];
    }
    
    [self hideHud];//隐藏掉所有的弹窗
    [LDialog showWaitBox:@"添加成员中"];
    __weak typeof(self) weakSelf = self;
    if ([NetWork isConnectionAvailable]) {
        [[EaseMob sharedInstance].chatManager asyncAddOccupants:menbers toGroup:_groupID welcomeMessage:@"欢迎加入" completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {
            [LDialog closeWaitBox];
            if (!error) {
                gr =group;
                [self addbuddyFinised:addBuddys withGroup:nil isAdd:kAdd];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [self showHint:NSLocalizedString(@"group.join.fail", @"again failed to join the group, please")];
            }
           
        } onQueue:nil];
    }
}

#pragma mark -  选人delegate
//name
- (void)jiaren{
    if (_xuanzhongArray.count) {
        [self addItemBox];
        NSMutableArray *temp =[NSMutableArray array];
        NSMutableArray *nameArr =[NSMutableArray array];
        for (XuanzeRenyuanModel *ml in _xuanzhongArray) {
            UserinfoByHuanxinSM *sm =[[UserinfoByHuanxinSM alloc]init];
            sm._id = ml.personsSM.userid;
            sm.name = ml.personsSM.name.length?ml.personsSM.name:@"AA";
            sm.imgurl =ml.personsSM.imgurl.length?ml.personsSM.imgurl:@"头像80.png";
            sm.phone = ml.personsSM.phone;
            
            [AllMembersID addObject:sm._id];
            [nameArr addObject:sm.name];
            [temp addObject:sm];
        }
        //
        [self jiarenHuitiao:[nameArr componentsJoinedByString:@","]];
        
        for (UserinfoByHuanxinSM *ml in membersArray) {
            UserinfoByHuanxinSM *sm =[[UserinfoByHuanxinSM alloc]init];
            sm._id = ml._id;
            sm.name = ml.name.length?ml.name:@"AA";
            sm.imgurl =ml.imgurl.length?ml.imgurl:@"头像80.png";
            sm.phone = ml.phone;
            [nameArr addObject:sm.name];
            [temp addObject:sm];
        }
        //更新最新的model
        membersArray = (NSArray *)temp;
        
        //只有自己才可以修改
        if ([[gr.owner lowercaseString] isEqualToString:[[[AppStore getYongHuID] substringToIndex:20] lowercaseString]]) {
            [self xiugaiZuSubject:[nameArr componentsJoinedByString:@","] withforGroup:_chatter];
        }
        
        [self HuoquQunzuXinxi:temp withType:YES withIsGroup:YES];
    }
}

#pragma mark － 删除人员
- (void)shanrenFangfa{
    [self addItemBox];
    [self HuoquQunzuXinxi:membersArray withType:NO withIsGroup:YES];
}

#pragma mark - 点击踢人按钮
//踢人方法
- (void)yichuFangfa:(NSString *)key{
    __weak typeof(self) weakSelf = self;
    for (NSString *subKey in AllMembersID) {
        if ([[[subKey substringToIndex:20] lowercaseString] isEqualToString:[[key substringToIndex:20] lowercaseString]]) {
            [LDialog showWaitBox:@"删除成员中"];
            [[EaseMob sharedInstance].chatManager asyncRemoveOccupants:@[[[key substringToIndex:20] lowercaseString]] fromGroup:_chatter completion:^(EMGroup *group, EMError *error) {
                
                NSMutableArray *empty=[NSMutableArray array];
                NSMutableArray *contans =[NSMutableArray array];
                if (!error) {
                    [LDialog closeWaitBox];
                    gr = group;
                    for (ZuyuanXinxiCellVM *cv in itemsBox.items) {
                        if ([cv.key isEqualToString:key]&&cv) {
                            [empty addObject:cv];
                            //
                            [self addbuddyFinised:cv.name withGroup:nil isAdd:kDelete];
                        }
                        if (cv.name&&cv&&![cv.key isEqualToString:key]) {
                            [contans addObject:cv.name];
                        }
                    }
                    
                    NSMutableArray *dd =[NSMutableArray array];
                    for (UserinfoByHuanxinSM *sm in membersArray) {
                        if (![sm._id isEqualToString:key]) {
                            [dd addObject:sm];
                        }
                    }
                    membersArray = (NSArray *)dd;
                   
                    [itemsBox removeItems:empty];
                    [AllMembersID removeObject:key];
                    
                    //修改名称
                    [self xiugaiZuSubject:[contans componentsJoinedByString:@","] withforGroup:_chatter];
                    //计算高度。
                    [self size];
                }else{
                    [weakSelf showHint:error.description];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark 退群和解散群组
- (void)exitAction
{
    __weak typeof(self) weakSelf = self;
    NSString *str=[[[AppStore getYongHuID] substringToIndex:20] lowercaseString];
    BOOL isRet=NO;
    for (EMGroup *ss in [[EaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:YES]) {
        if ([_chatter isEqualToString:ss.groupId]) {
            isRet =YES;
        }
    }
    if (isRet) {
        if (![gr.owner isEqualToString:str]) {
            //离开群组
            [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatter
                                                       completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
                if (error) {
                    [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
                }else{
                    if (reason ==eGroupLeaveReason_UserLeave) {
                        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                        //主动退出
                        [self addbuddyFinised:[AppStore getYongHuMima] withGroup:group.groupId isAdd:kExit];
                        
                        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_chatter deleteMessages:YES append2Chat:YES];
                        
                        [nc postNotificationName:@"exit" object:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            } onQueue:nil];
        }else{
            //管理员解散群组
            [[EaseMob sharedInstance].chatManager asyncDestroyGroup:_chatter
                                                         completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
                [weakSelf hideHud];
                if (error) {
                    [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
                }
                else{
                    //解散
                    [self addbuddyFinised:[AppStore getYongHuMima] withGroup:group.groupId isAdd:kExtion];
                    
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:_chatter deleteMessages:YES append2Chat:YES];
                    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                    [nc postNotificationName:@"exit" object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } onQueue:nil];
        }
    }else{
        [weakSelf showHint:@"没有找到该群组"];
    }
}

#pragma mark -
- (void)size{
    float page = (float)dataArray.count/5;
    int intPage = (int)dataArray.count/5;
    if(page > intPage)
        intPage += 1;
    //NSLog(@"ss%f %f",ScreenWidth,self.view.width);
    itemsBox.frame =CGRectMake(0, 0, ScreenWidth, intPage*100);
    _itemsView.frame=CGRectMake(0, 0, ScreenWidth, intPage*100);
    if (_zuyuanXinxiView.hidden) {
        _qingKongView.frame=CGRectMake(0, _itemsView.frame.origin.y+_itemsView.frame.size.height+16, self.view.width,44.f);
        
        UIImageView *breakline =[[UIImageView alloc]init];
        breakline.backgroundColor =[UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1];
        breakline.frame=CGRectMake(0, 0, self.view.width,1);
        [_qingKongView addSubview:breakline];
    }else{
        _zuyuanXinxiView.frame =CGRectMake(0, _itemsView.frame.origin.y+_itemsView.frame.size.height+16, self.view.width,50.f);
        _qingKongView.frame=CGRectMake(0, _zuyuanXinxiView.frame.origin.y+_zuyuanXinxiView.frame.size.height, self.view.width,44.f);
    }
    
    if (!_exitionAction.hidden) {
        //NSLog(@"---%f",self.view.height);
        CGRect frame =_qingKongView.frame;
        if (frame.size.height+frame.origin.y+124.f>ScreenHeight) {
          _exitionAction.frame =CGRectMake(15,frame.origin.y+frame.size.height+80, ScreenWidth-30, 44);
        }else{
            _exitionAction.frame =CGRectMake(15,ScreenHeight-124.f, ScreenWidth-30, 44);
        }
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.width, _exitionAction.frame.size.height+_exitionAction.frame.origin.y+15.);
}

- (void)fanhui{
    
}
#pragma mark -
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self size];
}

#pragma @人员数据
- (void)RenyuanShuju:(NSNotification *)not{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    
    _xuanzhongArray = [@[] mutableCopy];
    NSDictionary *dict = [not userInfo];
    _xuanzhongArray = [dict objectForKey:@"xuanzhongArray"];
    groupid = [dict objectForKey:@"groupId"];
    if (_ConversationType ==eConversationTypeChat) {
        //是创建群组
        [self chuangjianQunzuWithGroupid:groupid];
    }else{
        [self jiaren];
    }
}

- (void)chuangjianQunzuWithGroupid:(NSString *)groupId{
    //创建群组
    NSMutableArray *temp =[NSMutableArray arrayWithCapacity:0];
    if (_xuanzhongArray.count) {
        for (XuanzeRenyuanModel *model in _xuanzhongArray) {
            //name
            [nameArray addObject:model.personsSM.name.length?model.personsSM.name:@"AA"];
            //id
            [idArray addObject:model.personsSM.userid];
            //imgurl
            [TouxiangArray addObject:model.personsSM.imgurl];
            
            //移除掉自己
            if (![model.personsSM.userid isEqualToString:[AppStore getYongHuID]]) {
                //移除掉自己
                [temp addObject:model.personsSM.name.length?model.personsSM.name:@"AA"];
            }
        }
        
        ChatViewController *chat=[[ChatViewController alloc]initWithChatter:groupid isGroup:YES];
        //发动邀请消息
        chat.name = [nameArray componentsJoinedByString:@"、"];
        chat.idArray =idArray;
        chat.nameArray = nameArray;
        chat.imageUrlArray = TouxiangArray;
        //移除掉自己
        [chat sendTextMessage:[NSString stringWithFormat:@"%@邀请%@加入了群聊",[AppStore getYongHuMing],[temp componentsJoinedByString:@","]] withCreate:YES];
        [self.navigationController pushViewController:chat animated:YES];
    }
}

//修改群组名称
-(void)xiugaiZuSubject:(NSString *)ss
          withforGroup:(NSString *)chatter
{
    __weak typeof(self) weakSelf = self;
    if (ss&&chatter) {
        _zuMingChengLabel.text = ss;
        [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:ss forGroup:_chatter completion:^(EMGroup *group, EMError *error) {
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
            }else{
                //加人回调方法
                NSDictionary *dcc =[NSDictionary dictionaryWithObjectsAndKeys:ss,@"finishedChange", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeGroupSubject"  object:self userInfo:dcc];
            }
        } onQueue:nil];
    }
}

//加人或者是减人 发出邀请
-(void)addbuddyFinised:(NSString *)addbuddys
             withGroup:(NSString *)groupChatter
                 isAdd:(CertificationType) certification
{
    NSString *mine;
    if ([gr.owner isEqualToString:[[[AppStore getYongHuID] substringToIndex:20] lowercaseString]]) {
        mine = [AppStore getYongHuMing];
    }else{
        mine =[AppStore getYongHuMing];
    }
    
    NSString *insertMessage ;
    if (certification==kAdd) {
        //加 或者是创建
        insertMessage = [NSString stringWithFormat:@"%@邀请%@加入了群聊",mine,addbuddys];
    }else if (certification ==kDelete){
        //删除
        insertMessage = [NSString stringWithFormat:@"群主%@将%@移除了群聊",mine,addbuddys];
    }else if (certification ==kExit){
        //主动退出
        insertMessage = [NSString stringWithFormat:@"%@退出了群聊",mine];
    }else{
        //解散
        insertMessage = [NSString stringWithFormat:@"%@解散了群",mine];
    }
    //发送一条消息给群组
    [self insertMessageWithStr:insertMessage];
}

//插入一条消息到会话里
- (void)insertMessageWithStr:(NSString *)str
{
    if (_converSation) {
        NSDictionary *ext = nil;
        EMMessage *tempMessage =[ChatSendHelper sendTextMessageWithString:str toUsername:_chatter isChatGroup:YES requireEncryption:NO ext:ext withExtension:YES];
        //post一个通知给chatVC
        [[NSNotificationCenter defaultCenter] postNotificationName:@"insertCallMessage" object:tempMessage];
    }
}
@end
