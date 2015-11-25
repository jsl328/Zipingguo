//
//  WaiweiParentsViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface WaiweiParentsViewController ()

@end

@implementation WaiweiParentsViewController
@synthesize itemBtn;
@synthesize backbtn;
@synthesize blurView;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: RGBACOLOR(53, 55, 68, 1),
                                                                    UITextAttributeFont : [UIFont systemFontOfSize:16]};
    [self customBackItemWithImage:@"back-icon蓝.png" Color:RGBACOLOR(4, 175, 245, 1) IsHidden:NO];
    
    // Do any additional setup after loading the view.
}


//设置Item(customBack)
- (void)customBackItemWithImage:(NSString *)image Color:(UIColor *)color IsHidden:(BOOL)hidden{
    backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(0,0,50,18)];
    
    [backbtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backbtn setTitleColor:color forState:UIControlStateNormal];

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
    [itemBtn setTitleColor:RGBACOLOR(4, 175, 245, 1) forState:UIControlStateNormal];
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


- (void)setMoHuViewWithHeight:(float)moHuHeight{
    blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, moHuHeight)];
    [blurView setDynamic:NO];
    blurView.blurRadius = 20;
    blurView.tintColor = [UIColor clearColor];
    blurView.hidden = YES;
    [ShareApp.window addSubview:blurView];
}

- (void) showMoHuViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        blurView.frame = CGRectMake(0, ScreenHeight - blurView.height, ScreenWidth, blurView.height);
        blurView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}
- (void) showMoHuView{
    [UIView animateWithDuration:0.4f animations:^{
        blurView.frame = CGRectMake(0, ScreenHeight - blurView.height, ScreenWidth, blurView.height);
        blurView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hideMoHuViewWithAnimationDuration:(float)duration{
    [UIView animateWithDuration:duration animations:^{
        blurView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, blurView.height);
        blurView.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}
- (void) hideMoHuView{
    [UIView animateWithDuration:0.4f animations:^{
        blurView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, blurView.height);
        blurView.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
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

@end
