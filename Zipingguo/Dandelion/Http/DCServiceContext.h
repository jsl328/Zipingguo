//
//  ServiceError.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-3.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DCServiceErrorReason {
    DCServiceErrorReasonNone,
    DCServiceErrorReasonNetwork,
    DCServiceErrorReasonInquireDenied,
    DCServiceErrorReasonEncode,
    DCServiceErrorReasonDecode,
    DCServiceErrorReasonAbort,
    DCServiceErrorReasonHttp,
    DCServiceErrorReasonTimeout
};
typedef enum DCServiceErrorReason DCServiceErrorReason;

@interface DCServiceContext : NSObject

@property (nonatomic) BOOL isSucceeded;
@property (retain, nonatomic) NSString* message;
@property (nonatomic) int httpCode;
@property (nonatomic) DCServiceErrorReason errorReason;

@end
