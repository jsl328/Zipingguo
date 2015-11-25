//
//  DCUploadTaskCF.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-11-20.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCUploadTaskCF.h"

#import "DCUploadTask.h"
#import "FileSystem.h"
#import "DCFile.h"

@implementation DCUploadTaskCF {
    
    int _uploadedDataLength;
    
    int _fileLength;
    
    BOOL _isFinished;
}

@synthesize url;
@synthesize filePath;
@synthesize responseData;
@synthesize error = _error;
@synthesize httpMethod = _httpMethod;
@synthesize statusCode;

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"POST";
    }
    return self;
}

-(void) execute {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        @throw DCFileNotFoundExceptionMake([NSString stringWithFormat:@"File not found at %@", filePath]);
        return;
    }
    
    
    _fileLength = [DCFile fileAtPath:filePath].length;
    _uploadedDataLength = 0;
    
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef bodyData = (__bridge CFDataRef)data;
    
    CFStringRef urlString = (__bridge CFStringRef)url;
    CFURLRef myURL = CFURLCreateWithString(kCFAllocatorDefault, urlString, NULL);
    
    CFStringRef requestMethod = (__bridge CFStringRef)_httpMethod;
    CFHTTPMessageRef myRequest =
    CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, myURL,
                               kCFHTTPVersion1_1);
    
    CFStringRef headerFieldName = CFSTR("Content-Type");
    CFStringRef headerFieldValue = CFSTR("application/octet-stream");

    CFHTTPMessageSetBody(myRequest, bodyData);
    CFHTTPMessageSetHeaderFieldValue(myRequest, headerFieldName, headerFieldValue);

    
    headerFieldName = CFSTR("Content-Length");
    headerFieldValue = (__bridge CFStringRef)[NSString stringWithFormat:@"%d", _fileLength];
    CFHTTPMessageSetHeaderFieldValue(myRequest, headerFieldName, headerFieldValue);

    
    
    CFReadStreamRef myReadStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, myRequest);
    
    NSString* timeout = @"_kCFStreamPropertyWriteTimeout";
    CFStringRef timeoutRef = (__bridge CFStringRef)timeout;
    
    double to = 150; // 15s timeout
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberDoubleType, &to);
    CFReadStreamSetProperty(myReadStream, timeoutRef, num);
    CFRelease(num);
    
    
    CFReadStreamOpen(myReadStream);

    NSMutableData* responseBuffer = [[NSMutableData alloc] init];
    
    
    UInt8* buffer = malloc(2048);
    
    while (true) {

        CFIndex count = CFReadStreamRead(myReadStream, buffer, 2048);
        if (count <= 0) {
            
            if (count == -1) {
                CFErrorRef error = CFReadStreamCopyError(myReadStream);
                NSError* error1 = (__bridge NSError*)error;
                
                error1 = nil;
            }
            
            break;
        }
        else {
            [responseBuffer appendBytes:buffer length:count];
        }
    }
    
    free(buffer);
    
    responseData = responseBuffer;
    
    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    s = @"";
    
    
    CFHTTPMessageRef myResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(myReadStream, kCFStreamPropertyHTTPResponseHeader);
    
    statusCode = (int)CFHTTPMessageGetResponseStatusCode(myResponse);
    
    int r = 0;
    r++;
    
    statusCode = 0;
}

@end

