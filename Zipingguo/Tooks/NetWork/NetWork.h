//
//  NetWork.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-19.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWork : NSObject

typedef enum {
    
    NETWORK_TYPE_NONE= 0,

    NETWORK_TYPE_2G= 1,
    
    NETWORK_TYPE_3G= 2,
    
    NETWORK_TYPE_4G= 3,
    
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    
    NETWORK_TYPE_WIFI= 5,
    
}NETWORK_TYPE;

+ (BOOL) isConnectionAvailable;

+(NETWORK_TYPE) getNetworkTypeFromStatusBar;

@end
