//
//  QunzuYulanViewController.m
//  Lvpingguo
//
//  Created by linku on 14-9-26.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WenjianYulanViewController.h"
#import "TongzhiXiangViewController.h"
#import "GongZuoBaoGaoXiangQViewController.h"
@interface WenjianYulanViewController ()

@end

@implementation WenjianYulanViewController
{
    DCImagePreview * imagePre;
    DCDocumentPreview *dcoumentPre;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"查看附件";
    NSRange range = [[self.url lastPathComponent] rangeOfString:@"txt"];
    
    if (range.length){
        //        NSLog(@"body --- %@",body);
        NSData *txtData = [NSData dataWithContentsOfFile:self.url];
        //自定义一个编码方式
        [webView loadData:txtData MIMEType:@"text/txt" textEncodingName:@"GB2312" baseURL:nil];
        
    }else{
        [self yulan:self.url];
    }
}

- (void)backSel{
    [self fanhuiJiemian];

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    [self fanhuiJiemian];
    return NO;
}

- (void)fanhuiJiemian{
    NSArray *controllers =self.navigationController.viewControllers;
    
    //popToViewController （保证要跳转到的视图控制器对象在栈中存在）
    for (int i = 0; i < controllers.count; i++) {
        UIViewController *subController = [controllers objectAtIndex:i];
        if ([subController isKindOfClass:[TongzhiXiangViewController class]]) {
            [self.navigationController popToViewController:[controllers objectAtIndex:i] animated:YES];
            
        }
        
        if ([subController isKindOfClass:[GongZuoBaoGaoXiangQViewController class]]) {
            [self.navigationController popToViewController:[controllers objectAtIndex:i] animated:YES];
            
        }

    }
}

- (void)yulan:(NSString *)url{
    NSArray *arr = [url componentsSeparatedByString:@"."];
    NSString *houzui = [arr lastObject];
    if ([houzui isEqualToString:@"jpg"] || [houzui isEqualToString:@"png"]) {
        dcoumentPre = [[DCDocumentPreview alloc]init];
        [dcoumentPre acceptFile:url];
        [self.view addSubview:dcoumentPre];
    }else{
        dcoumentPre = [[DCDocumentPreview alloc]init];
        [dcoumentPre acceptFile:url];
        [self.view addSubview:dcoumentPre];
    }
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    imagePre.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight);
    dcoumentPre.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight);
    webView.frame=CGRectMake(0,0, ScreenWidth, ScreenHeight - NavHeight);
    
}

@end
