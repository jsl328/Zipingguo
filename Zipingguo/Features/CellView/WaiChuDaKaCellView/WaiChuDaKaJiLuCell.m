//
//  WaiChuDaKaCell.m
//  Zipingguo
//
//  Created by sunny on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiChuDaKaJiLuCell.h"
#import "UILabel+Extension.h"
#import "DCUrlDownloader.h"


#define imageW (ScreenWidth - 30 - 10)/3
@interface WaiChuDaKaJiLuCell ()<YuyinViewDelegate,TupianViewDelegate>

@end

@implementation WaiChuDaKaJiLuCell

- (void)awakeFromNib {
    // Initialization code
}
+ (WaiChuDaKaJiLuCell *)cellForTableView:(UITableView *)tableView{
    WaiChuDaKaJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WaiChuDaKaJiLuCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setModel:(WaiChuDaKaJiLuModel *)model{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[YuyinView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[TupianView class]]) {
            [view removeFromSuperview];
        }
    }
    if (model) {
        _model = model;
         diZhiLabel.text = [NSString stringWithFormat:@"%@  %@",model.time,model.address];
        [diZhiLabel addAttributeWithString:diZhiLabel.text andColorValue:RGBACOLOR(4, 175, 245, 1) andUIFont:[UIFont systemFontOfSize:18] andRangeString:model.time];
        contentLabel.text = model.content;
        CGSize contentLabelSize = [contentLabel getLabelSizeWithLabelMaxWidth:ScreenWidth - 15 - 18 MaxHeight:MAXFLOAT FontSize:[UIFont systemFontOfSize:12] LabelText:contentLabel.text];
        contentLabel.frame = CGRectMake(contentLabel.x, CGRectGetMaxY(diZhiLabel.frame) + 5, ScreenWidth - 30, contentLabelSize.height);
        [contentLabel sizeToFit];
        // 语音view的上边距
        float maxYuYinH ;
        if (model.content.length != 0 && model.content != nil && model.content != NULL && ![model.content isEqual:[NSNull null]]) {
            maxYuYinH = CGRectGetMaxY(contentLabel.frame);
        }else{
            maxYuYinH = 20;
        }
        
        for (int i = 0; i < model.yuYinArray.count; i++) {
            YuyinModel *yuYinModel = model.yuYinArray[i];
            YuyinView *yuYinView = [[YuyinView alloc] init];
            maxYuYinH = CGRectGetMaxY(contentLabel.frame) +8 + i * (26 + 11);
            yuYinView.frame = CGRectMake(15, maxYuYinH, 77, 26);
            yuYinView.delegate = self;
            yuYinView.miaoshuLabel.text = [NSString stringWithFormat:@"%@''",yuYinModel.spendtime];
            yuYinView.guanbiBtn.hidden = YES;

            NSString *strUrl = [NSString stringWithFormat:@"%@%@",URLKEY,yuYinModel.resurl];
            NSArray *arr = [yuYinModel.resurl componentsSeparatedByString:@"."];
            NSString* filePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:strUrl fileName:[arr lastObject]];
            yuYinView.fileNameUrl = filePath;
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO]) {
                [[DCUrlDownloader defaultDownloader] downloadUrl:strUrl fileName:[arr lastObject] limitSize:-1];
            }
            [self.contentView addSubview:yuYinView];
        }
        float maxPhotoH ;
        if (model.yuYinArray.count == 0 ) {
            if (model.tuPianArray.count > 0) {
                maxPhotoH = maxYuYinH + 8;
            }
        }else{
            if (model.tuPianArray.count > 0) {
                 maxPhotoH = maxYuYinH + 26 + 11;
            }
        }
        float cellHeight = maxPhotoH;
        for (int i = 0; i < model.tuPianArray.count; i++) {
            TupianModel *tuPianModel = model.tuPianArray[i];
            TupianView *tupianView = [[TupianView alloc] init];
            cellHeight = maxPhotoH  +  (imageW + 5)*(i/3);
            tupianView.frame = CGRectMake(15+(i%3)*(imageW + 5), cellHeight, imageW, imageW);
            tupianView.userInteractionEnabled = YES;
            tupianView.shanchuBtn.hidden = YES;
            tupianView.delegate = self;
            tupianView.tag = i;
            [tupianView.tupianImageBox sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLKEY,tuPianModel.resurl]] placeholderImage:[UIImage imageNamed:@"图片底图.png"]];
            [self.contentView addSubview:tupianView];
        }
//        if (model.tuPianArray.count == 0 && model.yuYinArray.count == 0 && model.content.length == 0) {
//            cellHeight = 11;
//            diZhiLabel.frame = CGRectMake(15, 2, ScreenWidth - 30, 20);
//        }else{
//            diZhiLabel.frame = CGRectMake(15, 0, ScreenWidth - 30, 20);
//        }
        self.frame = CGRectMake(0, 0, ScreenWidth, model.tuPianArray.count == 0 ? cellHeight + 13  : cellHeight + imageW + 13);
        _cellHeight = self.height;
        [self layoutSubviews];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
     contentLabel.frame = CGRectMake(18, contentLabel.y, ScreenWidth - 15 - 18, contentLabel.height);
}
- (void)BofangYuyin:(YuyinView *)luyinView{
    if (self.boFangYuYinClick) {
        self.boFangYuYinClick(luyinView);
    }
}
- (void)TupianViewDidTap:(TupianView *)tapView{
    NSMutableArray *bigPhotosArray = [@[] mutableCopy];
    for (TupianModel *model in _model.tuPianArray) {
        [bigPhotosArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLKEY,model.bigImgUrl]]];
    }
    if (self.chaKanPhotos) {
        self.chaKanPhotos((int)tapView.tag,bigPhotosArray);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
