//
//  DCListBoxHeaderCell.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCListBoxHeaderFooterCell.h"
#import "DCSectionedData.h"

@implementation DCListBoxHeaderFooterCell
@synthesize listBox;
@synthesize sectionIndex;
@synthesize cellView;
@synthesize isHeader;

- (id)init
{
    self = [super init];
    if (self) {
        sectionIndex = -1;
        _contentPresenter = [[DCContentPresenter alloc] init];
        [self addSubview:_contentPresenter];
    }
    return self;
}


-(void) bind {
    
    if (sectionIndex == -1) {
        return;
    }
    
    id <DCSectionedData> item = [listBox.items objectAtIndex:sectionIndex];
    _identifier = [[item.header class] description];
    
    _contentPresenter.content = isHeader ? item.header : item.footer;
    cellView = _contentPresenter.contentView;
}

-(NSString*) reuseIdentifier {
    return _identifier;
}

-(void) layoutSubviews {
    _contentPresenter.frame = self.bounds;
    self.backgroundView.backgroundColor = [UIColor clearColor];
}

@end
