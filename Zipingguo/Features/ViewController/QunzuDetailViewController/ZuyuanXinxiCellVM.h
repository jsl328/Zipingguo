//
//  ZuyuanXinxiCellVM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZuyuanXinxiCellVM;
@protocol ZuyuanXinxiCellVMDelegate <NSObject>
@optional
- (void)jiarenFangfa;

- (void)shanrenFangfa;

- (void)yichuFangfa:(NSString *)key;

-(void)shanchu:(ZuyuanXinxiCellVM*)vm;

@end
@interface ZuyuanXinxiCellVM : NSObject
@property (nonatomic, strong) id <ZuyuanXinxiCellVMDelegate> delegate;
@property (nonatomic, strong) NSString *touxiangString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL jiarenZhuangtai;
@property (nonatomic, assign) BOOL shanrenZhuangtai;
@property (nonatomic, assign) BOOL anNiuZhuangtai;
@property (nonatomic,strong) NSString *key;
@end
