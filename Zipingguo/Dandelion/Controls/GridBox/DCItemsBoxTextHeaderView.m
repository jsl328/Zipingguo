//
//  DCGridBoxTextHeaderView.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-13.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxTextHeaderView.h"

@implementation DCGridBoxTextHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];

        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:145.0 / 255 green:160.0 / 255 blue:171.0 / 255 alpha:1].CGColor, (id)[UIColor colorWithRed:181.0 / 255 green:191.0 / 255 blue:198.0 / 255 alpha:1].CGColor, nil];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return self;
}

-(void) bind:(NSString*) text {
    _label.text = text;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(5, 0, self.frame.size.width - 5, self.frame.size.height);
    _gradientLayer.frame = self.bounds;
}

@end
