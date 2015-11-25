//
//  ShjianxuanzeView.m
//  ziface
//
//  Created by miao on 15/7/23.
//  Copyright (c) 2015年 miao. All rights reserved.
//

#import "ShjianxuanzeView.h"

@implementation ShjianxuanzeView
{
   int shijian;
}
+ (instancetype)shijianView
{
    
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ShjianxuanzeView" owner:nil options:nil] firstObject];
    
}
-(void)awakeFromNib{
//   _dataPicker.minimumDate = [NSDate date];
   //200 153 31
    
   [_dataPicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    _dataPicker.datePickerMode= UIDatePickerModeDateAndTime;
   
   
}
-(void)setZhuangtai:(int)zhuangtai
{
    if (zhuangtai==1) {
        
        shijian=zhuangtai;
       
    }
   
}
-(void)dateChange
{
    [self setShiJianShiJian];
}
-(void)setShiJianShiJian
{
    NSDate * date = _dataPicker.date;
    

//    NSDate * nowDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date];
        NSString*Time;
        NSString*shijianT;

        Time=[NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld:%02ld",(long)components.year, components.month,(long)components.day,  components.hour,components.minute];
    shijianT=[NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:00",(long)components.year, components.month,(long)components.day,  components.hour,components.minute];
  
            if (self.getday) {
                self.getday(Time);
            }
        if (self.getshjian) {
        self.getshjian(shijianT);
        }

    
    

}
-(void)pickerView: (UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setShiJianShiJian];
}

@end
