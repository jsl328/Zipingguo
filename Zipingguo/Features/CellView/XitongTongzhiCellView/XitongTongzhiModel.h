//
//  XitongTongzhiModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultModelOfIListOfNoticeSM.h"
@interface XitongTongzhiModel : NSObject
@property (nonatomic, strong) NoticeSM *noticeSM;

@property (nonatomic) int isRead;

@end