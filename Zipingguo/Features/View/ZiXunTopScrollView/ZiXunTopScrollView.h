//
//  ZiXunTopScrollView.h
//  Zipingguo
//
//  Created by sunny on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>



#define KWidthForLeft 20.0f
#define KWidthForRight 20.0f
#define KTopButtonFont 14.0f
#define KRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define KButtonTagStart 1000
#define KJIAN_GE_HEIGHT 20.0f

@protocol ZiXunTopScrollViewDelegate <NSObject>
@optional
-(void)ZiXunTopScrollViewDelegateBarSelectedIndexChanged:(int)newIndex;
@end

@interface ZiXunTopScrollView : UIScrollView
@property (nonatomic, assign) int            selectedIndex; // 选中的页数
@property (nonatomic, strong) NSMutableArray *buttonArray;  // 存放所有的标题的点击按钮


@property (nonatomic, unsafe_unretained) id<ZiXunTopScrollViewDelegate>topViewDelegate;

/**
 *  初始化TopBar
 *
 *  @param frame      TopBar的frame
 *  @param titleArray 存放标题的数组
 *
 * */
-(id)initWithFrame:(CGRect)frame andItems:(NSArray*)titleArray;
//-(void)setLineOffsetWithPage:(float)page andRatio:(float)ratio;
-(void)selectIndex:(int)index withFlag:(BOOL)flag;
-(void)onClick:(id)sender;
@end
