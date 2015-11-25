//
//  ServiceMethod.h
//  Nanumanga
//
//  Created by Bob Li on 13-3-19.
//
//

#import <Foundation/Foundation.h>
#import "DCHttpBodyEncoder.h"
#import "DCNetworkChecker.h"
#import "DCServiceMethodConfig.h"
#import "DCEnumParser.h"
#import "DCDateParser.h"

@interface ServiceMethod : NSObject

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* urlID;
@property (retain, nonatomic) NSString* method;
@property (nonatomic) BOOL isExclusive;
@property (nonatomic) BOOL showWaitBox;
@property (nonatomic) BOOL showErrorMessage;
@property (nonatomic) BOOL checkNetwork;
@property (nonatomic) BOOL checkPayedNetwork;
@property (nonatomic) int timeout;
@property (nonatomic) BOOL isLoggingEnabled;
@property (nonatomic) BOOL isCookieEnabled;
@property (nonatomic) DCNetworkChecker* networkChecker;

@property (retain, nonatomic) NSString* message;
@property (retain, nonatomic) NSString* timeoutMessage;
@property (retain, nonatomic) NSString* abortMessage;
@property (retain, nonatomic) NSString* fallbackMessage;
@property (retain, nonatomic) NSString* usePayedNetworkMessage;
@property (retain, nonatomic) NSString* encodeErrorMessage;
@property (retain, nonatomic) NSString* decodeErrorMessage;
@property (retain, nonatomic) NSString* cancelledMessage;
@property (retain, nonatomic) NSString* noNetworkMessage;
@property (retain, nonatomic) NSString* networkTypeMismatchMessage;
@property (nonatomic ,assign)int priority; //优先级1为最高，0默认

-(BOOL) postsData;

-(NSString*) getUrlWithValues:(NSArray*) values providedUrl:(NSString*) providedUrl serializeEnumAsInteger:(BOOL) serializeEnumAsInteger enumParser:(id <DCEnumParser>) enumParser dateParser:(DCDateParser*) dateParser;


-(NSData*) postDataWithParameterValues:(NSArray*) parameterValues withEncoder:(DCHttpBodyEncoder*) encoder error:(NSError**) error;

-(void) setUrl: (NSString*) url parameters:(NSString*) parameters;

@end
