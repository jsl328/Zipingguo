//
//  LFDatePickerView.h
//  Doris
//
//  Created by lilufeng on 15/10/21.
//  Copyright © 2015年 LF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelCallBack)(void);
typedef void(^ConfirmCallBack)(NSDate *);


@interface LFDatePickerView : UIView
{

    CancelCallBack _cancelCallBack;
    ConfirmCallBack _confirmCallBack;
}


@property (strong, nonatomic) IBOutlet UIDatePicker *mDatePicker;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)confirm:(UIBarButtonItem *)sender;


- (void)setType:(UIDatePickerMode)type confirmCallBack:(ConfirmCallBack)confirmCallBack cancelCallBack:(CancelCallBack)cancelCallBack;

@end
