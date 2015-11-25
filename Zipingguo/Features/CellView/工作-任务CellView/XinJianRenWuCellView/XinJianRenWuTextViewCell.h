//
//  XinJianRenWuTextViewCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinJianRenWuModel.h"
#import "UIPlaceHolderTextView.h"

@protocol XinJianRenWuTextViewCellDelegate <NSObject>

- (void)textViewText:(NSString *)text tag:(NSInteger)tag;
@end

@interface XinJianRenWuTextViewCell : UITableViewCell<UITextViewDelegate>
{
    
    __weak IBOutlet UIView *tipView;
    __weak IBOutlet UILabel *titleNameLabel;
}
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *bianJiTF;

- (void)bindDataWithModel:(XinJianRenWuModel *)model;
@property (nonatomic,assign) id <XinJianRenWuTextViewCellDelegate> delegate;

@end
