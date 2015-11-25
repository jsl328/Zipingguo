//
//  ServiceMetadata.m
//  Nanumanga
//
//  Created by Bob Li on 13-3-19.
//
//

#import "ServiceMetadata.h"
#import "RXMLElement.h"
#import "Reflection.h"
#import "DCHttpHeader.h"
#import "DCHttpBodyJsonEncoder.h"
#import "DCHttpBodyJsonDecoder.h"
#import "DCDateParser.h"
#import "DCServiceMethodConfig.h"

static NSMutableDictionary* _methods;

static NSMutableDictionary* _urlProvider;

static Class _urlDateParserClass;
static BOOL _urlSerializeEnumAsInteger;

static Class _decoderClass;
static Class _decoderDateParserClass;
static NSString* _decoderEncodingName;
static NSStringEncoding _decoderEncoding;

static Class _encoderClass;
static Class _encoderDateParserClass;
static BOOL _encoderSerializeEnumAsInteger;
static NSString* _encoderEncodingName;
static NSStringEncoding _encoderEncoding;

static DCHttpHeader* _globalHeader;
static DCReachability* _reachability;
static id <DCEnumParser> _enumParser;

@implementation ServiceMetadata

+(void) load {
    [ServiceMetadata loadServiceMethods];
}


+(DCHttpBodyEncoder*) createEncoder {
    
    DCHttpBodyEncoder* encoder = [[_encoderClass alloc] init];
    encoder.dateParser = [[_encoderDateParserClass alloc] init];
    encoder.enumParser = _enumParser;
    encoder.serializeEnumAsInteger = _encoderSerializeEnumAsInteger;
    encoder.encoding = _encoderEncoding;
    return encoder;
}

+(DCHttpBodyDecoder*) createDecoder {

    DCHttpBodyDecoder* decoder = [[_decoderClass alloc] init];
    decoder.dateParser = [[_decoderDateParserClass alloc] init];
    decoder.enumParser = _enumParser;
    decoder.encoding = _decoderEncoding;
    return decoder;
}

+(NSString*) encoderEncodingName {
    return _encoderEncodingName;
}

+(NSStringEncoding) encoderEncoding {
    return _encoderEncoding;
}

+(NSString*) decoderEncodingName {
    return _decoderEncodingName;
}

+(NSStringEncoding) decoderEncoding {
    return _decoderEncoding;
}

+(id <DCEnumParser>) enumParser {
    return _enumParser;
}

+(DCHttpHeader*) globalHeader {
    return _globalHeader;
}

+(DCReachability*) reachability {
    return _reachability;
}

-(NSArray*) serviceMethodConfigs {
    
    NSMutableArray* configs = [[NSMutableArray alloc] init];
    
    for (ServiceMethod* serviceMethod in _methods) {
        [configs addObject:[[DCServiceMethodConfig alloc] initWithServiceMethod:serviceMethod]];
    }
    
    return configs;
}


+(Class) encoderClassParsedFromName:(NSString*) name {

    if (!name || name.length == 0) {
        return [DCHttpBodyJsonEncoder class];
    }
    else if ([name isEqualToString:@"json"]) {
        return [DCHttpBodyJsonEncoder class];
    }
    else {
        return NSClassFromString(name);
    }
}

+(Class) decoderClassParsedFromName:(NSString*) name {
   
    if (!name || name.length == 0) {
        return [DCHttpBodyJsonDecoder class];
    }
    else if ([name isEqualToString:@"json"]) {
        return [DCHttpBodyJsonDecoder class];
    }
    else {
        return NSClassFromString(name);
    }
}

+(Class) dateParserClassParsedFromName:(NSString*) name {
    
    if (!name || name.length == 0) {
        return [DCMsDateParser class];
    }
    else if ([name isEqualToString:@"ms"]) {
        return [DCMsDateParser class];
    }
    else if ([name isEqualToString:@"iso"]) {
        return [DCIsoDateParser class];
    }
    else if ([name isEqualToString:@"ymdhms"]) {
        return [DCYmdhmsDateParser class];
    }
    else {
        return NSClassFromString(name);
    }
}

+(id <DCEnumParser>) enumParserParsedFromName:(NSString*) name {
    
    if (!name || name.length == 0) {
        return nil;
    }
    else {
        return [[NSClassFromString(name) alloc] init];
    }
}

+(BOOL) parseSerializeEnumAsInteger:(NSString*) s {

    if (!s || s.length == 0) {
        return YES;
    }
    else if ([s isEqualToString:@"integer"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+(NSStringEncoding) platformSpecificEncodingFromEncodingName:(NSString*) encodingName {

    if (!encodingName || encodingName.length == 0) {
        return NSUTF8StringEncoding;
    }
    else if ([encodingName isEqualToString:@"utf-8"]) {
        return NSUTF8StringEncoding;
    }
    else {
        return NSUTF8StringEncoding;
    }
}

+(BOOL) urlSerializeEnumAsInteger {
    return _urlSerializeEnumAsInteger;
}

+(DCDateParser*) createUrlDateParser {
    return [[_urlDateParserClass alloc] init];
}


+(void) loadServiceMethods {
    

    NSString* filePath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:@"service_metadata.xml"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    
    
    RXMLElement *root = [RXMLElement elementFromXMLFile:@"service_metadata.xml"];    

    [ServiceMetadata parseConfig:[root child:@"Config"]];
    
    _reachability = [DCReachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    
    RXMLElement* httpHeaderElement = [root child:@"Header"];
    
    if (httpHeaderElement) {
        _globalHeader = [[DCHttpHeader alloc] init];
        [_globalHeader parseXml:httpHeaderElement];
    }
    

    __block BOOL isExclusive;
    __block NSString* httpMethod;
    __block BOOL showWaitBox;
    __block BOOL showError;
    __block BOOL checkNetwork;
    __block BOOL checkPayedNetwork;
    __block int timeout;
    __block BOOL isLoggingEnabled;
    __block BOOL isCookieEnabled;
    __block DCNetworkChecker* networkChecker;

    __block NSString* message;
    __block NSString* timeoutMessage;
    __block NSString* fallbackMessage;
    __block NSString* encodeErrorMessage;
    __block NSString* decodeErrorMessage;
    __block NSString* usePayedNetworkMessage;
    __block NSString* noNetworkMessage;
    __block NSString* networkTypeMismatchMessage;
    
    [root iterate:@"Defaults" usingBlock: ^(RXMLElement *e) {
        
        isExclusive = [e attribute:@"IsExclusive"] ? [[e attribute:@"IsExclusive"] isEqualToString:@"true"] : YES;
        httpMethod = [e attribute:@"Method"] ? [e attribute:@"Method"] : @"GET";
        showWaitBox = [e attribute:@"ShowWaitBox"] ? [[e attribute:@"ShowWaitBox"] isEqualToString:@"true"] : YES;
        showError = [e attribute:@"ShowError"] ? [[e attribute:@"ShowError"] isEqualToString:@"true"] : YES;
        checkNetwork = [e attribute:@"CheckNetwork"] ? [[e attribute:@"CheckNetwork"] isEqualToString:@"true"] : YES;
        checkPayedNetwork = [e attribute:@"CheckPayedNetwork"] ? [[e attribute:@"CheckPayedNetwork"] isEqualToString:@"true"] : NO;
        timeout = [e attribute:@"Timeout"] ? [[e attribute:@"Timeout"] intValue] : 15;
        isLoggingEnabled = [e attribute:@"IsLoggingEnabled"] ? [[e attribute:@"IsLoggingEnabled"] isEqualToString:@"true"] : NO;
        isCookieEnabled = [e attribute:@"IsCookieEnabled"] ? [[e attribute:@"IsCookieEnabled"] isEqualToString:@"true"] : NO;
        networkChecker = [DCNetworkChecker checkerWithStringOfNetworkTypes:[e attribute:@"Network"] ? [e attribute:@"Network"] : @"wifi,mobile"];
        
        message = [[NSBundle mainBundle] localizedStringForKey:@"加载数据中" value:@"" table:@"dandelion"];
        timeoutMessage = [[NSBundle mainBundle] localizedStringForKey:@"加载网络超时" value:@"" table:@"dandelion"];
        fallbackMessage = [[NSBundle mainBundle] localizedStringForKey:@"networkFallback" value:@"" table:@"dandelion"];
        usePayedNetworkMessage = [[NSBundle mainBundle] localizedStringForKey:@"usePayedNetwork" value:@"" table:@"dandelion"];
        encodeErrorMessage = [[NSBundle mainBundle] localizedStringForKey:@"encodeError" value:@"" table:@"dandelion"];
        decodeErrorMessage = [[NSBundle mainBundle] localizedStringForKey:@"decodeError" value:@"" table:@"dandelion"];
        noNetworkMessage = [[NSBundle mainBundle] localizedStringForKey:@"noNetwork" value:@"" table:@"dandelion"];
        networkTypeMismatchMessage = [[NSBundle mainBundle] localizedStringForKey:@"networkTypeMismatch" value:@"" table:@"dandelion"];
    }];
    

    _urlProvider = [[NSMutableDictionary alloc] init];
    [root iterate:@"Urls.Url" usingBlock: ^(RXMLElement *e) {
        [_urlProvider setObject:[e attribute:@"Value"] forKey:[e attribute:@"Name"]];
        
    }];
    
    
    _methods = [[NSMutableDictionary alloc] init];
    
    [root iterate:@"ServiceMethods.ServiceMethod" usingBlock: ^(RXMLElement *e) {
        
        ServiceMethod* method = [[ServiceMethod alloc] init];
        
        method.name = [e attribute:@"Name"];
        method.isExclusive = [e attribute:@"IsExclusive"] ? [[e attribute:@"IsExclusive"] isEqualToString:@"true"] : isExclusive;
        method.method = [e attribute:@"Method"] ? [e attribute:@"Method"] : httpMethod;
        method.showWaitBox = [e attribute:@"ShowWaitBox"] ? [[e attribute:@"ShowWaitBox"] isEqualToString:@"true"] : showWaitBox;
        method.showErrorMessage = [e attribute:@"ShowError"] ? [[e attribute:@"ShowError"] isEqualToString:@"true"] : showError;
        method.checkNetwork = [e attribute:@"CheckNetwork"] ? [[e attribute:@"CheckNetwork"] isEqualToString:@"true"] : checkNetwork;
        method.checkPayedNetwork = [e attribute:@"CheckPayedNetwork"] ? [[e attribute:@"CheckPayedNetwork"] isEqualToString:@"true"] : checkPayedNetwork;
        method.timeout = [e attribute:@"Timeout"] ? [[e attribute:@"Timeout"] intValue] : timeout;
        method.isLoggingEnabled = [e attribute:@"IsLoggingEnabled"] ? [[e attribute:@"IsLoggingEnabled"] isEqualToString:@"true"] : isLoggingEnabled;
        method.isCookieEnabled = [e attribute:@"IsCookieEnabled"] ? [[e attribute:@"IsCookieEnabled"] isEqualToString:@"true"] : isCookieEnabled;
        method.networkChecker = [e attribute:@"Network"] ? [DCNetworkChecker checkerWithStringOfNetworkTypes:[e attribute:@"Network"]] : networkChecker;
        
        method.message = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"accessingNetwork.%@", method.name] value:message table:@"dandelion"];
        method.timeoutMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"networkTimeout.%@", method.name] value:timeoutMessage table:@"dandelion"];
        method.fallbackMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"networkFallback.%@", method.name] value:fallbackMessage table:@"dandelion"];
        method.usePayedNetworkMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"usePayedNetwork.%@", method.name] value:usePayedNetworkMessage table:@"dandelion"];
        method.encodeErrorMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"encodeError.%@", method.name] value:encodeErrorMessage table:@"dandelion"];
        method.decodeErrorMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"decodeError.%@", method.name] value:decodeErrorMessage table:@"dandelion"];
        method.noNetworkMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"noNetwork.%@", method.name] value:noNetworkMessage table:@"dandelion"];
        method.networkTypeMismatchMessage = [[NSBundle mainBundle] localizedStringForKey:[NSString stringWithFormat:@"networkTypeMismatch.%@", method.name] value:networkTypeMismatchMessage table:@"dandelion"];
        
        [method setUrl:[e attribute:@"Url"] parameters:[e attribute:@"Parameters"]];
        
        [_methods setObject:method forKey:method.name];
    }];
}

+(void) parseConfig:(RXMLElement*) config {
    
    RXMLElement* url = [config child:@"Url"];
    _urlDateParserClass = [ServiceMetadata dateParserClassParsedFromName:[url attribute:@"DateParser"]];
    _urlSerializeEnumAsInteger = [ServiceMetadata parseSerializeEnumAsInteger:[url attribute:@"Enum"]];

    RXMLElement* decoder = [config child:@"Decoder"];
    _decoderClass = [ServiceMetadata decoderClassParsedFromName:[decoder attribute:@"Name"]];
    _decoderDateParserClass = [ServiceMetadata dateParserClassParsedFromName:[decoder attribute:@"DateParser"]];
    _decoderEncodingName = [decoder attribute:@"BodyEncoding"];
    _decoderEncoding = [ServiceMetadata platformSpecificEncodingFromEncodingName:_decoderEncodingName];
    
    RXMLElement* encoder = [config child:@"Encoder"];
    _encoderClass = [ServiceMetadata encoderClassParsedFromName:[encoder attribute:@"Name"]];
    _encoderDateParserClass = [ServiceMetadata dateParserClassParsedFromName:[encoder attribute:@"DateParser"]];
    _encoderSerializeEnumAsInteger = [ServiceMetadata parseSerializeEnumAsInteger:[encoder attribute:@"Enum"]];
    _encoderEncodingName = [encoder attribute:@"BodyEncoding"];
    _encoderEncoding = [ServiceMetadata platformSpecificEncodingFromEncodingName:_encoderEncodingName];
                                    
    
    RXMLElement* enumParser = [config child:@"EnumParser"];
    _enumParser = [ServiceMetadata enumParserParsedFromName:[enumParser attribute:@"Name"]];
}

+(NSString*) providedUrlForUrlID:(NSString*) urlID {
    return [_urlProvider objectForKey:urlID];
}

+(ServiceMethod*) findMethod:(NSString*) methodName {
    return [_methods objectForKey:methodName];
}

+(NSArray*) serviceMethodConfigs {

    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    for (ServiceMethod* method in _methods) {
        [items addObject:[[DCServiceMethodConfig alloc] initWithServiceMethod:method]];
    }
    
    return items;
}

@end
