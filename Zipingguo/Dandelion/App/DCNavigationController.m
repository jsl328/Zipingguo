//
//  DCNavigationController.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-5.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCNavigationController.h"
#import "DCImageCache.h"

@implementation DCNavigationController
@synthesize orientationMask;

-(BOOL) shouldAutorotate {
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations {
    return orientationMask;
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    int count = [DCImageCache defaultCache].count;
    int size = [DCImageCache defaultCache].usedSize;
    
    [[DCImageCache defaultCache] evictNonReferencedItems];
    NSLog(@"Dandelion: cached images:%d -> %d, bytes: %d -> %d.", count, [DCImageCache defaultCache].count, size, [DCImageCache defaultCache].usedSize);
}

@end
