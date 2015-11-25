//
//  UploadHelper.h
//  Zipingguo
//
//  Created by lilufeng on 15/11/11.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadHelper : NSObject

@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);
@property (copy, nonatomic)  void (^singleFailureBlock)();

+ (instancetype)sharedInstance;

@end
