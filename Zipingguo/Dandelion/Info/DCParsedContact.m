//
//  DCParsedContact.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#ifdef __DC_USE_AddressBook__

#import "DCParsedContact.h"
#import "DCNaturalLanguage.h"

@implementation DCParsedContact
@synthesize firstName;
@synthesize lastName;
@synthesize name;
@synthesize jobTitle;
@synthesize firstAlphabetOfName;
@synthesize mobilePhoneNumber;
@synthesize iPhonePhoneNumber;
@synthesize homePhoneNumber;
@synthesize workPhoneNumber;
@synthesize phoneNumbers;

-(id) initWithABPerson:(ABRecordRef)person {
    
    self = [super init];
    
    if (self) {
        [self retrieveGeneralInformation:person];
        [self retrievePhoneNumbers:person];
    }

    return self;
}

-(void) retrieveGeneralInformation:(ABRecordRef) person {

    firstName = (__bridge NSString*)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    lastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    
    ABPersonCompositeNameFormat cnf = ABPersonGetCompositeNameFormatForRecord(person);
    if (cnf == kABPersonCompositeNameFormatFirstNameFirst) {
        name = [NSString stringWithFormat:@"%@%@%@", firstName, [self seperatorOfNameBetween:firstName and:lastName], lastName];
    }
    else {
        name = [NSString stringWithFormat:@"%@%@%@", lastName, [self seperatorOfNameBetween:lastName and:firstName], firstName];
    }
    
    
    jobTitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);


    if (name.length == 0) {
        firstAlphabetOfName = @"";
    }
    else {
    
        NSMutableString* s = [[NSMutableString alloc] init];
        
        [s appendFormat:@"%c", [DCNaturalLanguage initialAlphabetFromCharacter:[name characterAtIndex:0]]];
        firstAlphabetOfName = [s uppercaseString];
    }
}

-(NSString*) seperatorOfNameBetween:(NSString*) s1 and:(NSString*) s2 {

    if ([s1 characterAtIndex:s1.length - 1] <= 128 && [s2 characterAtIndex:0] <= 128) {
        return @" ";
    }
    else {
        return @"";
    }
}

-(void) retrievePhoneNumbers:(ABRecordRef) person {

    ABMutableMultiValueRef value = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    phoneNumbers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < ABMultiValueGetCount(value); i++) {
        
        NSString* label = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(value, i));
        NSString* phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(value, i));
        
        if ([label isEqualToString:(__bridge NSString *)kABPersonPhoneMobileLabel]) {
            mobilePhoneNumber = [DCParsedContact phoneNumberFilteredFromRawPhoneNumber:phoneNumber];
        }
        else if ([label isEqualToString:(__bridge NSString *)kABPersonPhoneIPhoneLabel]) {
            iPhonePhoneNumber = [DCParsedContact phoneNumberFilteredFromRawPhoneNumber:phoneNumber];
        }
        else if ([label isEqualToString:(__bridge NSString *)kABPersonPhoneHomeFAXLabel]) {
            homePhoneNumber = [DCParsedContact phoneNumberFilteredFromRawPhoneNumber:phoneNumber];
        }
        else if ([label isEqualToString:(__bridge NSString *)kABPersonPhoneWorkFAXLabel]) {
            workPhoneNumber = [DCParsedContact phoneNumberFilteredFromRawPhoneNumber:phoneNumber];
        }
        else {
            [phoneNumbers addObject:[DCParsedContact phoneNumberFilteredFromRawPhoneNumber:phoneNumber]];
        }
    }
}

+(NSString*) phoneNumberFilteredFromRawPhoneNumber:(NSString*) phoneNumber {

    if (!phoneNumber && phoneNumber.length == 0) {
        return @"";
    }
    
    NSMutableString* s = [[NSMutableString alloc] init];
    for (int i = 0; i <= phoneNumber.length - 1; i++) {
        char c = [phoneNumber characterAtIndex:i];
        if (c >= '0' && c <= '9') {
            [s appendFormat:@"%c", c];
        }
    }
    
    return [NSString stringWithString:s];
}

-(NSString*) firstValidMobilePhoneNumber {

    if (mobilePhoneNumber.length > 0) {
        return mobilePhoneNumber;
    }
    
    for (NSString* phoneNumber in phoneNumbers) {
        if (phoneNumber.length > 0) {
            return phoneNumber;
        }
    }
    
    return @"";
}

-(DCContact*) contact {

    DCContact* contact = [[DCContact alloc] init];
    
    contact.firstName = firstName;
    contact.lastName = lastName;
    contact.name = name;
    contact.jobTitle = jobTitle;
    contact.firstAlphabetOfName = firstAlphabetOfName;
    contact.mobilePhoneNumber = mobilePhoneNumber;
    contact.iPhonePhoneNumber = iPhonePhoneNumber;
    contact.homePhoneNumber = homePhoneNumber;
    contact.workPhoneNumber = workPhoneNumber;
    contact.phoneNumbers = phoneNumbers;
    contact.firstValidMobilePhoneNumber = [self firstValidMobilePhoneNumber];
    
    return contact;
}

@end

#endif
