//
//  DCDocumentPreview.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCFileSource.h"
#import "DCHandleDirection.h"

@interface DCDocumentPreview : UIView <UIScrollViewDelegate, DCFileSourceDelegate, DCHandleDirection>

-(DCFileSource*) source;

@end
