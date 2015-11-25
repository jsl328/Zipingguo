//
//  ETIMonthHeaderView.m
//  CalendarIOS7
//
//  Created by miao Morissard on 3/9/15.
//  Copyright (c) 2015 Jerome Morissard. All rights reserved.
//



#import "CalendarMonthHeaderView.h"
#import "Color.h"

@interface CalendarMonthHeaderView ()
@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;
@property (nonatomic,weak)UIView *ToubuView;
@end


#define CATDayLabelWidth  40.0f
#define CATDayLabelHeight 20.0f

@implementation CalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    self.clipsToBounds = YES;
    
    //self.backgroundColor=[UIColor redColor];
    //UIView*imag=[[UIView alloc]init];
    //imag.frame=self.frame;
    //imag.backgroundColor=[UIColor redColor];
    //[self addSubview:imag];
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(-120.f, 1.0f, 300.0f, 30.f)];
    UILabel *YearLabel = [[UILabel alloc] initWithFrame:CGRectMake(-122.f, 16.0f, 300.0f, 30.f)];
    [masterLabel setBackgroundColor:[UIColor clearColor]];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    [YearLabel setBackgroundColor:[UIColor clearColor]];
    [YearLabel setTextAlignment:NSTextAlignmentCenter];
    [YearLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = COLOR_THEME;
    [self addSubview:self.masterLabel];
    self.YearLabel = YearLabel;
    self.YearLabel.textColor = COLOR_THEME;
    [self addSubview:self.YearLabel];
    
//    CGFloat xOffset = 5.0f;
//    CGFloat yOffset = 0.0f;
//    UIView*toubuView=[[UIView alloc]init];
//    toubuView.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,CATDayLabelHeight);
//    self.ToubuView=toubuView;
//    self.ToubuView.backgroundColor=[UIColor colorWithRed:40/255.0 green:41/255.0 blue:52/255.0 alpha:1];
//    [self addSubview:self.ToubuView];

    //一，二，三，四，五，六，日
/* UILabel *dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day1OfTheWeekLabel = dayOfTheWeekLabel;
    self.day1OfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.day1OfTheWeekLabel.textColor =[UIColor whiteColor];
    [self.ToubuView addSubview:self.day1OfTheWeekLabel];
//    [self addSubview:self.day1OfTheWeekLabel];

    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day2OfTheWeekLabel = dayOfTheWeekLabel;
    self.day2OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day2OfTheWeekLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.day2OfTheWeekLabel];
    [self.ToubuView addSubview:self.day2OfTheWeekLabel];

    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day3OfTheWeekLabel = dayOfTheWeekLabel;
    self.day3OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day3OfTheWeekLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.day3OfTheWeekLabel];
    [self.ToubuView addSubview:self.day3OfTheWeekLabel];

    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day4OfTheWeekLabel = dayOfTheWeekLabel;
    self.day4OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day4OfTheWeekLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.day4OfTheWeekLabel];
    [self.ToubuView addSubview:self.day4OfTheWeekLabel];

    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day5OfTheWeekLabel = dayOfTheWeekLabel;
    self.day5OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day5OfTheWeekLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.day5OfTheWeekLabel];
    [self.ToubuView addSubview:self.day5OfTheWeekLabel];

    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day6OfTheWeekLabel = dayOfTheWeekLabel;
    self.day6OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day6OfTheWeekLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.day6OfTheWeekLabel];
    [self.ToubuView addSubview:self.day6OfTheWeekLabel];

    xOffset += CATDayLabelWidth + 5.0f;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.day7OfTheWeekLabel = dayOfTheWeekLabel;
    self.day7OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day7OfTheWeekLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.day7OfTheWeekLabel];
    [self.ToubuView addSubview:self.day7OfTheWeekLabel];
    
    [self updateWithDayNames:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
*/

}

//设置 @"日", @"一", @"二", @"三", @"四", @"五", @"六"
- (void)updateWithDayNames:(NSArray *)dayNames
{
    for (int i = 0 ; i < dayNames.count; i++) {
        switch (i) {
            case 0:
                self.day1OfTheWeekLabel.text = dayNames[i];
                break;

            case 1:
                self.day2OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 2:
                self.day3OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 3:
                self.day4OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 4:
                self.day5OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 5:
                self.day6OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 6:
                self.day7OfTheWeekLabel.text = dayNames[i];
                break;
                
            default:
                break;
        }
    }
  
}

@end
