//
//  RIlilistCell.m
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RIlilistCell.h"

@implementation RIlilistCell
-(void)bind:(RIlilistCellVM*)vm
{
    VM=vm;
    self.shijian.text=vm.shijian;
    self.Name.text=vm.Name;
    if (VM.istixing==YES) {
        self.tixingimage.hidden=NO;
    }else{
        self.tixingimage.hidden=YES;

    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
