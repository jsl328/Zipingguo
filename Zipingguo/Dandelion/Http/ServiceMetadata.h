//
//  ServiceMetadata.h
//  Nanumanga
//
//  Created by Bob Li on 13-3-19.
//
//

#import <Foundation/Foundation.h>
#import "ServiceMethod.h"
#import "DCHttpBodyEncoder.h"
#import "DCHttpBodyDecoder.h"
#import "DCDateParser.h"
#import "DCReachability.h"
#import "DCEnumParser.h"

@class DCHttpHeader;

@interface ServiceMetadata : NSObject

+(DCHttpBodyEncoder*) createEncoder;

+(DCHttpBodyDecoder*) createDecoder;

+(NSString*) encoderEncodingName;

+(NSStringEncoding) encoderEncoding;

+(NSString*) decoderEncodingName;

+(NSStringEncoding) decoderEncoding;

+(DCHttpHeader*) globalHeader;

+(DCReachability*) reachability;

+(BOOL) urlSerializeEnumAsInteger;

+(DCDateParser*) createUrlDateParser;

+(NSArray*) serviceMethodConfigs;

+(id <DCEnumParser>) enumParser;

+(ServiceMethod*) findMethod:(NSString*) methodName;

+(NSString*) providedUrlForUrlID:(NSString*) urlID;

@end
