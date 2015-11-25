//
//  TongxunluModel.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TongxunluModel;
@protocol TongxunluModelDelegate <NSObject>

-(void)callNumber:(TongxunluModel *)model;

-(void)chatMessage:(TongxunluModel *)model;

-(void)smsMessage:(TongxunluModel *)model;

@end

@interface TongxunluModel : NSObject
@property (nonatomic, strong) id <TongxunluModelDelegate> delegate;
@property (nonatomic, strong) YonghuInfoDB *personsSM;

@property (nonatomic,strong) NSAttributedString *showName;

@end
