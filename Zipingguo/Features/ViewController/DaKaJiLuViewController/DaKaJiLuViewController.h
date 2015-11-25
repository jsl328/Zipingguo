//
//  DaKaJiLuViewController.h
//  Zipingguo
//
//  Created by sunny on 15/9/25.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

typedef NS_ENUM (NSInteger,JiLuType){
    JiLuTypeNone,
    JiLuTypeChangGui,
    JiLuTypeWaiChu
};

@interface DaKaJiLuViewController : ParentsViewController

@property (nonatomic,assign) BOOL isChangGui;
@end
