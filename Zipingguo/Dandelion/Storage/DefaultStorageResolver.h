//
//  DefaultStorageLocationResolver.h
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultStorageResolver.h"
#import "FileStorageResolver.h"

@interface DefaultStorageResolver : FileStorageResolver {
    
    NSString* _documentDirectory;
}

@end
