//
//  WenJianTableViewCell.h
//  Zipingguo
//
//  Created by lilufeng on 15/11/6.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WenJianTableViewCellModel;



@protocol WenJianTableViewCellDelegate <NSObject>

-(void)wenJianTableViewCellDelete:(WenJianTableViewCellModel *)model;

@end

@interface WenJianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuPianImage;
- (IBAction)deleteClick:(id)sender;
@property (nonatomic, strong) WenJianTableViewCellModel *model;
@property (nonatomic, weak) id<WenJianTableViewCellDelegate> delegate;

+ (id)cellForTableView:(UITableView *)tableView;
@end



@interface WenJianTableViewCellModel : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * len;//大小
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) NSString *imagebase64;



//@property (copy, nonatomic) NSString *filename;//文件名称，若上传附件该字段不为空
//@property (copy, nonatomic) NSString *fileurl;//文件url地址，若上传附件改字段不为空
//@property (copy, nonatomic) NSString *filesize;//文件大小，若上传附件改字段不为空
@end