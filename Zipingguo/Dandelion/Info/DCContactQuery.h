//
//  DCContactQuery.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#ifdef __DC_USE_AddressBook__

#import <Foundation/Foundation.h>

@interface DCContactQuery : NSObject {

    BOOL _isGranted;
}

@property (nonatomic) BOOL isSortedByName;

-(BOOL) isGranted;


-(void) requestContacts:(void (^)(NSArray*)) callback;

-(void) requestContactsGroupedByInitialAlphabet:(void (^)(NSArray*)) callback;

@end

#endif