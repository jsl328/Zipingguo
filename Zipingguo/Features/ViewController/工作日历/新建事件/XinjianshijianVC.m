//
//  XinjianshijianVC.m
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XinjianshijianVC.h"
#import "ShjianxuanzeView.h"
#import "RenWuSheZhiViewController.h"
#import "XinJianRenWuModel.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "RIliShall.h"

@interface XinjianshijianVC ()

@property (nonatomic,weak)ShjianxuanzeView *shijianView;
@property (nonatomic,assign,getter=isTimeClick)BOOL Timelick;

@end

@implementation XinjianshijianVC

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
    [self addItemWithTitle:@"保存" imageName:nil selector:@selector(baocun) location:NO];
   
    if (_ID!=nil) {
        self.title=@"修改事件";
        _biaotishurukuang.text=_biaoti;
        _riqiLable.text=_shijian;
        _beishushurukuang.text=_beizhu;
        _tixingLable.text=_tixingzhi;
        
        if ([_tixingzhi isEqualToString:@"不提醒"] ) {
            _tixingtupian.hidden=YES;
        }else{
            _tixingtupian.hidden=NO;
        }
        
    }else{
        self.title=@"新建事件";
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        self.riqiLable.text=[NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld:%02ld", (long)dateComponent.year, (long)dateComponent.month,(long)dateComponent.day,(long)dateComponent.hour,(long)dateComponent.minute];

        _shijian=[NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:00", (long)dateComponent.year, (long)dateComponent.month,(long)dateComponent.day,(long)dateComponent.hour,(long)dateComponent.minute];
    }

    [self setNoc];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setNoc{
    NSNotificationCenter * noc =[NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [noc addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardShow:(NSNotification *)notification{
  
    //判断时间view是否显示
    if (self.isTimeClick==YES) {
        [self removeTimeView];
        self.Timelick = NO;
    }

}
- (void)keyboardHidden:(NSNotification *)notification{
    
}

//保存
-(void)baocun
{
    if (_biaotishurukuang.text.length==0) {
        [LDialog showMessage:@"请填写标题"];
    }else{
        if (_ID==nil) {
            [self Chuangjian];
        }else{
            [self Xiugaishijian];
        }

    }
    
    
}
//创建事件
-(void)Chuangjian
{
    [LDialog showWaitBox:@"保存中..."];
   [RIliShall ChuangjianbeiwangluWithuserid:[AppStore getYongHuID] title:_biaotishurukuang.text remindmsg:_tixingLable.text companyid:[AppStore getGongsiID] content:_beishushurukuang.text endtime:_shijian usingCallback:^(DCServiceContext *Context, ChuangjianrilibeiwangSM *sm ) {
            [LDialog closeWaitBox];
       if (Context.isSucceeded==YES) {
           if (sm.status==0) {
               [self.delegate shijianshuanxin];
               [self.navigationController popViewControllerAnimated:YES];
           }else{
               [ToolBox Tanchujinggao:sm.msg IconName:nil];
           }
           
       }
   }];

}
//修改事件
-(void)Xiugaishijian
{
    [LDialog showWaitBox:@"保存中..."];
    [RIliShall XiugaibeiwangluWithID:_ID title:_biaotishurukuang.text remindmsg:_tixingLable.text content:_beishushurukuang.text endtime:_shijian usingCallback:^(DCServiceContext *Context, RIliShanchuSM *SM) {
        [LDialog closeWaitBox];
        if (Context.isSucceeded==YES) {
            if (SM.status==0) {
                NSLog(@"修改成功!");
                [self.delegate shijianshuanxin];
                 [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToolBox Tanchujinggao:SM.msg IconName:nil];
            }
        }
        
    }];
    
}
-(void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//日期
- (IBAction)riqiAction:(id)sender {
    
    if ([_biaotishurukuang isFirstResponder]) {
        [_biaotishurukuang resignFirstResponder];
    }else if ([_beishushurukuang isFirstResponder]){
        [_beishushurukuang resignFirstResponder];
    }
    _riribtn.selected=YES;
    if (self.isTimeClick==NO) {
        [self shijianxuanze];
        self.Timelick = YES;
    } else {
        [self removeTimeView];
        self.Timelick = NO;
        
    }

}
//时间选择View
-(void)shijianxuanze
{
    ShjianxuanzeView*TimeView=[  ShjianxuanzeView shijianView];
    if (_riribtn.selected==YES) {
        TimeView.getday = ^(NSString *str){
           
            _riqiLable.text=str;
            
        };
        TimeView.getshjian = ^(NSString *str){
            
            _shijian=str;
            
        };
        
    }
     self.shijianView=TimeView;
    [self.view addSubview:TimeView];
    TimeView.y = _riqiVIew.centerY;
    TimeView.x = (self.view.width -TimeView.width ) *0.5;
    [UIView animateWithDuration:0.2 animations:^{
        TimeView.y = CGRectGetMaxY(_riqiVIew.frame);
        TimeView.x=_riqiVIew.x;
        TimeView.width=self.view.width;
          self.fengexian.hidden=NO;
        _tixingVIew.y= CGRectGetMaxY(TimeView.frame);
        _beizhuView.y= CGRectGetMaxY(_tixingVIew.frame);
        
    }];
}
-(void)removeTimeView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.shijianView removeFromSuperview];
    }];
    _tixingVIew.y= CGRectGetMaxY(_riqiVIew.frame);
    _beizhuView.y= CGRectGetMaxY(_tixingVIew.frame);
    self.fengexian.hidden=YES;
}

//提醒
- (IBAction)tixingbtnAction:(id)sender {
    //判断时间view是否显示
    if (self.isTimeClick==YES) {
        [self removeTimeView];
        self.Timelick = NO;
    }

    RenWuSheZhiViewController *vc = [[RenWuSheZhiViewController alloc] init];
    if ([_beishushurukuang isFirstResponder]) {
        [_beishushurukuang resignFirstResponder];
    }else if ([_biaotishurukuang isFirstResponder]){
        [_biaotishurukuang resignFirstResponder];
    }
    vc.vcTitle =@"提醒";
    vc.subTitle = ^(NSString *name){
        _tixingLable.text = name;
        if (name==nil) {
             _tixingLable.text=@"不提醒";
        }
        if ([_tixingLable.text isEqualToString:@"不提醒"] ) {
           _tixingtupian.hidden=YES;
    
        }else{
        _tixingtupian.hidden=NO;
        }

    };
  
    [self.navigationController pushViewController:vc animated:YES];
    
    

}
@end
