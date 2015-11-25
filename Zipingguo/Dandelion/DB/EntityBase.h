//
//  EntityBase.h
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityBase : NSObject

@property (nonatomic) int autoID;

-(void) save;

-(void) save:(NSArray*) fields;

-(void) populateWith:(id) object;
-(void) populateTo:(id) object;

@end
