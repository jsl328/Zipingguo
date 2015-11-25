//
//  LianXiRenXiangQingCell.m
//  Zipingguo
//
//  Created by sunny on 15/9/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "LianXiRenXiangQingCell.h"

@implementation LianXiRenXiangQingCell

+ (LianXiRenXiangQingCell *)cellForTableView:(UITableView *)tableView{
    LianXiRenXiangQingCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    [touXiangImage setCircle];
}
-(void)setModel:(LianXiRenModel *)model{
    if (model) {
        _model = model;
        [touXiangImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLKEY,model.touXiangIamgeUrl]] placeholderImage:[UIImage imageNamed:@"头像100.png"]];
        nameLabel.text = model.name;
        detailLabel.text = model.position;
        buMenLabel.text = model.buMen;
        [self layoutSubviews];  
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    float margin = 15.0f;
    [buMenLabel sizeToFit];
    buMenLabel.frame = CGRectMake(ScreenWidth - margin - buMenLabel.width , buMenLabel.y, buMenLabel.width, buMenLabel.height);
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(nameLabel.x, nameLabel.y, ScreenWidth-nameLabel.x - 2 * margin - buMenLabel.width, nameLabel.height);
    [detailLabel sizeToFit];
    detailLabel.frame = CGRectMake(detailLabel.x, detailLabel.y, nameLabel.width, detailLabel.height);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
