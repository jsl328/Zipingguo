//
//  RenWuContentCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuContentCell.h"

@implementation RenWuContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithtableView:(UITableView *)tableView{
    static NSString *ID = @"RenWuContentCell";
    RenWuContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RenWuContentCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)bindDataWithModel:(XinJianRenWuModel *)model{
    taskContentLabel.text = model.taskContent;
    remarkContentLabel.text = model.remark;
    CGRect f = taskContentLabel.frame;
    CGSize size;
    if ([model.taskContent length]) {
        size = [taskContentLabel.text sizeWithFont:taskContentLabel.font constrainedToSize:CGSizeMake(self.width, 1000.0) lineBreakMode:NSLineBreakByClipping];
        f.size.height = size.height;
    }
    taskContentLabel.frame = f;
    remarkLabel.frame = CGRectMake(remarkLabel.x, taskContentLabel.y+taskContentLabel.height+15, remarkLabel.width, remarkLabel.height);
    
    f = remarkContentLabel.frame;
    f.origin.y = remarkLabel.y+remarkLabel.height+8;
    if ([model.remark length]){
        size = [taskContentLabel.text sizeWithFont:taskContentLabel.font constrainedToSize:CGSizeMake(self.width, 1000.0) lineBreakMode:NSLineBreakByClipping];
        f.size.height = size.height;
    }
    remarkContentLabel.frame = f;
    
    model.cellHeight = f.origin.y+f.size.height+15;
}
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 0.5f));
//}
//- (void)drawRect:(CGRect)rect
//{
//    //获得处理的上下文
//    CGContextRef
//    context = UIGraphicsGetCurrentContext();
//    //指定直线样式
//    CGContextSetLineCap(context,kCGLineCapSquare);
//    //直线宽度
//    CGContextSetLineWidth(context,0.5f);
//    //设置颜色
//    CGContextSetRGBStrokeColor(context, 226.0/255.0, 226/255.0, 226/255.0, 1.0);
//    //开始绘制
//    CGContextBeginPath(context);
//    //画笔移动到点(31,170)
//    CGContextMoveToPoint(context,0, self.height-1);
//    //下一点
//    CGContextAddLineToPoint(context,self.width, self.height-1);
//    //绘制完成
//    CGContextStrokePath(context);
//}
@end
