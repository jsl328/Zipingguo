//
//  ZiXunTopScrollView.m
//  Zipingguo
//
//  Created by sunny on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunTopScrollView.h"



@interface ZiXunTopScrollView ()
{
    UIView *lineView;
    CGRect _frame;
}
@end

@implementation ZiXunTopScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andItems:(NSArray*)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //        self.backgroundColor = [UIColor redColor];
        _frame = frame;
        _selectedIndex = 0;
        [self createButtonsWithTitlesArray:titleArray];
    }
    return self;
}
- (void)createButtonsWithTitlesArray:(NSArray *)titleArray{
    int width = KWidthForLeft;
    [self removeAllSubviews];
    _buttonArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < titleArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:KTopButtonFont];
        if (i == _selectedIndex) {
            [button setTitleColor:KRGBCOLOR(4, 175, 245) forState:UIControlStateNormal];
        }
        else{
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        NSString *title = [titleArray objectAtIndex:i];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = KButtonTagStart+i;
        float titlewidth=[self width:title heightOfFatherView:_frame.size.height - 10 textFont:[UIFont systemFontOfSize:KTopButtonFont]];
        
        button.frame = CGRectMake(width, 5, titlewidth, _frame.size.height - 10);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonArray addObject:button];
        width += titlewidth+KJIAN_GE_HEIGHT;
        
    }
    /// 如果btn个数少，应平分界面
    if (width < self.frame.size.width) {
        width = KWidthForLeft;
        float currentWidth = 0.0;
        for (int i = 0; i < _buttonArray.count; i ++ ) {
            UIButton *btn = _buttonArray[i];
            currentWidth += btn.frame.size.width;
        }
        float currentJian_Ge =  (self.frame.size.width - currentWidth)/(_buttonArray.count + 1);
        /**
         *  重新放置btn
         */
        UIButton *_currentBtn;
        for (int i = 0 ;i < _buttonArray.count ; i++) {
            UIButton *btn = _buttonArray[i];
            btn.frame = CGRectMake(CGRectGetMaxX(_currentBtn.frame) + currentJian_Ge, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
            _currentBtn = btn;
        }
    }
    
    self.contentSize = CGSizeMake(width, self.frame.size.height);
    self.showsHorizontalScrollIndicator = NO;
    
    
    CGRect rc  = [self viewWithTag:_selectedIndex+KButtonTagStart].frame;
    lineView = [[UIView alloc]initWithFrame:CGRectMake(rc.origin.x, self.frame.size.height - 2, rc.size.width, 2)];
    lineView.backgroundColor = KRGBCOLOR(4, 175, 245);
    [self addSubview:lineView];
}
-(void)onClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (_selectedIndex != btn.tag - KButtonTagStart)
    {
        [self selectIndex:(int)(btn.tag - KButtonTagStart) withFlag:NO];
    }
}

-(void)selectIndex:(int)index withFlag:(BOOL)flag
{
    for (UIButton *button in _buttonArray)
    {
        if (button.tag ==index + KButtonTagStart) {
            [button setTitleColor:KRGBCOLOR(4, 175, 245) forState:UIControlStateNormal];
        }
        else{
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    if (_selectedIndex != index)
    {
        
        _selectedIndex =  index;
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect lineRC  = [self viewWithTag:_selectedIndex+KButtonTagStart].frame;
//        NSLog(@"%@   %@",NSStringFromCGRect(lineRC),NSStringFromCGPoint(self.contentOffset));
        lineView.frame = CGRectMake(lineRC.origin.x, self.frame.size.height - 2, lineRC.size.width, 2);
        [UIView commitAnimations];
        
        if ( _topViewDelegate!= nil && [_topViewDelegate respondsToSelector:@selector(ZiXunTopScrollViewDelegateBarSelectedIndexChanged:)])
        {
            if (!flag) {
                [_topViewDelegate ZiXunTopScrollViewDelegateBarSelectedIndexChanged:_selectedIndex];
            }
            
        }
        
        if (lineRC.origin.x - self.contentOffset.x > self.frame.size.width * 2  / 3)
        {
            int index = _selectedIndex;
            if (_selectedIndex + 2 <= _buttonArray.count)
            {
                index = _selectedIndex + 1;
            }
            else if (_selectedIndex + 1 < _buttonArray.count)
            {
                index = _selectedIndex + 1;
            }
            CGRect rc = [self viewWithTag:index +KButtonTagStart].frame;
            rc.origin.x += KWidthForRight;
            [self scrollRectToVisible:rc animated:YES];
        }
        else if ( lineRC.origin.x - self.contentOffset.x < self.frame.size.width / 3)
        {
            int index = _selectedIndex;
            if (_selectedIndex - 2 >= 0)
            {
                index = _selectedIndex - 1;
            }
            else if (_selectedIndex - 1 >= 0)
            {
                index = _selectedIndex - 1;
            }
            CGRect rc = [self viewWithTag:index +KButtonTagStart].frame;
            rc.origin.x -= KWidthForRight;
            [self scrollRectToVisible:rc animated:YES];
        }
    }
    
    
}

-(CGFloat)width:(NSString *)contentString heightOfFatherView:(CGFloat)height textFont:(UIFont *)font{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    CGSize size = [contentString sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)];
    return size.width ;
#else
    NSDictionary *attributesDic = @{NSFontAttributeName:font};
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    return size.width;
#endif
}


@end
