//
//  RootViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    // Do any additional setup after loading the view from its nib.
}

//UI布局
- (void)uiConfig{

//    if (IOSDEVICE) {
//        //iOS7之后的属性，设置为NO，会消除视图控制器对scrollView contentOffset的影响
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-49-NavHeight) style:UITableViewStylePlain];
    [_tableView setSeparatorColor:Fenge_Color];
    
    _tableView.delegate = self;
    _tableView.backgroundColor = Bg_Color;
    _tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = footerView;
    
    [self.view addSubview:_tableView];
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"子类必须重写此方法");
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"子类必须重写此方法");
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    footerView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
    return footerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView != _tableView) {
        return 0.01;
    }
    return 0;
}

@end
