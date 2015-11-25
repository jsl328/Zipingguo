//
//  ARPhotoBrowser.m
//  Ariz
//
//  Created by HeHe丶 on 15/4/20.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import "ARPhotoBrowser.h"
#import "MBProgressHUD.h"
#import "ARPhotoImageView.h"

#define PADDING                  10


@interface ARPhotoBrowser ()<UIScrollViewDelegate,ARPhotoImageViewDelegate>

@end

@implementation ARPhotoBrowser{
    MBBarProgressView *_processView;
    NSMutableArray *_photoArray;
    UIScrollView *_pagingScrollView;
    int _currentPage;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (id)init{
    self = [super init];
    if (self) {
        _photoArray = [NSMutableArray alloc].init;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)removePhotoBrowser{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBrowserWithImages:(NSArray *)imageArray{
    if (imageArray && [imageArray count] > 0) {
        [_photoArray removeAllObjects];
        for (id object in imageArray) {
            ARPhoto *photo = nil;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [[ARPhoto alloc] initWithImage:object];
            }else if ([object isKindOfClass:[NSURL class]]){
                photo = [[ARPhoto alloc] initWithURL:object];
            }else if ([object isKindOfClass:[NSString class]]){
                photo = [[ARPhoto alloc] initWithURL:[NSURL URLWithString:object]];
            }
            [_photoArray addObject:photo];
        }
    }
    if (_photoArray.count) {
        [self addScroll];
        [self addImages];
        [self loadImage];
    }

    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    
    nav.navigationBarHidden = YES;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [rootController presentViewController:nav animated:YES completion:nil];


}



- (void)addScroll{
    if (!_pagingScrollView) {
        _pagingScrollView = [UIScrollView alloc].init;
        _pagingScrollView.delegate = self;
        _pagingScrollView.frame = [self frameForPagingScrollView];
        _pagingScrollView.pagingEnabled = YES;
        _pagingScrollView.contentSize = CGSizeMake(_pagingScrollView.frame.size.width * _photoArray.count, self.view.bounds.size.height);
        [self.view addSubview:_pagingScrollView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePhotoBrowser)];
//        [_pagingScrollView addGestureRecognizer:tap];
    }
    [self clearSubviews];
}

- (void)addImages{
    for (int i = 0; i < _photoArray.count; i++) {
        ARPhotoImageView *imageView = [ARPhotoImageView alloc].init;
        imageView.delegate = self;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.tag = 100 + i;
        CGRect f = _pagingScrollView.bounds;
        f.origin.x = i * f.size.width + PADDING;
        f.size.width = self.view.bounds.size.width;
        imageView.frame = f;
        [_pagingScrollView addSubview:imageView];
    }
}

- (void)loadImage{
    ARPhotoImageView *imageView = (ARPhotoImageView *)[_pagingScrollView viewWithTag:100 + _currentPage];
    [imageView bind:_photoArray[_currentPage]];
}


- (void)showImageWithIndex:(int)index{
    if (index >= _photoArray.count) {
        return;
    }
    _currentPage = index;
    [_pagingScrollView setContentOffset:CGPointMake(index * _pagingScrollView.bounds.size.width, 0)];
    [self loadImage];
}

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}

- (void)clearSubviews{
    for (UIView *view in _pagingScrollView.subviews) {
        [view removeFromSuperview];
    }
}

///将上一张图还原到初始大小
- (void)removeLastImageScale{
    ARPhotoImageView *imageView = (ARPhotoImageView *)[_pagingScrollView viewWithTag:100 + _currentPage];
    [imageView scaleTo1];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_currentPage != _pagingScrollView.contentOffset.x / _pagingScrollView.bounds.size.width) {
        [self removeLastImageScale];
    }
    _currentPage = _pagingScrollView.contentOffset.x / _pagingScrollView.bounds.size.width;

    [self loadImage];
}

- (void)ARPhotoImageViewSingleTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (UIView *sub in _pagingScrollView.subviews) {
        if ([sub isKindOfClass:[ARPhotoImageView class]]) {
            [(ARPhotoImageView *)sub cancel];
        }
    }
}






@end
