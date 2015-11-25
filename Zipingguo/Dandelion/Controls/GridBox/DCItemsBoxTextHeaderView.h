//
//  DCGridBoxTextHeaderView.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-13.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface DCGridBoxTextHeaderView : UIView {

    UILabel* _label;
    
    CGSize _verticalLabelSize;
    
    
    CAGradientLayer* _gradientLayer;
}

-(void) bind:(NSString*) text;

@end
