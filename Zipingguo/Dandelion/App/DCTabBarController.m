//
//  DCTabBarController.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCTabBarController.h"
#import "DCImageCache.h"

@implementation DCTabBarController
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
