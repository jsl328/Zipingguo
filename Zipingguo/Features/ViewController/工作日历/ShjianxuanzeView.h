//
//  ShjianxuanzeView.h
//  ziface
//
//  Created by miao on 15/7/23.
//  Copyright (c) 2015年 miao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^getTime)(NSString *str);
typedef void(^getshjian)(NSString *str);
@interface ShjianxuanzeView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *BgView;
@property (strong, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (strong, nonatomic) IBOutlet UIButton *quedingBtn;
//0请假1考勤记录
@property(nonatomic,assign)int zhuangtai ;
- (IBAction)quedingAction:(id)sender;
+ (instancetype)shijianView;
@property(nonatomic,copy)getTime getday;
@property(nonatomic,copy)getshjian getshjian;
@end
