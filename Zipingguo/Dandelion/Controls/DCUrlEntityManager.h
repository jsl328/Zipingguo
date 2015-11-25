//
//  DCUrlImageViewScheduler.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-11.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCWeakSet.h"
#import "DCUrlDownloader.h"
#import "DCUrlEntity.h"

@interface DCUrlEntityManager : NSObject <DCUrlDownloaderDelegate> {
    DCWeakSet* _downloading;
}

+(DCUrlEntityManager*) defaultManager;

-(void) downloadUrlEntity:(id <DCUrlEntity>) urlEntity fileName:(NSString *)fileName limitSize:(int)limitSize;

-(void) removeEntity:(id <DCUrlEntity>) entity;

@end
