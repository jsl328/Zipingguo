//
//  UploadHelper.m
//  Zipingguo
//
//  Created by lilufeng on 15/11/11.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "UploadHelper.h"

@implementation UploadHelper

+ (instancetype)sharedInstance
{
    static UploadHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UploadHelper alloc] init];
    });
    return _sharedInstance;
}


@end
