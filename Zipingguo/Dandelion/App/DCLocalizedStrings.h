//
//  DCStrings.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DCStringKey {
    DCStringKeyAudioUnavailable = 0,
    DCStringKeyRecordingFail = 1,
    DCStringKeyAudioTooShort = 2,
    DCStringKeyCameraUnavailable = 3,
    DCStringKeyDefaultRecordDialogUse = 4,
    DCStringKeyDefaultRecordDialogDiscard = 5,
    DCStringKeyDefaultRecordDialogPleaseSpeak = 6,
    DCStringKeyDefaultRecordDialogTimeExpired = 7,
    DCStringKeyDefaultDrawDialogUse = 8,
    DCStringKeyDefaultDrawDialogDiscard = 9,
    DCStringKeyJsonStringEmpty = 10,
    DCStringKeyJsonStringInvalid = 11,
    DCStringKeyJsonParsingError = 12
};
typedef enum DCStringKey DCStringKey;


@interface DCLocalizedStrings : NSObject

+(NSException*) exceptionForKey:(DCStringKey) key;

+(NSException*) exceptionForKey:(DCStringKey)key parameters:(NSArray*) parameters;

+(NSError*) errorForKey:(DCStringKey) key;

+(NSError*) errorForKey:(DCStringKey)key parameters:(NSArray*) parameters;

+(NSString*) stringForKey:(DCStringKey) key;

+(NSString*) stringForKey:(DCStringKey)key parameters:(NSArray*) parameters;

@end
