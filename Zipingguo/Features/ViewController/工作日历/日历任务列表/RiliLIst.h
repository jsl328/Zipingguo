//
//  RiliLIst.h
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RIlilistCellVM;
@protocol RIliDelegate<NSObject>
-(void)rilibianji:(RIlilistCellVM*)vm;
-(void)huidaojintian;


@end

@interface RiliLIst : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)id<RIliDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *touVIew;
@property (strong, nonatomic) IBOutlet UILabel *RI;
@property (strong, nonatomic) IBOutlet UILabel *xingqi;
@property (strong, nonatomic) IBOutlet UILabel *nianyue;
@property (strong, nonatomic) IBOutlet UIButton *jintbtn;
- (IBAction)jintianAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *riliTableView;
@property (nonatomic,strong)NSMutableArray *shuju;
+ (instancetype)riliTableView;
@end
