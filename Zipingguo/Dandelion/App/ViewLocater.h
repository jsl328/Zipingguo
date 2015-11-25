//
//  ViewLocater.h
//  Dandelion
//
//  Created by Bob Li on 13-8-28.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewLocater : NSObject

+(Class) viewClassForViewModel:(id) viewModel viewSuffix:(NSString*) viewSuffix;

+(Class) viewClassForViewModel:(id) viewModel;

@end
