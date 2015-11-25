//
//  ListView.h
//  Doris
//
//  Created by lilufeng on 15/11/23.
//  Copyright © 2015年 LF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ListViewAlignment) {
//    ListViewAlignmentLeft,
    ListViewAlignmentCenter,
    ListViewAlignmentRight
};


@interface ListView : DCDialog{

    id _buttonClickCallback;
    NSArray* _items;
    NSArray* _images;
    UIView *_bgView;
    UIView *btnView;
    ListViewAlignment _alignment;
    NSArray* _bgImages;
    NSInteger _currentIndex;

}
/**
 *  列表初始化
 *
 *  @param items               标题
 *  @param images              左边小图片
 *  @param alignment           位置
 *  @param buttonClickCallback buttonClickCallback description
 *
 *  @return ListView
 */
-(id)initWithItems:(NSArray *)items images:(NSArray *)images forAlignment:(ListViewAlignment)alignment Callback:(void (^)(int))buttonClickCallback;

- (void)show;

- (void)selectedIndex:(NSInteger)index;

@end
