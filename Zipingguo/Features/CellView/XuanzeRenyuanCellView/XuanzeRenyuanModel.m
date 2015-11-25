//
//  XuanzeRenyuanModel.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XuanzeRenyuanModel.h"

@implementation XuanzeRenyuanModel

- (void)setPersonsSM:(YonghuInfoDB *)personsSM{
    _personsSM = personsSM;
    
    NSString *s = [NSString stringWithFormat:@"%@   %@",personsSM.name,personsSM.position.length ? personsSM.position : @""];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:s];
    if (personsSM.position.length) {
        NSRange pRange = [s rangeOfString:personsSM.position];
        [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:pRange];
        [mStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(160, 160, 162, 1) range:pRange];
    }
    self.showName = mStr;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self.xuanzhong = [aDecoder decodeObjectForKey:@"xuanzhong"];
    self.endure = [aDecoder decodeObjectForKey:@"endure"];
    self.personsSM = [aDecoder decodeObjectForKey:@"personsSM"];
    self.showName = [aDecoder decodeObjectForKey:@"showName"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithBool:self.xuanzhong] forKey:@"xuanzhong"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.endure] forKey:@"endure"];
    [aCoder encodeObject:self.personsSM forKey:@"personsSM"];
    [aCoder encodeObject:self.showName forKey:@"showName"];

}

@end
