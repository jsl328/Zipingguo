//
//  ServiceMethod.m
//  Nanumanga
//
//  Created by Bob Li on 13-3-19.
//
//

#import "ServiceMethod.h"
#import "DCEnumValue.h"

@implementation ServiceMethod  {
    
    NSString* _absoluteUrl;
    
    NSString* _urlVerb;
    
    NSArray* _getParameterNames;
    
    NSArray* _postParameterNames;
    
    int _getParameterCount;
    
    BOOL _postData;
}

@synthesize name;
@synthesize urlID;
@synthesize method = _method;
@synthesize isExclusive;
@synthesize showWaitBox;
@synthesize showErrorMessage;
@synthesize checkNetwork;
@synthesize checkPayedNetwork;
@synthesize timeout;
@synthesize isLoggingEnabled;
@synthesize isCookieEnabled;
@synthesize networkChecker;
@synthesize message;
@synthesize timeoutMessage;
@synthesize abortMessage;
@synthesize fallbackMessage;
@synthesize usePayedNetworkMessage;
@synthesize encodeErrorMessage;
@synthesize decodeErrorMessage;
@synthesize cancelledMessage;
@synthesize noNetworkMessage;
@synthesize networkTypeMismatchMessage;

-(BOOL) postsData {
    return _postData;
}

-(void) setMethod:(NSString *)method {
    _method = method;
    _postData = [method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"];
}

-(void) setUrl: (NSString*) url parameters:(NSString*) parameters {
    
    if ([url characterAtIndex:0] != '[') {
        _absoluteUrl = url;
    }
    else {
        
        NSInteger positionOfRightBracket = [url rangeOfString:@"]"].location;
        urlID = [url substringWithRange:NSMakeRange(1, positionOfRightBracket - 1)];
        
        if ([url characterAtIndex:url.length - 1] != ']') {
            _urlVerb = [url substringFromIndex:positionOfRightBracket + 1];
        }
    }
    
    
    if (parameters.length > 0) {
        
        NSInteger positionOfSlash = [parameters rangeOfString:@"/"].location;
        
        if (positionOfSlash == NSNotFound) {
            _getParameterNames = [parameters componentsSeparatedByString:@","];
        }
        else if (positionOfSlash == 0) {
            _getParameterNames = [[NSArray alloc] init];
        }
        else {
            _getParameterNames = [[parameters substringToIndex:positionOfSlash - 1] componentsSeparatedByString:@","];
        }
        
        if (positionOfSlash != NSNotFound) {
            _postParameterNames = [[parameters substringFromIndex:positionOfSlash + 1] componentsSeparatedByString:@","];
        }
        //
        
        NSMutableArray *names = [[NSMutableArray alloc]initWithArray:_getParameterNames];
        NSString *Subname = [names lastObject];
        if([Subname isEqualToString:@"priorityyouxianji"])
        {
            [names removeLastObject];
            _getParameterNames = names;
            _priority = 1;
        }
        //
        _getParameterCount = (int)_getParameterNames.count;
    }
}

-(NSString*) getUrlWithValues:(NSArray*) values providedUrl:(NSString*) providedUrl serializeEnumAsInteger:(BOOL) serializeEnumAsInteger enumParser:(id <DCEnumParser>) enumParser dateParser:(DCDateParser*) dateParser {
    
    NSString* baseUrl = providedUrl ? providedUrl : _absoluteUrl;
    
    
    NSMutableString* queryString = [[NSMutableString alloc] init];
    
    [queryString appendString:baseUrl];
    [queryString appendString:_urlVerb];
    
    if (_getParameterCount > 0) {
        
        [queryString appendString:@"?"];
        
        for (int i = 0; i <= _getParameterCount - 1; i++) {
            
            id value = [values objectAtIndex:i];
            NSString* stringValue;
            
            if (!value) {
                stringValue = @"";
            }
            else if ([[value class] isSubclassOfClass:[DCEnumValue class]]) {
                stringValue = serializeEnumAsInteger ? [NSString stringWithFormat:@"%d", ((DCEnumValue*)value).value] : ((DCEnumValue*)value).enumName;
            }
            else if ([[value class] isSubclassOfClass:[NSDate class]]) {
                stringValue = [dateParser stringFromDate:(NSDate*)value];
            }
            else {
                stringValue = [value description];
            }
            
            
            stringValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)stringValue, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
            
            [queryString appendFormat:@"%@=%@", [_getParameterNames objectAtIndex:i], stringValue];
            
            if (i < _getParameterCount - 1) {
                [queryString appendString:@"&"];
            }
        }
    }
    
    return [NSString stringWithString:queryString];
}

-(NSData*) postDataWithParameterValues:(NSArray*) parameterValues withEncoder:(DCHttpBodyEncoder*) encoder error:(NSError**) error {
    
    id postData;
    
    if (_postParameterNames.count == 1 && [[_postParameterNames objectAtIndex:0] isEqualToString:@"~"]) {
        postData = [parameterValues firstObject];
    }
    else {
        
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
        
        if (_postParameterNames) {
            for (int i = 0; i <= _postParameterNames.count - 1; i++) {
                [dictionary setObject:[parameterValues objectAtIndex:_getParameterCount + i] forKey:[_postParameterNames objectAtIndex:i]];
            }
        }
        
        postData = dictionary;
    }
    
    return [encoder bodyDataForObject:postData error:error];
}

@end
