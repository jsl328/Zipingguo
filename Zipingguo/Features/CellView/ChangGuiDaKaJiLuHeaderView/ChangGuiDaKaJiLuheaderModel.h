//
//  ChangGuiDaKaJiLuheaderModel.h
//  Zipingguo
//
//  Created by sunny on 15/10/19.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangGuiDaKaJiLuModel.h"

@interface ChangGuiDaKaJiLuheaderModel : NSObject
@property (nonatomic,strong) NSMutableArray *dayArray;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *ri;
@property (nonatomic,copy) NSString *weekDay;
@property (nonatomic,assign) BOOL isTop;
@end
