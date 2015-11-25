//
//  ZiXunCommentCell.m
//  Zipingguo
//
//  Created by sunny on 15/11/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunCommentCell.h"
#import "UILabel+Extension.h"
#import "NSString+Ext.h"

@implementation ZiXunCommentCell
@synthesize huiFuTableView,huiFuDataArray;

- (void)awakeFromNib {
    // Initialization code
    huiFuTableView.delegate = self;
    huiFuTableView.dataSource = self;
    huiFuTableView.scrollEnabled = NO;
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
//    //代理
//    longPress.minimumPressDuration = 1.0;
//    [self addGestureRecognizer:longPress];

}
//- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)sender{
//    
//    if (![_model.createid isEqualToString:[AppStore getYongHuID]]) {
//        return;
//    }
//    
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        [LDialog showActionSheet:@[@"删除评论？"] callback:^(int index) {
//            if (index == 0) {
//                
//                //                    [ServiceShell DydelWithCreateid:[AppStore getYongHuID] ID:cellVM.model._id usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
//                //                        if (model.status == 0) {
//                //                            [cellVM.delegate DongtaiPinglunCellVMRemove:cellVM];
//                //                        }else{
//                //                            [SDialog showTipViewWithText:model.msg hideAfterSeconds:1.5f];
//                //                        }
//                //                    }];
//                
//            }
//        }];
//    }
//}

+ (ZiXunCommentCell *)cellForTableView:(UITableView *)tableView{
    ZiXunCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiXunCommentCell"];
    if (!cell) {
        cell =  [[[NSBundle mainBundle]loadNibNamed:@"ZiXunCommentCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setModel:(ZiXunCommentModel *)model{
    if (model) {
        _model = model;
        [touXiangImageView setUrl:[URLKEY stringByAppendingString:model.createurl] fileName:@"头像80.png" Width:touXiangImageView.size.width];
        singleHeightArray = [@[] mutableCopy];
        huiFuDataArray = [@[] mutableCopy];
        nameLabel.text = model.createname;
        timeLabel.text = model.createtime;
        nameLabel.frame = CGRectMake(nameLabel.x, nameLabel.y, ScreenWidth - nameLabel.x - 100, nameLabel.height);
        timeLabel.frame = CGRectMake(ScreenWidth - 70 - 15, timeLabel.y, 70, timeLabel.height);
        contentLabel.text = model.content;
        CGSize labelSize = [contentLabel getLabelSizeWithLabelMaxWidth:ScreenWidth - 70 - 15 MaxHeight:MAXFLOAT FontSize:[UIFont systemFontOfSize:14] LabelText:contentLabel.text];
        contentLabel.frame = CGRectMake(70, 32, ScreenWidth - 70 - 15, labelSize.height);
        if (CGRectGetMaxY(contentLabel.frame) <= CGRectGetMaxY(touXiangImageView.frame)) {
            topView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(touXiangImageView.frame) + 11);
        }else{
            topView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(contentLabel.frame) + 11);
        }
        
        huiFuTableView.hidden = NO;
        float huiFuTableHeight = 0.0f;
        if (model.childComments.count > 3) {
            huiFuTableHeight = 0.0f;
            if (model.isExpand == YES) {
                [huiFuDataArray addObjectsFromArray:model.childComments];
            }else{
                [huiFuDataArray addObject:model.childComments[0]];
                [huiFuDataArray addObject:model.childComments[1]];
                [huiFuDataArray addObject:model.childComments[2]];
            }
            for (ZiXunSingleCommentModel *commentModel in huiFuDataArray) {
                NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",commentModel.createname,commentModel.relusername,commentModel.content];
                CGFloat h = [str calculateSize:CGSizeMake(ScreenWidth - 95, MAXFLOAT) font:[UIFont systemFontOfSize:12]].height + 8;
                huiFuTableHeight = huiFuTableHeight + h;
                [singleHeightArray addObject:[NSNumber numberWithFloat:h]];
            }
            ZiXunSingleCommentModel *commentModel = [[ZiXunSingleCommentModel alloc] init];
            commentModel.isMoreOrLess = YES;
            if (model.isExpand == YES) {
                commentModel.createname = @"收起";
            }else{
                commentModel.createname = [NSString stringWithFormat:@"查看全部%ld评论",(long)model.childComments.count];
            }
            [huiFuDataArray addObject:commentModel];
            [singleHeightArray addObject:[NSNumber numberWithFloat:28]];
            huiFuTableHeight = huiFuTableHeight + 28  ;
        }else if ( model.childComments.count > 0 && model.childComments.count <=3){
            huiFuTableHeight = 0.0f;
            [huiFuDataArray addObjectsFromArray:model.childComments];
            for (ZiXunSingleCommentModel *commentModel in huiFuDataArray) {
                NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",commentModel.createname,commentModel.relusername,commentModel.content];
                CGFloat h = [str calculateSize:CGSizeMake(ScreenWidth - 85, MAXFLOAT) font:[UIFont systemFontOfSize:12]].height + 8;
                huiFuTableHeight = huiFuTableHeight + h;
                [singleHeightArray addObject:[NSNumber numberWithFloat:h]];
            }
            huiFuTableHeight = huiFuTableHeight + 18;
        }else{
            huiFuTableView.hidden = YES;
            huiFuTableHeight = 0.0f;
        }
        [self createTableViewWith:huiFuTableHeight];
    }
}
- (void)createTableViewWith:(float)tableViewHeight{
    huiFuTableView.delegate = self;
    huiFuTableView.dataSource = self;
    huiFuTableView.frame = CGRectMake(70, CGRectGetMaxY(topView.frame), ScreenWidth - 85, tableViewHeight);
    huiFuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    huiFuTableView.separatorColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return huiFuDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [singleHeightArray[indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZiXunSingleCommentCell *cell = [ZiXunSingleCommentCell cellForTableView:tableView];
    cell.model = huiFuDataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZiXunSingleCommentModel *singleModel = huiFuDataArray[indexPath.row];
    if ([singleModel.createid isEqualToString:[AppStore getYongHuID]]) {
            self.ziXunSingleCommentCellDelete(_model,singleModel) ;
        return;
    }
    
    if (singleModel.isMoreOrLess == YES) {
        if (self.chaKanMoreClick) {
            self.chaKanMoreClick(_model,singleModel);
        }
    }else{
        if (self.ziXunSingleCommentCellClick) {
            self.ziXunSingleCommentCellClick(_model,singleModel);
        }
    }
    
}
@end
