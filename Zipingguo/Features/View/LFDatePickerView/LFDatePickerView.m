//
//  LFDatePickerView.m
//  Doris
//
//  Created by lilufeng on 15/10/21.
//  Copyright © 2015年 LF. All rights reserved.
//

#import "LFDatePickerView.h"

@implementation LFDatePickerView


- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"LFDatePickerView" owner:self options:nil]lastObject];
        
    }
    return self;
}


- (void)setType:(UIDatePickerMode)type confirmCallBack:(ConfirmCallBack)confirmCallBack cancelCallBack:(CancelCallBack)cancelCallBack{

        _confirmCallBack = confirmCallBack;
        _cancelCallBack = cancelCallBack;
        _mDatePicker.datePickerMode = type;
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {

    ((CancelCallBack)_cancelCallBack)();
    
}

- (IBAction)confirm:(UIBarButtonItem *)sender {

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//    NSString *shijian = [dateFormatter stringFromDate:_mDatePicker.date];
//    NSLog(@"时间%@",shijian);
    _confirmCallBack(_mDatePicker.date);
}
@end
