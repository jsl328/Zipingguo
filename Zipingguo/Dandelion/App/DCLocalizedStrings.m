//
//  DCStrings.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCLocalizedStrings.h"


static NSMutableDictionary* _dictionary;

static NSArray* _messageTypeKeys;


@implementation DCLocalizedStrings

+(NSException*) exceptionForKey:(DCStringKey) key {
    return [NSException exceptionWithName:@"Exception" reason:[DCLocalizedStrings stringForKey:key] userInfo:nil];
}

+(NSException*) exceptionForKey:(DCStringKey)key parameters:(NSArray*) parameters {
    return [NSException exceptionWithName:@"Exception" reason:[DCLocalizedStrings stringForKey:key parameters:parameters] userInfo:nil];
}

+(NSError*) errorForKey:(DCStringKey) key {
    return [DCLocalizedStrings errorForMessage:[DCLocalizedStrings stringForKey:key]];
}

+(NSError*) errorForKey:(DCStringKey)key parameters:(NSArray*) parameters {
    return [DCLocalizedStrings errorForMessage:[DCLocalizedStrings stringForKey:key parameters:parameters]];
}

+(NSError*) errorForMessage:(NSString*) message {
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:message forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
}

+(NSString*) stringForKey:(DCStringKey) key {
    return [_dictionary objectForKey:[DCLocalizedStrings keyForErrorType:key]];
}

+(NSString*) stringForKey:(DCStringKey)key parameters:(NSArray*) parameters {
    
    NSString* template = [_dictionary objectForKey:[DCLocalizedStrings keyForErrorType:key]];
    
    
    NSString* message = nil;
    
    if (parameters.count == 1) {
        message = [NSString stringWithFormat:template, [parameters objectAtIndex:0]];
    }
    
    
    return message;
}

+(NSString*) keyForErrorType:(int) errorType {
    return (NSString*)[_messageTypeKeys objectAtIndex:errorType];
}

+(void) load {
    
    _messageTypeKeys = @[
      @"deviceShell.audioUnavailable", // DCStringKeyAudioUnavailable
      @"deviceShell.recordingFail", // DCStringKeyRecordingFail
      @"deviceShell.audioTooShort", // DCStringKeyAudioTooShort
      @"deviceShell.cameraUnavailable", // DCStringKeyCameraUnavailable
      @"defaultRecordDialog.use", // DCStringKeyDefaultRecordDialogUse
      @"defaultRecordDialog.discard", // DCStringKeyDefaultRecordDialogDiscard
      @"defaultRecordDialog.pleaseSpeak", // DCStringKeyDefaultRecordDialogPleaseSpeak
      @"defaultRecordDialog.timeExpired", // DCStringKeyDefaultRecordDialogTimeExpired
      @"defaultDrawDialog.use", // DCStringKeyDefaultDrawDialogUse
      @"defaultDrawDialog.discard", // DCStringKeyDefaultDrawDialogDiscard
      @"jsonDeserializer.jsonStringEmpty", // DCStringKeyJsonStringEmpty
      @"jsonDeserializer.jsonStringInvalid", // DCStringKeyJsonStringInvalid
      @"jsonDeserializer.jsonParsingError" // DCStringKeyJsonParsingError
    ];
    
    _dictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i <= _messageTypeKeys.count - 1; i++) {
        NSString* key = [DCLocalizedStrings keyForErrorType:i];
        NSString* message = [[NSBundle mainBundle] localizedStringForKey:key value:key table:@"dandelion"];
        [_dictionary setObject:message forKey:key];
    }
}

@end
