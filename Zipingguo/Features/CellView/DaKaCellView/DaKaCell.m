//
//  DaKaCell.m
//  Zipingguo
//
//  Created by sunny on 15/10/8.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "DaKaCell.h"


static float daKaCellmargin = 15.0f;
static float imageW = 18.0f;

@implementation DaKaCell
@synthesize addressLabel,selectImageView,detailAddressLabel;

+ (DaKaCell *)cellFortableView:(UITableView *)tableView{
    DaKaCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(DaKaModel *)model{
    if (model) {
        _model = model;
        if (model.isSelect == YES) {
            selectImageView.hidden = NO;
        }else{
            selectImageView.hidden = YES;
        }
        addressLabel.text = model.addressName;
        addressLabel.frame = CGRectMake(daKaCellmargin, 8, ScreenWidth - 2* daKaCellmargin - daKaCellmargin/2 - imageW, addressLabel.height);
        
        detailAddressLabel.text = model.detailAddress;
        detailAddressLabel.frame = CGRectMake(daKaCellmargin,CGRectGetMaxY(addressLabel.frame)+4, ScreenWidth - 2* daKaCellmargin - daKaCellmargin/2 - imageW, detailAddressLabel.height);

        [self layoutSubviews];
    }
}
//- (void)
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (void)layoutSubviews{
    [super layoutSubviews];

    selectImageView.frame = CGRectMake(ScreenWidth - daKaCellmargin - imageW, (self.height - imageW)/2, imageW, imageW);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
