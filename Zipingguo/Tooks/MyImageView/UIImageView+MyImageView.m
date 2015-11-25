//
//  UIImageView+MyImageView.m
//  Lvpingguo
//
//  Created by fuyonghua on 15-1-24.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "UIImageView+MyImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UIImageView (MyImageView)

- (void)setUrl:(NSString *)url fileName:(NSString *)fileName Width:(float)width{
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width/2;
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:fileName]];
}

- (void)setUrl:(NSString *)url fileName:(NSString *)fileName{

    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:fileName]];
}

@end
