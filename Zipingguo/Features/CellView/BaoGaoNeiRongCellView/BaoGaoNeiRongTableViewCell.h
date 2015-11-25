//
//  BaoGaoNeiRongTableViewCell.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaoGaoNeiRongTableViewCellModel;

@interface BaoGaoNeiRongTableViewCell : UITableViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *jinriLabel;
@property (weak, nonatomic) IBOutlet UIWebView *jinriWebView;
@property (weak, nonatomic) IBOutlet UILabel *mingriLabel;
@property (weak, nonatomic) IBOutlet UIWebView *mingriWebView;
@property (weak, nonatomic) IBOutlet UITextView *jinriTextView;
@property (weak, nonatomic) IBOutlet UITextView *mingriTextView;

+ (id)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) BaoGaoNeiRongTableViewCellModel *model;

@property (nonatomic,assign) BOOL isload;//是否加载

@end

@interface BaoGaoNeiRongTableViewCellModel : NSObject
@property (nonatomic) int leixing;//1-日报 2-周报 3-月报
@property (copy, nonatomic) NSString * jinrihtml;
@property (copy, nonatomic) NSString * mingrihtml;
@property (nonatomic,assign) float cellHeight;

@end