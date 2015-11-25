//
//  ParentsViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "Base64JiaJieMi.h"
@interface ParentsViewController ()

@end

@implementation ParentsViewController
@synthesize blurView;
@synthesize itemBtn;
@synthesize seg;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
    self.view.backgroundColor = Bg_Color;
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:16]};
    [self customBackItemIsHidden:NO];

}

//根据标题，设置titleView
- (void)addTitleViewWithTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
    self.navigationItem.titleView = titleLabel;
}

//设置Item(customBack)
- (void)customBackItemIsHidden:(BOOL)hidden{
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(0,0,18,18)];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"返回icon点击"] forState:UIControlStateSelected];
    [backbtn addTarget:self action:@selector(backSel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem;
    if (!hidden) {
       backItem =[[UIBarButtonItem alloc]initWithCustomView:backbtn];
    }
    self.navigationItem.leftBarButtonItem = backItem;

}

- (void)backSel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}

//设置Item(customView)
- (void)addItemWithTitle:(NSString *)title imageName:(NSString *)imageName selector:(SEL)selector location:(BOOL)isLeft{
     itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName.length == 0) {
        [itemBtn setFrame:CGRectMake(0,0,40,18)];
    }else{
        [itemBtn setFrame:CGRectMake(0,0,18,18)];
    }
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [itemBtn setTitleColor:RGBACOLOR(168, 171, 186, 1) forState:UIControlStateHighlighted];
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [itemBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    if (isLeft == YES) {
        self.navigationItem.leftBarButtonItem = item;

    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
}

//设置titleView(customView)
- (void)addSegmentedControlWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle selector:(SEL)selector{
    NSArray *array = [NSArray arrayWithObjects:leftTitle,rightTitle,nil];
    //创建一个分段选取器 (事件驱动型控件)
    //initWithItems 数组中元素为NString/UIImage,数组提供给分段选取器使用
    seg = [[UISegmentedControl alloc] initWithItems:array];
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    seg.tintColor= [UIColor whiteColor];
    seg.selectedSegmentIndex = 0;
    seg.frame = CGRectMake(0,0,150,30);
    [seg addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
}

//设置titleView(customView)
- (void)addXialaTitleViewWithTitle:(NSString *)title selector:(SEL)selector Dianji:(BOOL)dianji{
    
    //清除导航上的titleView的subviews
    for (UIView *subView in self.navigationItem.titleView.subviews) {
        [subView removeFromSuperview];
    }
    titleViewSubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    UIButton *titleViewbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleViewbtn setFrame:CGRectMake(0,0,100,30)];
    titleViewbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleViewbtn setTitle:title forState:UIControlStateNormal];
    [titleViewbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleViewbtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [titleViewSubview addSubview:titleViewbtn];
    
    UIImageView *upDownArrow = [[UIImageView alloc] initWithFrame:CGRectMake(100, 13, 9, 5)];
    if (dianji) {
        upDownArrow.image = [UIImage imageNamed:@"收起icon"];
        self.upArrowFlag =NO;
    }else{
        upDownArrow.image = [UIImage imageNamed:@"下拉icon"];
        self.upArrowFlag =YES;
    }
    [titleViewSubview addSubview:upDownArrow];
    self.navigationItem.titleView = titleViewSubview;
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setMoHuViewWithHeight:(float)moHuHeight{
    blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, moHuHeight)];
    [blurView setDynamic:NO];
    blurView.blurRadius = 10;
    blurView.tintColor = [UIColor clearColor];
    blurView.hidden = YES;
    [self.view addSubview:blurView];
}
- (void) showMoHuView{
    [UIView animateWithDuration:0.4f animations:^{
        blurView.frame = CGRectMake(0, ScreenHeight - NavHeight - blurView.height, ScreenWidth, blurView.height);
        blurView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}
- (void) hideMoHuView{
    [UIView animateWithDuration:0.6f animations:^{
        blurView.frame = CGRectMake(0, ScreenHeight - blurView.height - NavHeight + ScreenHeight, ScreenWidth, blurView.height);
        blurView.hidden = YES;
        
    } completion:^(BOOL finished) {
        [blurView removeFromSuperview];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
