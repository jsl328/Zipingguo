//
//  AiTeModel.h
//  Zipingguo
//
//  Created by lilufeng on 15/11/23.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XuanzeRenyuanModel.h"
@interface AiTeModel : NSObject
@property (nonatomic,copy) NSString *name;//拼接后的
@property (nonatomic,copy) NSString *ID;//id

@property (nonatomic,assign) NSRange range;//位置
@property (nonatomic,retain) XuanzeRenyuanModel *xuanzeRenyuanModel;
@end