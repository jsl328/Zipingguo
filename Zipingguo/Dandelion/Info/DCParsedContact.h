//
//  DCParsedContact.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#ifdef __DC_USE_AddressBook__

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "DCContact.h"

@interface DCParsedContact : NSObject

@property (retain, nonatomic) NSString* firstName;
@property (retain, nonatomic) NSString* lastName;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* jobTitle;
@property (nonatomic) NSString* firstAlphabetOfName;
@property (retain, nonatomic) NSString* mobilePhoneNumber;
@property (retain, nonatomic) NSString* iPhonePhoneNumber;
@property (retain, nonatomic) NSString* homePhoneNumber;
@property (retain, nonatomic) NSString* workPhoneNumber;
@property (retain, nonatomic) NSMutableArray* phoneNumbers;

-(id) initWithABPerson:(ABRecordRef) person;

-(DCContact*) contact;

@end

#endif