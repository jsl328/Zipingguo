//
//  PinglunKuangView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/25.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@protocol PinglunKuangViewDelegate <NSObject>

- (void)yaoqingRenyuanFangfa;

- (void)fasongFangfaWithDongtaiID:(NSString *)dongtaiID Isreply:(NSString *)isreply Topparid:(NSString *)topparid;

@end

@interface PinglunKuangView : UIView

@property (nonatomic, strong) id <PinglunKuangViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *yaoqingRenBtn;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *fabiaoPinglun;
@property (weak, nonatomic) IBOutlet UIButton *fasongBtn;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *Isreply;

@property (nonatomic, strong) NSString *Topparid;

@end
