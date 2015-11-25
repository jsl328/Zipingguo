//
//  DCContact.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#ifdef __DC_USE_AddressBook__

#import <Foundation/Foundation.h>

@interface DCContact : NSObject

@property (retain, nonatomic) NSString* firstName;
@property (retain, nonatomic) NSString* lastName;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* jobTitle;
@property (nonatomic) NSString* firstAlphabetOfName;
@property (retain, nonatomic) NSString* mobilePhoneNumber;
@property (retain, nonatomic) NSString* iPhonePhoneNumber;
@property (retain, nonatomic) NSString* homePhoneNumber;
@property (retain, nonatomic) NSString* workPhoneNumber;
@property (retain, nonatomic) NSArray* phoneNumbers;
@property (retain, nonatomic) NSString* firstValidMobilePhoneNumber;

@end

#endif