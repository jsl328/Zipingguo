//
//  TupianView.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-18.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "TupianView.h"

@implementation TupianView{
    CGPoint _point;
}

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle ] loadNibNamed:@"TupianView" owner:self options:nil] lastObject];
        _tupianImageBox.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _point = [[touches anyObject] locationInView:self];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject]  locationInView:self];
    if (ABS(point.x - _point.x) <= 5 && ABS(point.y - _point.y) <= 5) {
        [self.delegate TupianViewDidTap:self];
    }
}
- (IBAction)shanchuButtonClick:(id)sender {
    [self.delegate ShanchuTupian:self];
}



@end
