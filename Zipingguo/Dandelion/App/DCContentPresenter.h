//
//  DCContentPresenter.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DCViewTypeBindable 0
#define DCViewTypeUILabel 1
#define DCViewTypeUIView 2

@interface DCContentPresenter : UIView {
    UIView* _view;
    int _viewType;
}

@property (retain, nonatomic) id content;
@property (nonatomic) Class stringViewClass;

-(id) initWithContent: (id) content;

-(UIView*) contentView;
-(void) bind;


@end
