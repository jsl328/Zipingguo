//
//  ARPhotoImageView.h
//  Ariz
//
//  Created by HeHe丶 on 15/4/20.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARPhoto.h"

@protocol ARPhotoImageViewDelegate <NSObject>

- (void)ARPhotoImageViewSingleTap;

@end

@interface ARPhotoImageView : UIView

- (void)bind:(ARPhoto *)photo;

- (void)cancel;

@property (nonatomic,weak) id<ARPhotoImageViewDelegate> delegate;

///取消缩放
- (void)scaleTo1;




@end
