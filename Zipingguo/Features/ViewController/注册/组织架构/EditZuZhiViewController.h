//
//  EditZuZhiViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/11/11.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface EditZuZhiViewController : WaiweiParentsViewController
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) void(^editFinish)(void);
@end
