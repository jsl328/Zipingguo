//
//  EntityLibrary.h
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityMetadata.h"

@interface EntityLibrary : NSObject

+(NSMutableArray*) entities;

+(EntityMetadata*) entityforType:(NSString*) type;

@end