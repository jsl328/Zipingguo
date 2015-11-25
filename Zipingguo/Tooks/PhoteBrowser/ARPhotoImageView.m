//
//  ARPhotoImageView.m
//  Ariz
//
//  Created by HeHe丶 on 15/4/20.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import "ARPhotoImageView.h"
#import "MBProgressHUD.h"

#import "MWCommon.h"

#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageOperation.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "DACircularProgressView.h"

@interface ARPhotoImageView ()<UIScrollViewDelegate>


@end

@implementation ARPhotoImageView{
//    BOOL _finishLoad;
    /// -1 失败 0 未加载 1 加载中  2成功
    int _loadStatus;
    DACircularProgressView *_loadingIndicator;
    id <SDWebImageOperation> _webImageOperation;
    UIImageView *_imageView;
    UIScrollView *_scrollView;
    BOOL _isTwiceTaping;
    float _touchX;
    float _touchY;
    float _currentScale;
    BOOL _isDoubleTapingForZoom;
    float _offsetY;
    float _offsetX;
    float kScreenWidth;
    float kScreenHeight;
    int kMaxZoom;
    CGSize imageSize;
    BOOL isZooming;

}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        kMaxZoom = 5;
        kScreenWidth = [UIScreen mainScreen].bounds.size.width;
        kScreenHeight = [UIScreen mainScreen].bounds.size.height;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale=kMaxZoom;
        _scrollView.minimumZoomScale=1;

        [self addSubview:_scrollView];
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor = [UIColor greenColor];
        [_scrollView addSubview:_imageView];
        [self addTaps];
    }
    return self;
}

- (void)addTaps{
    UITapGestureRecognizer *tapImgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandle)];
    tapImgView.numberOfTapsRequired = 1;
    tapImgView.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapImgView];
    
    UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
    tapImgViewTwice.numberOfTapsRequired = 2;
    tapImgViewTwice.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapImgViewTwice];
    [tapImgView requireGestureRecognizerToFail:tapImgViewTwice];
}

-(void)tapImgViewHandle{
    if(_isTwiceTaping){
        return;
    }
    NSLog(@"tap once");
    [self.delegate ARPhotoImageViewSingleTap];
}

-(void)tapImgViewHandleTwice:(UIGestureRecognizer *)sender{
    
    _touchX = [sender locationInView:sender.view].x;
    _touchY = [sender locationInView:sender.view].y;
    if(_isTwiceTaping){
        return;
    }
    _isTwiceTaping = YES;
    
    NSLog(@"tap twice");
    
    if(_currentScale > 1.0){
        _currentScale = 1.0;
        [_scrollView setZoomScale:1.0 animated:YES];
    }else{
        _isDoubleTapingForZoom = YES;
        [_scrollView setZoomScale:2 animated:YES];
    }
    _isDoubleTapingForZoom = NO;
    //延时做标记判断，使用户点击3次时的单击效果不生效。
    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.65];
}

-(void)twiceTaping{
    NSLog(@"no");
    _isTwiceTaping = NO;
}

- (void)bind:(ARPhoto *)photo{
    if (_loadStatus > 0) {///加载中或者加载成功 return
        return;
    }
    if (photo.photoType == ARPhotoTypeImage) {
        _imageView.image = ARPhotoTypeImage;
        _loadStatus = 2;
        _imageView.image = photo.image;
    }else if (photo.photoType == ARPhotoTypeURL){
            [self loadImageWithURL:photo.photoURL];
    }
}

- (void)loadImageWithURL:(NSURL *)url{
    if (!_loadingIndicator) {
        _loadingIndicator = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
        _loadingIndicator.userInteractionEnabled = NO;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            _loadingIndicator.thicknessRatio = 0.1;
            _loadingIndicator.roundedCorners = YES;
        } else {
            _loadingIndicator.thicknessRatio = 0.2;
            _loadingIndicator.roundedCorners = YES;
        }
        _loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_loadingIndicator];
    }
    _loadStatus = 1;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    _webImageOperation = [manager downloadWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"%ld %ld",(long)receivedSize,(long)expectedSize);
        if (expectedSize > 0) {
            float progress = receivedSize / (float)expectedSize;
            _loadingIndicator.progress = MAX(MIN(1, progress), 0);
        }
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        self->_webImageOperation = nil;
        if (!error) {
            CGSize tmpSize = image.size;
            if (tmpSize.width / kScreenWidth * kScreenHeight > tmpSize.height) {
                _offsetY = (kScreenHeight - kScreenWidth * tmpSize.height / tmpSize.width) /2.0f;
                imageSize = CGSizeMake(kScreenWidth, kScreenWidth * tmpSize.height / tmpSize.width);
            }else{
                _offsetX = (kScreenWidth - tmpSize.width * kScreenHeight / tmpSize.height) /2.0f;
                imageSize = CGSizeMake(tmpSize.width * kScreenHeight / tmpSize.height ,kScreenHeight);

            }
            _loadStatus = 2;
            _imageView.image = image;
        }else{
            _loadStatus = -1;
        }
        [_loadingIndicator removeFromSuperview];
        _loadingIndicator = nil;
    }];

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
/*
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    NSLog(@"contentOffset: %@",NSStringFromCGPoint(scrollView.contentOffset));
    NSLog(@"contentSize: %@",NSStringFromCGSize(scrollView.contentSize));
    NSLog(@"imageView frame :%@",NSStringFromCGRect(_imageView.frame));
//    return;
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    NSLog(@"adjust position,x:%f,y:%f",xcenter,ycenter);
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
    int kMaxZoom2 = 2;
    if(_isDoubleTapingForZoom){
        NSLog(@"taping center");
        xcenter = kMaxZoom2*(kScreenWidth - _touchX);
        ycenter = kMaxZoom2*(kScreenHeight - _touchY);
        if(xcenter > (kMaxZoom2 - 0.5) * kScreenWidth){//放大后左边超界
            xcenter = (kMaxZoom2 - 0.5) * kScreenWidth;
        }else if(xcenter <0.5*kScreenWidth){//放大后右边超界
            xcenter = 0.5*kScreenWidth;
        }
        if(ycenter > (kMaxZoom2 - 0.5)*kScreenHeight){//放大后左边超界
            ycenter = (kMaxZoom2 - 0.5)*kScreenHeight ;
        }else if(ycenter <0.5*kScreenHeight){//放大后右边超界
            ycenter = 0.5*kScreenHeight ;
        }
        NSLog(@"adjust postion sucess, x:%f,y:%f",xcenter,ycenter);
    }
//    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}
 */

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    _currentScale = scale;
//    CGPoint p = scrollView.contentOffset;
//    if ([self getOffsetX] > 0) {
//        p.x = [self getOffsetX];
//    }
//    if ([self getOffsetY] > 0) {
//        p.y = [self getOffsetY];
//    }
//    scrollView.contentOffset = p;
//    isZooming = NO;
//
//    NSLog(@"current scale:%f",scale);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    isZooming = YES;
}

- (float)getOffsetX{
    NSLog(@"_ 1   %.1f",(kScreenWidth - imageSize.width * _currentScale) / 2.0);
    return (kScreenWidth - imageSize.width * _currentScale) / 2.0;
}

- (float)getOffsetY{
    NSLog(@"_ 2   %.1f",(kScreenHeight - imageSize.height * _currentScale) / 2.0);
    return (kScreenHeight - imageSize.height * _currentScale) / 2.0;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (isZooming) {
//        return;
//    }
//    NSLog(@"__contentOffset: %@",NSStringFromCGPoint(scrollView.contentOffset));
//    NSLog(@"__contentSize: %@",NSStringFromCGSize(scrollView.contentSize));
//    NSLog(@"__imageView frame :%@",NSStringFromCGRect(_imageView.frame));
//    CGPoint offset = scrollView.contentOffset;
//
//    if ([self getOffsetX] > 0) {
//        offset.x = [self getOffsetX];
//    }else{
//        if (offset.x > kScreenWidth - _currentScale * _offsetX) {
//            offset.x = kScreenWidth - _currentScale * _offsetX;
//        }
//        if (offset.x < _currentScale * _offsetX) {
//            offset.x = _currentScale * _offsetX;
//        }
//    }
//    if ([self getOffsetY] > 0) {
//        offset.y = [self getOffsetY];
//    }else{
//        if (offset.y > kScreenHeight - _currentScale * _offsetY) {
//            offset.y = kScreenHeight - _currentScale * _offsetY;
//        }
//        if (offset.y < _currentScale * _offsetY) {
//            offset.y = _currentScale * _offsetY;
//        }
//    }
//    
//    [scrollView setContentOffset:offset];
//
//}

- (void)cancel{
    if (_webImageOperation) {
        [_webImageOperation cancel];
    }
}

- (void)scaleTo1{
    [_scrollView setZoomScale:1.0];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    _imageView.frame = self.bounds;
    _loadingIndicator.center = _imageView.center;
}


@end
