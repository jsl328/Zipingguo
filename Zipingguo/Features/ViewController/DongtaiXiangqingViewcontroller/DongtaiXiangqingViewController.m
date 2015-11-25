//
//  DongtaiXiangqingViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/24.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DongtaiXiangqingViewController.h"
#import "UILabel+Extension.h"
#import "DCUrlDownloader.h"
#import "EMCDDeviceManager.h"
#import "UIKeyboardCoView.h"
#import "WeizhiViewVC.h"
#import "LianXiRenXiangQingViewController.h"
@interface DongtaiXiangqingViewController ()

@end

@implementation DongtaiXiangqingViewController
@synthesize dynamicSM;

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pinglunKuang  = [[PinglunKuangView alloc] init];
    pinglunKuang.fabiaoPinglun.placeholder = @"说点什么吧...";
    pinglunKuang.fabiaoPinglun.delegate = self;
    pinglunKuang.delegate = self;
    [self.view addSubview:pinglunKuang];
    
    dataArray = [@[] mutableCopy];
    modelArray = [@[] mutableCopy];
    
    self.navigationItem.title = @"动态详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addItemWithTitle:@"" imageName:@"收藏icon.png" selector:@selector(rightSelector:) location:NO];
    
    //单机
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTapsRequired = 1;
    
    [touxiang addGestureRecognizer:singleTapOne];
    
    [self.itemBtn setImage:[UIImage imageNamed:@"已收藏icon.png"] forState:UIControlStateSelected];
    
    [self loadData:YES];
    
    [self resetDibuViewFrameForKeyboard];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData:(BOOL)showWaithbox{
    
    if (showWaithbox) {
        [LDialog showWaitBox:@"数据加载中"];
    }
    [ServiceShell getDynamicDetailWithID:_dongtaiId Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfDynamicSM *model) {
        [LDialog closeWaitBox];
        if (!serviceContext.isSucceeded) {
            return ;
        }
        if (model.status == 0) {
            _model = model.dynamicSM;
            dynamicSM = _model;
            
            if ([dynamicSM.dynamic.createid isEqualToString:[AppStore getYongHuID]]) {
                [self.itemBtn setImage:[UIImage imageNamed:@"删除icon.png"] forState:UIControlStateNormal];
            }
            
            if (model.data1 == 1) {
                self.itemBtn.selected = YES;
            }
            
            if (dianzan || quxiaoDianzan || pinglun) {
                if (!self.tongzhi) {
                    _passValueFromxiangqing(_model,1);
                }
                
            }
            
            name.text = model.dynamicSM.dynamic.createname;
            [touxiang setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.dynamicSM.dynamic.createurl] fileName:@"头像100.png" Width:touxiang.frame.size.width];
            time.text = model.dynamicSM.dynamic.time;
            neirong.text = model.dynamicSM.dynamic.content;
            
            if (model.dynamicSM.dynamic.isrelation == 0) {
                guanzhuBtn.hidden = NO;
                quxiaoGuanzhuBtn.hidden = YES;
            }else if(model.dynamicSM.dynamic.isrelation == 1){
                guanzhuBtn.hidden = YES;
                quxiaoGuanzhuBtn.hidden = NO;
            }
            
            
            if (model.data1 == 1) {
                self.itemBtn.selected = YES;
            }
            
            [self sizeofClass];
        }else{
            self.itemBtn.hidden = YES;
            pinglunKuang.hidden = YES;
            [self showHint:model.msg];
            [scrollView removeFromSuperview];
        }
    }];
}

#pragma mark 内容大小
- (void)sizeofClass{
    
    float width = ScreenWidth-85;
    CGSize contentSize  = [neirong.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    //调整各个控件的frame,将计算好的size给到infoLabel
    neirong.frame = CGRectMake(neirong.x, neirong.y,width, contentSize.height);
    CGRect rect;
    rect.origin.y = 64.0;
    rect.size.height = 0;
    if (neirong.text.length != 0) {
        [self createYuyin:neirong.frame];
    }else{
        [self createYuyin:rect];
    }
}

#pragma mark 语音
- (void)createYuyin:(CGRect)rect{
    float yuyinHeight = 26.0;
    float yuyinWidth = 77.0;
    float panding = 5;
    for (int i = 0; i < _model.dysounds.count; i++) {
        DysoundsSM *dysoundsSM = [_model.dysounds objectAtIndex:i];
        yuyinView = [[YuyinView alloc] init];
        yuyinView.miaoshuLabel.text = [NSString stringWithFormat:@"%@''",dysoundsSM.spendtime];
        yuyinView.soundurl = [NSString stringWithFormat:@"%@%@",URLKEY,dysoundsSM.soundurl];
        yuyinView.frame = CGRectMake(80, rect.origin.y+rect.size.height+panding+i*(yuyinHeight+panding), yuyinWidth, yuyinHeight);
        yuyinView.delegate = self;
        yuyinView.guanbiBtn.hidden = YES;
        [scrollView addSubview:yuyinView];
    }
    
    if (_model.dysounds.count != 0) {
        [self createTupian:yuyinView.frame];
    }else{
        [self createTupian:rect];
    }
    
}

#pragma mark 图片
- (void)createTupian:(CGRect)rect{
    
    tupianUrlArray = [@[]mutableCopy];
    
    photos = [@[]mutableCopy];
    tpArray = [@[]mutableCopy];
    tupianArray = [@[]mutableCopy];
    
    CGRect f;
    for (int i = 0; i < _model.dyimgs.count; i++) {
        DyimgsSM *imgsSM = [_model.dyimgs objectAtIndex:i];
        float imageWidth = (ScreenWidth-95-10)/3.0;
        float imageHeight = (ScreenWidth-95-10)/3.0;
        float panding = 5.0;
        TupianView * imageView = [[TupianView alloc] init];
        imageView.shanchuBtn.hidden = YES;
        imageView.delegate = self;
        imageView.frame = CGRectMake(i%3*(imageWidth+panding)+80, rect.origin.y+rect.size.height+panding+i/3*(imageHeight+5), imageWidth, imageHeight);
        f = imageView.frame;
        
        [imageView.tupianImageBox setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,imgsSM.imgurl] fileName:@"图片110.png"];
        
        
        NSString *imageUrl = [imgsSM.imgurl stringByReplacingOccurrencesOfString:@"last" withString:@"big"];
        [tpArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLKEY,imageUrl]]];
        [tupianArray addObject:imageView];
        
        [scrollView addSubview:imageView];
    }
    
    if (_model.dyimgs.count != 0) {
        [self createZanPingShan:f];
    }else {
        [self createZanPingShan:rect];
    }
    
}

#pragma mark 位置
- (void)createWeizhi:(CGRect)rect{
    weizhiView = [[WeizhiView alloc] init];
    weizhiView.shanchuBtn.hidden = YES;
    weizhiView.weizhi.text = [self puanduanISNull:_model.dynamic.address];
    float panding = 5.0;
    weizhiView.shuxian.hidden = YES;
    weizhiView.frame = CGRectMake(80, rect.origin.y+rect.size.height+panding, ScreenWidth-95, 26);
    if (![weizhiView.weizhi.text isEqualToString:@""]) {
        [scrollView addSubview:weizhiView];
    }
    
    if (_model.dynamic.address.length != 0) {
        [self createZanPingShan:weizhiView.frame];
    }else{
        [self createZanPingShan:rect];
    }
}

#pragma mark 赞评删
- (void)createZanPingShan:(CGRect)rect{
    
    zanpingShanView = [[ZanPingShanView alloc] init];
    zanpingShanView.delegate = self;
    zanpingShanView.frame = CGRectMake(10, rect.origin.y+rect.size.height, ScreenWidth, 50);
    zanpingShanView.shanchuBtn.hidden = YES;
    zanpingShanView.addles.text = [self puanduanISNull:_model.dynamic.address];

    if (_model.dypraises.count != 0) {
        [zanpingShanView.dianzanBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_model.dypraises.count] forState:UIControlStateNormal];
        
        if (_model.dynamic.ispraise == 1) {
            zanpingShanView.dianzanBtn.selected = YES;
        }
    }
    
    if (_model.dycomments.count != 0) {
        [zanpingShanView.pinglunBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_model.dycomments.count] forState:UIControlStateNormal];
        
    }
    
    [scrollView addSubview:zanpingShanView];
    
    [self createZan:zanpingShanView.frame];
    
}

- (void)createZan:(CGRect)rect{
    
    for (UIView *subView in scrollView.subviews) {
  
        if ([subView isKindOfClass:[ZanView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (_model.dypraises.count != 0) {
        zanpingView = [[ZanView alloc] init];
        NSMutableArray *zanName = [@[]mutableCopy];
        for (int i = 0; i < _model.dypraises.count; i++) {
            if (i <= 5) {
                DypraisesSM *praisesSM;
                
                if (i < 5) {
                    praisesSM = [_model.dypraises objectAtIndex:i];
                    [zanName addObject:praisesSM.createname];
                    zanpingView.zanName.text = [zanName componentsJoinedByString:@","];
                }else{
                    zanpingView.zanName.text = [NSString stringWithFormat:@"%@等%ld人",[zanName componentsJoinedByString:@","],(unsigned long)_model.dypraises.count];
                }
                
            }
            
        }
        [zanpingView.zanName addAttributeWithString:zanpingView.zanName.text andColorValue:RGBACOLOR(52, 55, 68, 1) andUIFont:zanpingView.zanName.font andRangeString:[NSString stringWithFormat:@"等%ld人",(unsigned long)_model.dypraises.count]];
        
        zanpingView.frame = CGRectMake(15, rect.origin.y+rect.size.height, ScreenWidth-2*15, 40);
        [scrollView addSubview:zanpingView];
    }
    
    if (_model.dypraises.count != 0) {
        [self createPing:zanpingView.frame];
    }else{
        [self createPing:rect];
    }
}

- (void)createPing:(CGRect)rect{
    viewHeight = 0;
    listBox.delegate = self;
    for (UIView *subView in listBox.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            UITableView *tab = (UITableView *)subView;
            tab.scrollEnabled = NO;
        }
    }
    
    
    [dataArray removeAllObjects];
    [listBox setSeparatorColor:[UIColor clearColor]];
    [listBox setSelectedCellColor:RGBACOLOR(223, 229, 237, 1)];
    if (_model.dycomments.count != 0) {
        for (int i = 0; i < _model.dycomments.count; i++) {
            
            DycommentsSM *SM = [_model.dycomments objectAtIndex:i];
            DongtaiPinglunCellVM *pinglunCellVM = [[DongtaiPinglunCellVM alloc] init];
            
            pinglunCellVM.model = SM;
            
            if (i == 0) {
                pinglunCellVM.isIcon = YES;
            }else{
                pinglunCellVM.isIcon = NO;
            }
            NSString *content;
            if ([SM.isreply isEqualToString:@"0"]) {
                content = [NSString stringWithFormat:@"%@: %@",SM.createname,SM.content];
            }else{
                content = [NSString stringWithFormat:@"%@回复%@: %@",SM.createname,SM.relusername,SM.content];
            }
            
            CGSize pinglunsize = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth-2*15-52, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if(SM.content.length != 0)
                pinglunCellVM.cellHeight = pinglunsize.height+10;
            
            [self viewHeight:pinglunsize.height+10];
            pinglunCellVM.content = content;
            [dataArray addObject:pinglunCellVM];
        }
        listBox.items = dataArray;
        listBox.frame = CGRectMake(15, rect.origin.y+rect.size.height, ScreenWidth-2*15, viewHeight+13);
        
        listBox.hidden = NO;
        
    }else{
        listBox.hidden = YES;
        
    }
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, rect.origin.y+rect.size.height+viewHeight+64);
    
}

- (void)viewHeight:(float)size5{
    viewHeight += size5;
}

- (void)rightSelector:(UIButton *)btn{
    if ([dynamicSM.dynamic.createid isEqualToString:[AppStore getYongHuID]]) {
        [ServiceShell getDelMyDynamicWithID:dynamicSM.dynamic._id Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (!serviceContext.isSucceeded) {
                return ;
            }
            if (model.status == 0) {
                if (!self.tongzhi) {
                    _passValueFromxiangqing(_model,3);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        if (btn.selected) {
            
            [ServiceShell getCancelcollectCollectDynamicWithUserid:[AppStore getYongHuID] Dynamicid:dynamicSM.dynamic._id usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
                if (!serviceContext.isSucceeded) {
                    return ;
                }
                if (model.status == 0) {
                    btn.selected = NO;
                    if (!self.tongzhi) {
                        _passValueFromxiangqing(_model,3);
                    }
                }
            }];
   
        }else{
            
            [ServiceShell getCollectDynamicWithUserid:[AppStore getYongHuID] Dynamicid:dynamicSM.dynamic._id  usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
                if (!serviceContext.isSucceeded) {
                    return ;
                }
                if (model.status == 0) {
                    btn.selected = YES;
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == guanzhuBtn) {
        guanzhuBtn.hidden = YES;
        quxiaoGuanzhuBtn.hidden = NO;
        [ServiceShell getAttentionWithCreateid:[AppStore getYongHuID] Relid:dynamicSM.dynamic.createid usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (serviceContext.isSucceeded) {
                if (model.status == 0) {
//                    [self loadData];
                    if (!self.tongzhi) {
                        _passValueFromxiangqing(_model,2);
                    }
                }
            }
        }];
    }else if (sender == quxiaoGuanzhuBtn){
        guanzhuBtn.hidden = NO;
        quxiaoGuanzhuBtn.hidden = YES;
        [ServiceShell getCancelAttentionWithCreateid:[AppStore getYongHuID] Relid:dynamicSM.dynamic.createid usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (serviceContext.isSucceeded) {
                if (model.status == 0) {
//                    [self loadData];
                    if (!self.tongzhi) {
                        _passValueFromxiangqing(_model,2);
                    }
                }
            }
        }];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    guanzhuBtn.frame = CGRectMake(self.view.width-15-guanzhuBtn.frame.size.width, guanzhuBtn.frame.origin.y, guanzhuBtn.frame.size.width, guanzhuBtn.frame.size.height);
    quxiaoGuanzhuBtn.frame = CGRectMake(self.view.width-15-quxiaoGuanzhuBtn.frame.size.width, quxiaoGuanzhuBtn.frame.origin.y, quxiaoGuanzhuBtn.frame.size.width, quxiaoGuanzhuBtn.frame.size.height);
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    pinglunKuang.frame = CGRectMake(0, self.view.height-49, ScreenWidth, 49);
    [self.view bringSubviewToFront:pinglunKuang];
}

#pragma mark 代理

- (void)dianzanFangfa{
    [ServiceShell getDypraiseDynamicWithDynamicid:_model.dynamic._id Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfDynamicSM *model) {
        if (serviceContext.isSucceeded) {
            if (model.status == 0) {
                dianzan = YES;
                [self loadData:NO];
            }
        }
    }];
}

- (void)quxiaoDianzanFangfa{
    [ServiceShell getDypraiseDynamicWithCancelPraiseDynamicid:_model.dynamic._id Createid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfIListOfDynamicSM *model) {
        if (serviceContext.isSucceeded) {
            if (model.status == 0) {
                quxiaoDianzan = YES;
                [self loadData:NO];
                
            }
        }
    }];
}

- (void)pinglunFangfa{
//    [self.view bringSubviewToFront:pinglunKuang];
    [pinglunKuang.fabiaoPinglun becomeFirstResponder];
    pinglunKuang.Isreply = @"0";
    pinglunKuang.Topparid = @"0";
    pinglunKuang.ID = _model.dynamic._id;
}

- (void)listBox:(ListBox *)listBox didSelectItem:(id)data{
    [self.view bringSubviewToFront:pinglunKuang];
    DongtaiPinglunCellVM *pinglunCellVM = (DongtaiPinglunCellVM *)data;
    
    if ([pinglunCellVM.model.createid isEqualToString:[AppStore getYongHuID]]) {
        delPinglunid = pinglunCellVM.model._id;
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        
        action.actionSheetStyle =UIActionSheetStyleDefault;
        [action showInView:self.view];
    }else{
        pinglunKuang.fabiaoPinglun.placeholder = [NSString stringWithFormat:@"回复%@",pinglunCellVM.model.createname];
        [pinglunKuang.fabiaoPinglun becomeFirstResponder];
        pinglunKuang.Topparid = pinglunCellVM.model._id;
        pinglunKuang.Isreply = pinglunCellVM.model._id;
        pinglunKuang.ID = pinglunCellVM.model.dynamicid;
    }

}

- (void)TupianViewDidTap:(TupianView *)tapView{
    for(int i = 0;i < [tupianArray count];i++)
    {
        TupianView *imageBox = [tupianArray objectAtIndex:i];
        if([imageBox isEqual:tapView])
        {
            [self.messageReadManager showBrowserWithImages:tpArray];
            [self.messageReadManager showImageWithIndex:i];
            
            break;
        }
    }
}

- (void)BofangYuyin:(YuyinView *)luyinView{
    NSArray *arr = [luyinView.soundurl componentsSeparatedByString:@"."];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *path=[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"Downloaded/"];
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",DCMD5ForString(luyinView.soundurl),[arr lastObject]]];
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:pathName completion:^(NSError *error) {
        
    }];
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (void)yaoqingRenyuanFangfa{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
    XuanzeRenyuanViewController *xuanze = [[XuanzeRenyuanViewController alloc] init];
    xuanze.xuanzhongArray = modelArray;
    xuanze.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanze];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)fasongFangfaWithDongtaiID:(NSString *)dongtaiID Isreply:(NSString *)isreply Topparid:(NSString *)topparid{
    NSString *ids;
    if (atusers.count != 0) {
        ids = [atusers componentsJoinedByString:@","];
    }else{
        ids = @"";
    }
    if (dongtaiID.length == 0) {
        dongtaiID = _model.dynamic._id;
        isreply = @"0";
        topparid = @"0";
    }
    [ServiceShell getDycommentDynamicWithCreateid:[AppStore getYongHuID] Content:pinglunKuang.fabiaoPinglun.text Dynamicid:dongtaiID Isreply:isreply Topparid:topparid IDS:ids usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
        if (serviceContext.isSucceeded) {
            if (model.status == 0) {
                [pinglunKuang.fabiaoPinglun resignFirstResponder];
                pinglunKuang.fabiaoPinglun.text = @"";
                pinglun = YES;
                [self loadData:NO];
                pinglunKuang.fabiaoPinglun.placeholder = @"说点什么吧...";
                [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
                pinglunKuang.fasongBtn.userInteractionEnabled = NO;
                if (!self.tongzhi) {
                    _passValueFromxiangqing(_model,1);
                }
                
            }
            
        }
    }];
}

- (NSString *)puanduanISNull:(id)text{
    if (text == nil || [text isEqual:[NSNull null]] || text == NULL) {
        return @"";
    }else{
        return text;
    }
}

#pragma @人员数据
- (void)RenyuanShuju:(NSNotification *)not{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xuanzhongArray" object:nil];
    
    NSMutableArray *array = [@[] mutableCopy];
    atusers = [@[] mutableCopy];
    NSDictionary *dict = [not userInfo];
    modelArray = [dict objectForKey:@"xuanzhongArray"];
    for (XuanzeRenyuanModel *model in [dict objectForKey:@"xuanzhongArray"]) {
        [array addObject:model.personsSM.name];
        [atusers addObject:model.personsSM.userid];
    }
    
    if (array.count != 0) {
        [pinglunKuang.fabiaoPinglun becomeFirstResponder];
        NSString *wenzi =  [pinglunKuang.fabiaoPinglun.text substringFromIndex:YaoqingRenName.length];
        YaoqingRenName = [NSString stringWithFormat:@"@%@ ",[array componentsJoinedByString:@" @"]];
        pinglunKuang.fabiaoPinglun.text = [YaoqingRenName stringByAppendingString:wenzi];
        
        [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        pinglunKuang.fasongBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - 控制dibuview

- (void)resetDibuViewFrameForKeyboard
{
    /*
     不隐藏时 使用
     可以不遵守delegate
     */
    UIKeyboardCoView *view = [[UIKeyboardCoView alloc]initWithFrame:CGRectMake(0, self.view.height, ScreenWidth, 0)];
    view.beginRect = ^(CGRect beginRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            pinglunKuang.frame = CGRectMake(0, beginRect.origin.y-49, ScreenWidth, 49);
        }];
    };
    view.endRect = ^(CGRect endRect,CGFloat duration){
        [UIView animateWithDuration:duration animations:^{
            pinglunKuang.frame = CGRectMake(0, self.view.height-49, ScreenWidth, 49);
        }];
    };
    [self.view addSubview:view];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [pinglunKuang.fabiaoPinglun resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]) {
        [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon深"] forState:UIControlStateNormal];
        pinglunKuang.fasongBtn.userInteractionEnabled = YES;
    }else{
        [pinglunKuang.fasongBtn setImage:[UIImage imageNamed:@"发送icon浅"] forState:UIControlStateNormal];
        pinglunKuang.fasongBtn.userInteractionEnabled = NO;
    }
}

//单手势
-(void)handleSingleTap:(UIGestureRecognizer *)ges
{
    LianXiRenXiangQingViewController *xinxi = [[LianXiRenXiangQingViewController alloc] init];
    xinxi.ID = self.dynamicSM.dynamic.createid;
    [self.navigationController pushViewController:xinxi animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([textView.text quKongGe].length == 0) {//去掉空格回车后的字符串
            textView.text = @"";
            return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }else{
            NSLog(@"发送");
            [self fasongFangfaWithDongtaiID:pinglunKuang.ID Isreply:pinglunKuang.Isreply Topparid:pinglunKuang.Topparid];
            return NO;
        }
    }
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (buttonIndex == 0) {
            NSLog(@"ff");
            [ServiceShell DydelWithCreateid:[AppStore getYongHuID] ID:delPinglunid Dynamicid:self.dongtaiId usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
                if (model.status == 0) {
                    pinglun = YES;
                    [self loadData:NO];
                }else{
                    [SDialog showTipViewWithText:model.msg hideAfterSeconds:1.5f];
                }
            }];
            
        }
    }
}

@end
