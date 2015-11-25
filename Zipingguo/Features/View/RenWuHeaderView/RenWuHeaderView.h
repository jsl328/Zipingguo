//
//  RenWuHeaderView.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenWuHeaderView : UIView
{
    __weak IBOutlet UILabel *firstLabel;
    __weak IBOutlet UIImageView *iconImageView;
    
    __weak IBOutlet UILabel *secondLabel;
}
@property (nonatomic,strong) void (^addRenWu)();
@property (nonatomic,assign) NSInteger section;
@end
