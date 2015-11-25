//
//  XinJianRenWuModel.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinJianRenWuModel : NSObject

@property (nonatomic,copy) NSString *cellTypeName;
@property (nonatomic,copy) NSString *cellName;
@property (nonatomic,copy) NSString *cellValue;
@property (nonatomic,copy) NSString *taskContent;/**<任务内容*/
@property (nonatomic,copy) NSString *remark;/**<备注*/
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) NSInteger width;
@property (nonatomic,assign) BOOL isCanEdit;/**<是否可编辑*/
@end
