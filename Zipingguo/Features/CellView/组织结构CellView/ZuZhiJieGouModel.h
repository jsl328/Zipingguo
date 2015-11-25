//
//  ZuZhiJieGouModel.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RATreeNodeInfo.h"
@interface ZuZhiJieGouModel : NSObject

@property (nonatomic,assign) NSInteger cengJi;/**<第几层级*/
@property (nonatomic,assign) BOOL isEditing;/**<编辑状态  yes - 正在编辑 no - 编辑*/
@property (nonatomic,copy) NSString *jieGouID;/**<结构id*/
@property (nonatomic,copy) NSString *parentID;/**<父结构id*/
@property (nonatomic,assign) BOOL isShow;/**<展开状态 yes-展开 no-关闭*/
@property (nonatomic,assign) BOOL canDelete;/**<是否可删除*/
@property (strong, nonatomic) NSMutableArray *children;
@property (strong, nonatomic) NSMutableArray *tempChildren;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) BOOL isShowIcon;
@property (nonatomic,strong) ZuZhiJieGouModel *preModel;
@property (nonatomic,copy) NSString *odlName;/**<原来的名字*/
@property (nonatomic,assign) BOOL isDelete;/**<是否已经删除*/
@end
