//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
//日期文字状态MH
- (void)initView{
    
    //选中时显示的图片
    //    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 20, self.bounds.size.width-10, self.bounds.size.width-10)];
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width)];
    //    imgview.image = [UIImage imageNamed:@"chack.png"];
    imgview.backgroundColor=[UIColor whiteColor];
    [self addSubview:imgview];
    HongdianView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-12, 20, 6, 6)];
    HongdianView.image = [UIImage imageNamed:@"提醒红点"];
    [self addSubview:HongdianView];
    
    self.backgroundColor=[UIColor clearColor];
    
    
    //日期
    if (ScreenWidth==414) {
        day_lab =[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 20)];
    }else{
        day_lab =[[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-35, self.bounds.size.width, 20)];
    }
    
    
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:day_lab];
    //    day_lab.backgroundColor=[UIColor redColor];
    //农历
    
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-20)];
    day_title.textColor =COLOR_THEME ;
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    //    day_title.backgroundColor=[UIColor yellowColor];
    [self addSubview:day_title];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    dateComponent = [calendar components:unitFlags fromDate:now];
    
    
    
    
}



- (void)setModel:(CalendarDayModel *)model
{
    
    
    switch (model.style) {
            
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            if (model.ishongdian==YES) {
                HongdianView.hidden=NO;
            }else{
                HongdianView.hidden=YES;
            }
            
            NSLog(@"今天");
            
            
            
            
            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor=COLOR_THEME;
                day_title.textColor=COLOR_THEME;
                
            }
            
            day_lab.textColor = [UIColor colorWithRed:40/256.0  green:41/256.0 blue:53/256.0 alpha:1];
            day_title.text = model.Chinese_calendar;
            day_title.textColor=COLOR_THEME;
            imgview.hidden = YES;
            if (model.ishongdian==YES) {
                HongdianView.hidden=NO;
            }else{
                HongdianView.hidden=YES;
            }
            
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            
            if (model.holiday) {
                if (model.ishongdian==YES) {
                    HongdianView.hidden=NO;
                }else{
                    HongdianView.hidden=YES;
                }
                
                day_lab.text = model.holiday;
                day_lab.textColor = COLOR_THEME;
                day_title.textColor=COLOR_THEME;
            }else{
                
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor = COLOR_THEME;
                day_title.textColor=COLOR_THEME;
                NSLog(@"%lu",(unsigned long)model.day);
                
                
                
                if (model.day==dateComponent.day&&model.month==dateComponent.month) {
                    
                    NSLog(@"当天");
                    day_lab.textColor =[UIColor colorWithRed:70/256.0  green:184/256.0 blue:241/256.0 alpha:1];
                    day_title.textColor = [UIColor colorWithRed:70/256.0  green:184/256.0 blue:241/256.0 alpha:1];
                    
                    
                }
                
                
            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            if (model.ishongdian==YES) {
                HongdianView.hidden=NO;
            }else{
                HongdianView.hidden=YES;
            }
            
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor  colorWithRed:40/256.0  green:41/256.0 blue:53/256.0 alpha:1];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor = COLOR_THEME1;
                day_title.textColor=COLOR_THEME1;
            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            if (model.ishongdian==YES) {
                HongdianView.hidden=NO;
            }else{
                HongdianView.hidden=YES;
            }
            
            break;
        case CellDayTypejintian://今天日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor  colorWithRed:40/256.0  green:41/256.0 blue:53/256.0 alpha:1];
                
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor =[UIColor colorWithRed:70/256.0  green:184/256.0 blue:241/256.0 alpha:1];
                day_title.textColor = [UIColor colorWithRed:70/256.0  green:184/256.0 blue:241/256.0 alpha:1];
                ;
            }
            day_title.text = model.Chinese_calendar;
            imgview.hidden = NO;
            NSLog(@"hehe");
            if (model.ishongdian==YES) {
                HongdianView.hidden=NO;
            }else{
                HongdianView.hidden=YES;
            }
            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            if (model.ishongdian==YES) {
                HongdianView.hidden=NO;
            }else{
                HongdianView.hidden=YES;
            }
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            //            if (model.holiday) {
            //
            //            }else{
            //            }
            if (model.day==dateComponent.day&&model.month==dateComponent.month) {
                
                
                NSLog(@"当天");
                day_lab.textColor =[UIColor colorWithRed:70/256.0  green:184/256.0 blue:241/256.0 alpha:1];
                day_title.textColor = [UIColor colorWithRed:70/256.0  green:184/256.0 blue:241/256.0 alpha:1];
                
                
            }else{
                
                day_lab.textColor=COLOR_THEME1;
                day_title.textColor=COLOR_THEME1;
            }
            day_title.text = model.Chinese_calendar;
            imgview.hidden = NO;
            
            break;
            
        default:
            
            break;
    }
    
    
}



- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    
}


@end
