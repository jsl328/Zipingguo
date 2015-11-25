//
//  XiaofenXuanrenViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaofenXuanrenViewController.h"
#import "XuanzeRenyuanCellView.h"
#import "XuanzeRenyuanModel.h"
#import "SousuoView.h"
#import "FenzuModel.h"
#import "FenzuViewCell.h"
#import "ZifenzuXuanrenViewController.h"
#import "FabiaoDongtaiViewController.h"
#import "ChatViewController.h"
#import "BianjiVC.h"
@interface XiaofenXuanrenViewController ()<UITextFieldDelegate>
{
    //原始数据源
    NSMutableArray *_dataArray;
    //用于存放搜索结果
    NSMutableArray *_resultArray;
    
    //原始数据源
    NSMutableArray *_sousuoDataArray;
    
    BOOL sousuo;
    
    SousuoView *sousuoView;
    
    UIScrollView *_scrollView;
    
    NSString *groupId;
}
@end

@implementation XiaofenXuanrenViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_xuanzhongArray.count != 0) {
        _passValueFromXuanzhong(_xuanzhongArray);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _resultArray = [[NSMutableArray alloc] init];
    _sousuoDataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = self.Title;
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 布局

- (void)initUI{
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    //    [self addItemWithTitle:@"取消" imageName:@"" selector:@selector(quxiaoSelector) location:YES];
    [self addItemWithTitle:@"确定" imageName:@"" selector:@selector(quedingSelector) location:NO];
    // Do any additional setup after loading the view from its nib.
    sousuoView = [[SousuoView alloc] init];
    sousuoView.sousuoTextField.delegate = self;
    sousuoView.frame = CGRectMake(0, 64, ScreenWidth, 50);
    [self.view addSubview:sousuoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:sousuoView.sousuoTextField];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, 0, 50)];
    [self.view addSubview:_scrollView];
    [self tianjiaTuanpian:_xuanzhongArray isDel:NO];
}
#pragma 确定按钮
- (void)quedingSelector{
    if (!self.liaotian) {
        //转交审批
        if (self.zhuanjiao) {
            if (_xuanzhongArray.count != 0) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self xuanzhongRenyuan];
                }];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                [self xuanzhongRenyuan];
            }];
        }
        
    }else{
        //发起聊天
        
        if (_xuanzhongArray.count==1) {
            if (self.isDetail) {
                [self chuangjianQunzu];
            }else{
                [self chuangjianDanliao];
            }
        }else{
            [self chuangjianQunzu];
        }
         
        
    }
}

- (void)xuanzhongRenyuan{
    if (_xuanzhongArray.count != 0) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_xuanzhongArray,@"xuanzhongArray",groupId,@"groupId",nil];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"xuanzhongArray" object:nil userInfo:dict];
    }
}

- (void)chuangjianDanliao{
    //发起聊天
    [self dismissViewControllerAnimated:NO completion:^{
        [self xuanzhongRenyuan];
    }];
}

- (void)chuangjianQunzu{
    if (_isAddMenbers){
        //群组加人
        if (_xuanzhongArray.count) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self xuanzhongRenyuan];
            }];
        }
    }else if (!_isAddMenbers){
        //创建群组
        if (_xuanzhongArray.count) {
            EMGroupStyleSetting *setting =[[EMGroupStyleSetting alloc]init];
            setting.groupStyle =eGroupStyle_PrivateMemberCanInvite;
            setting.groupMaxUsersCount =500;
            [self showHudInView:self.view hint:@"准备开始群聊"];
            
            NSMutableArray *Nametemp =[NSMutableArray arrayWithCapacity:0];
            NSMutableArray *IDtemp=[NSMutableArray arrayWithCapacity:0];
            for (XuanzeRenyuanModel *model in _xuanzhongArray) {
                //name
                [Nametemp addObject:model.personsSM.name.length?model.personsSM.name:@"AA"];
                //id number
                [IDtemp addObject:[[model.personsSM.userid substringToIndex:20] lowercaseString]];
            }
            
            for (NSString *endureid in _addArray) {
                [IDtemp addObject:[[endureid substringToIndex:20] lowercaseString]];
            }
            
            [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:[Nametemp componentsJoinedByString:@"、"] description:@"iOS" invitees:IDtemp initialWelcomeMessage:@"iOS" styleSetting:setting completion:^(EMGroup *group, EMError *error) {
                if (group && !error) {
                    [self hideHud];
                    groupId = group.groupId;
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self xuanzhongRenyuan];
                    }];
                }
            } onQueue:nil];
        }
    }
}

- (void)textFieldChanged{
    NSLog(@"%@",sousuoView.sousuoTextField.text);
    
    NSString *lang;
    if (IOSDEVICE) {
        lang = sousuoView.sousuoTextField.textInputMode.primaryLanguage;
    }else{
        lang = [[UITextInputMode currentInputMode] primaryLanguage];
    }
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [sousuoView.sousuoTextField markedTextRange];
        UITextPosition *position = [sousuoView.sousuoTextField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            [_resultArray removeAllObjects];
            
            for (XuanzeRenyuanModel *model in _sousuoDataArray) {
                NSRange range = [model.personsSM.name rangeOfString:sousuoView.sousuoTextField.text];
                if (range.location!=NSNotFound) {
                    //str符合搜索结果
                    sousuo = YES;
                    [_resultArray addObject:model];
                }
            }
            
        }
    }
    
    if (sousuoView.sousuoTextField.text.length == 0) {
        sousuo = NO;
    }
    
    [_tableView reloadData];
    
    
}

#pragma mark 填充数据

- (void)loadData{
    
    NSMutableArray *fenzuArray = [FenzuStores getAllWithGongsiID:[AppStore getGongsiID] Parid:_ID];
    NSMutableArray *yonghuArray = [YonghuStores getAllWithGongsiID:[AppStore getGongsiID] Deptid:_ID];
    
    for (YonghuInfoDB *infodb in yonghuArray) {
        XuanzeRenyuanModel *model = [[XuanzeRenyuanModel alloc] init];
        model.personsSM = infodb;
        
        if (_xuanzhongArray.count != 0) {
            for (XuanzeRenyuanModel *renyuan in _xuanzhongArray) {
                if ([renyuan.personsSM.userid isEqualToString:infodb.userid]) {
                    model.xuanzhong = YES;
                }
            }
        }
        
        for (NSString *add in _addArray) {
            if ([model.personsSM.userid isEqualToString:add]) {
                model.endure = YES;
            }
        }
        
        if (_endureArray.count != 0) {
            for (NSString *endureid in _endureArray) {
                if (![model.personsSM.userid isEqualToString:endureid]) {
                    [_dataArray addObject:model];
                    [_sousuoDataArray addObject:model];
                }
            }
        }else{
            [_dataArray addObject:model];
            [_sousuoDataArray addObject:model];
        }
    }
    
    for (FenzuInfoDB *db in fenzuArray) {
        FenzuModel *model = [[FenzuModel alloc] init];
        model.deptsSM = db;
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
    
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataArray objectAtIndex:indexPath.row] isKindOfClass:[FenzuModel class]]) {
        return 50;
    }else{
        return 60;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[_dataArray objectAtIndex:indexPath.row] isKindOfClass:[FenzuModel class]]) {
        
        FenzuModel *model = _dataArray[indexPath.row];
        if (model.deptsSM.isleaf == 0) {
            XiaofenXuanrenViewController *xiaofenzu = [[XiaofenXuanrenViewController alloc] init];
            xiaofenzu.ID = model.deptsSM._id;
            xiaofenzu.Title = model.deptsSM.name;
            xiaofenzu.xuanzhongArray = _xuanzhongArray;
            xiaofenzu.endureArray = _endureArray;
            xiaofenzu.addArray = _addArray;
            xiaofenzu.liaotian = self.liaotian;
            xiaofenzu.shengpi = self.shengpi;
            xiaofenzu.chaosong = self.chaosong;
            xiaofenzu.zhuanjiao = self.zhuanjiao;
            xiaofenzu.isDetail = self.isDetail;
            xiaofenzu.isAddMenbers = self.isAddMenbers;
            xiaofenzu.passValueFromXuanzhong = ^ (NSMutableArray *xuanzhong){
                _xuanzhongArray = xuanzhong;
                [self tianjiaTuanpian:xuanzhong isDel:NO];
            };
            
            [self.navigationController pushViewController:xiaofenzu animated:YES];
        }else{
            ZifenzuXuanrenViewController *zitongxunlu = [[ZifenzuXuanrenViewController alloc]init];
            zitongxunlu.ID = model.deptsSM._id;
            zitongxunlu.Title = model.deptsSM.name;
            zitongxunlu.liaotian = self.liaotian;
            zitongxunlu.xuanzhongArray = _xuanzhongArray;
            zitongxunlu.addArray = _addArray;
            zitongxunlu.endureArray = _endureArray;
            zitongxunlu.isDetail = self.isDetail;
            zitongxunlu.shengpi = self.shengpi;
            zitongxunlu.chaosong = self.chaosong;
            zitongxunlu.zhuanjiao = self.zhuanjiao;
            zitongxunlu.isAddMenbers = self.isAddMenbers;
            zitongxunlu.passValueFromXuanzhong = ^ (NSMutableArray *xuanzhong){
                _xuanzhongArray = xuanzhong;
                [self tianjiaTuanpian:xuanzhong isDel:NO];
            };
            
            [self.navigationController pushViewController:zitongxunlu animated:YES];
        }
        
    }else{
        XuanzeRenyuanModel *model;
        if (sousuo) {
            model = [_resultArray objectAtIndex:indexPath.row];
        }else{
            model = [_dataArray objectAtIndex:indexPath.row];
        }
        
        if (_addArray.count != 0) {
            for (NSString *add in _addArray) {
                if (![model.personsSM.userid isEqualToString:add]){
                    [self xuanrenWithModel:model];
                    break;
                }
            }
        }else{
            [self xuanrenWithModel:model];
        }
        
        [_tableView reloadData];
    }
}

- (void)xuanrenWithModel:(XuanzeRenyuanModel *)model{
    if (self.shengpi || self.zhuanjiao) {
        if (_xuanzhongArray.count == 0) {
            if (!model.endure) {
                model.xuanzhong = !model.xuanzhong;
            }
        }else{
            if (!model.endure) {
                model.xuanzhong = NO;
            }
        }
    }else{
        if (!model.endure) {
            model.xuanzhong = !model.xuanzhong;
        }
    }
    
    if (model.personsSM.imgurl.length == 0) {
        model.personsSM.imgurl = @"";
    }
    
    if (model.xuanzhong) {
        [_xuanzhongArray addObject:model];
        [self tianjiaTuanpian:_xuanzhongArray isDel:NO];
    }else{
        for (int i = 0; i < _xuanzhongArray.count; i++) {
            XuanzeRenyuanModel *renyuan = [_xuanzhongArray objectAtIndex:i];
            if ([renyuan.personsSM.userid isEqualToString:model.personsSM.userid]) {
                [_xuanzhongArray removeObjectAtIndex:i];
                [self tianjiaTuanpian:_xuanzhongArray isDel:YES];
            }
        }
    }
}

#pragma mark - table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //可以通过传递过来的tableView参数来判断，到底是通过哪个tableView调用的此方法
    return 1;
    
}


//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (sousuo) {
        return [_resultArray count];
    }else{
        return [_dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[_dataArray objectAtIndex:indexPath.row] isKindOfClass:[FenzuModel class]]) {
        FenzuViewCell *fenzuCell = [FenzuViewCell cellForTableView:tableView];
        FenzuModel *model = [_dataArray objectAtIndex:indexPath.row];
        fenzuCell.model = model;
        
        return fenzuCell;
        
    }
    XuanzeRenyuanCellView *tongxunluCell = [XuanzeRenyuanCellView cellForTableView:tableView];
    XuanzeRenyuanModel *model;
    
    if (sousuo) {
        model = [_resultArray objectAtIndex:indexPath.row];
        tongxunluCell.model =model;
    }else{
        model = [_dataArray objectAtIndex:indexPath.row];
        tongxunluCell.model =model;
        
    }
    return tongxunluCell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (IOSDEVICE) {
        _tableView.frame = CGRectMake(0, 50, ScreenWidth, ScreenHeight-50);
    }else{
        _tableView.frame = CGRectMake(0, 50, ScreenWidth, ScreenHeight-NavHeight-50);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UiTextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_xuanzhongArray.count == 0) {
        sousuoView.tubiao.hidden = YES;
        sousuoView.sousuoTextField.frame = CGRectMake(15, 0, ScreenWidth-15, 50);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_xuanzhongArray.count == 0) {
        sousuoView.tubiao.hidden = NO;
        sousuoView.sousuoTextField.frame = CGRectMake(38, 0, ScreenWidth-38, 50);
    }
    return [textField resignFirstResponder];
}

#pragma mark 动态布局
- (void)tianjiaTuanpian:(NSMutableArray *)photoS isDel:(BOOL)isDelete{
    
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float imageFrameWidth = 33.0;
    float imageFrameHeight = 33.0;
    float panding = 5.0;
    
    for (int i = 0; i < photoS.count; i++) {
        NSLog(@"---%@",[photoS objectAtIndex:i]);
        
        UIImageView *imageFrame = [[UIImageView alloc] init];
        imageFrame.frame = CGRectMake(10+(imageFrameWidth+panding)*i, (50-33)/2.0, imageFrameWidth, imageFrameHeight);
        
        if ([((XuanzeRenyuanModel *)[photoS objectAtIndex:i]).personsSM.imgurl isEqualToString:@"头像80.png"]) {
            [imageFrame setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,((XuanzeRenyuanModel *)[photoS objectAtIndex:i]).personsSM.imgurl] fileName:@"头像80.png" Width:imageFrameWidth];
            
        }else{
            
            [imageFrame setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,((XuanzeRenyuanModel *)[photoS objectAtIndex:i]).personsSM.imgurl] fileName:@"头像80.png" Width:imageFrameWidth];
            
        }
        
        [_scrollView addSubview:imageFrame];
        
    }
    sousuoView.tubiao.hidden = YES;
    CGPoint offset = _scrollView.contentOffset;
    int count;
    
    count = (ScreenWidth - panding  - 100)/(imageFrameWidth + panding);
    
    if (photoS.count >= count) {
        _scrollView.frame = CGRectMake(0, 64, count*40,50);
        sousuoView.shuxian.hidden = NO;
        sousuoView.shuxian.frame = CGRectMake(_scrollView.frame.size.width+_scrollView.frame.origin.x, 0, 1, 50);
        
        sousuoView.sousuoTextField.frame = CGRectMake(sousuoView.shuxian.frame.size.width+sousuoView.shuxian.frame.origin.x+10, 0, ScreenWidth-sousuoView.shuxian.frame.size.width-sousuoView.shuxian.frame.origin.x, 50);
        if (photoS.count > count) {
            if (isDelete) {
                offset.x -= (imageFrameWidth+panding);
            }else{
                offset.x += (imageFrameWidth+panding);
            }
            [_scrollView setContentOffset:offset animated:YES];
        }
        
    }else{
        sousuoView.shuxian.hidden = YES;
        if (photoS.count == 1 || photoS.count == 2) {
            _scrollView.frame = CGRectMake(0, 64, photoS.count*43,50);
        }else{
            _scrollView.frame = CGRectMake(0, 64, photoS.count*40,50);
        }
        
        if (photoS.count == 0) {
            sousuoView.tubiao.hidden = NO;
            sousuoView.sousuoTextField.frame = CGRectMake(38, 0, ScreenWidth-38, 50);
        }else{
            sousuoView.sousuoTextField.frame = CGRectMake(_scrollView.frame.size.width+_scrollView.frame.origin.x+10, 0, ScreenWidth-_scrollView.frame.size.width-_scrollView.frame.origin.x, 50);
        }
        
    }
    
    _scrollView.contentSize = CGSizeMake(photoS.count*40, 50);
    
    if (self.liaotian) {
        if (_xuanzhongArray.count != 0) {
            self.itemBtn.enabled = YES;
            [self.itemBtn setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateNormal];
        }else{
            self.itemBtn.enabled = NO;
            [self.itemBtn setTitleColor:RGBACOLOR(168, 171, 186, 1) forState:UIControlStateNormal];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _dataArray.count - 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    
}

@end
