//
//  DCContactQuery.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#ifdef __DC_USE_AddressBook__

#import "DCContactQuery.h"
#import "DCContact.h"
#import "DCNaturalLanguage.h"
#import "DCParsedContact.h"
#import "DCGroupResult.h"
#import <AddressBook/AddressBook.h>

@implementation DCContactQuery
@synthesize isSortedByName;

-(BOOL) isGranted {
    return _isGranted;
}

-(void) requestContacts:(void (^)(NSArray*)) callback {

    
    ABAddressBookRef addressBook;
    CFErrorRef err = NULL;

    addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        NSMutableArray* contacts = [[NSMutableArray alloc] init];
        _isGranted = granted;
        
        if (granted) {
            
            NSArray* parsedContacts = [self contactsFromAddressBook:addressBook];
            
            for (DCParsedContact* pc in parsedContacts) {
                [contacts addObject:[pc contact]];
            }
        }
        
        CFRelease(addressBook);
        callback(contacts);
    });
}

-(void) requestContactsGroupedByInitialAlphabet:(void (^)(NSArray*)) callback {

    [self requestContacts:^(NSArray* contacts) {
        callback([contacts groupBy:^(DCContact* contact) {
            return contact.firstAlphabetOfName;
        } keysSortedBy:^NSComparisonResult(DCGroupResult* obj1, DCGroupResult* obj2) {
            return [obj1.key compare:obj2.key];
        }]);
    }];
}


-(NSArray*) contactsFromAddressBook:(ABAddressBookRef) addressBook {
    
    NSMutableArray* contacts = [[NSMutableArray alloc] init];
    
    
    NSArray* peopleList = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (int i = 0; i <= peopleList.count - 1; i++) {
        ABRecordRef record = (__bridge ABRecordRef)([peopleList objectAtIndex:i]);
        [contacts addObject:[[DCParsedContact alloc] initWithABPerson:record]];
        CFRelease(record);
    }
    
    
    if (isSortedByName) {
        [contacts sortUsingComparator:^NSComparisonResult(DCParsedContact* obj1, DCParsedContact* obj2) {
            return [DCNaturalLanguage compareStringPhonetically:obj1.name withString:obj2.name];
        }];
    }
    
    return contacts;
}

@end

#endif