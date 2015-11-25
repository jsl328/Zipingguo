//
//  DCDandelionLib.m
//  DandelionDemo
//
//  Created by Bob Li on 14-1-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFunctions.h"
#import "FieldAnnotation.h"
#import "DCEnumAnnotation.h"
#import <CommonCrypto/CommonCrypto.h>

DCLayoutParams* DCLayoutParamsMake(float width, float height) {
    DCLayoutParams* params = [[DCLayoutParams alloc] init];
    params.width = width;
    params.height = height;
    params.horizontalGravity = DCHorizontalGravityLeft;
    params.verticalGravity = DCVerticalGravityCenter;
    params.weight = 1;
    return params;
}

DCMeasureSpec DCMeasureSpecMake(DCMeasureSpecMode mode, float size) {
    DCMeasureSpec spec;
    spec.mode = mode;
    spec.size = size;
    return spec;
}

DCMeasureSpec DCMeasureSpecMakeExactly(float size) {
    DCMeasureSpec spec;
    spec.mode = DCMeasureSpecExactly;
    spec.size = size;
    return spec;
}

DCMeasureSpec DCMeasureSpecMakeAtMost(float size) {
    DCMeasureSpec spec;
    spec.mode = DCMeasureSpecAtMost;
    spec.size = size;
    return spec;
}

DCMeasureSpec DCMeasureSpecMakeUnspecified() {
    DCMeasureSpec spec;
    spec.mode = DCMeasureSpecUnspecified;
    spec.size = 0;
    return spec;
}

int DCNumberFromHexChars(char c1, char c2) {

    int d1 = c1 >= '0' && c1 <= '9' ? c1 - '0' : c1 - 'a' + 10;
    int d2 = c2 >= '0' && c2 <= '9' ? c2 - '0' : c2 - 'a' + 10;
    return d1 * 16 + d2;
}


CGRect DCRectMake(float p1, float p2, float length1, float length2, DCOrientation orientation) {
    
    if (orientation == DCOrientationVertical) {
        return CGRectMake(p1, p2, length1, length2);
    }
    else {
        return CGRectMake(p2, p1, length2, length1);
    }
}


NSString* DCUUIDMake() {
    
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

NSString* DCMD5ForString(NSString* s) {

    const char *cStr = [s UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

float DCMathAbs(float value) {
    return value >= 0 ? value : -value;
}

void DCField(AnnotationProvider* ap, NSString* propertyName, NSString* fieldName) {
    [ap annotateProperty:propertyName withAnnotation:[[FieldAnnotation alloc] initWithFieldName:fieldName]];
}

void DCListField(AnnotationProvider* ap, NSString* propertyName, NSString* fieldName, Class itemType) {
    [ap annotateProperty:propertyName withAnnotation:[[FieldAnnotation alloc] initWithFieldName:fieldName andItemType:itemType]];
}

void DCEnum(AnnotationProvider* ap, NSString* propertyName, NSString* enumName) {
    [ap annotateProperty:propertyName withAnnotation:[[DCEnumAnnotation alloc] initWithName:enumName]];
}

CGRect DCGetFrameInWindow(CGSize size, DCHorizontalGravity horizontalGravity, DCVerticalGravity verticalGravity, UIEdgeInsets padding) {

    CGSize windowSize = [AppContext window].frame.size;
    
    
    float left;
    if (horizontalGravity == DCHorizontalGravityCenter) {
        left = padding.left + (windowSize.width - padding.left - padding.right - size.width) / 2;
    }
    else if (horizontalGravity == DCHorizontalGravityLeft) {
        left = padding.left;
    }
    else if (horizontalGravity == DCHorizontalGravityRight) {
        left = windowSize.width - padding.right - size.width;
    }
    else {
        left = padding.left;
    }
    
    
    float top;
    if (verticalGravity == DCVerticalGravityCenter) {
        top = padding.top + (windowSize.height - padding.top - padding.bottom - size.height) / 2;
    }
    else if (horizontalGravity == DCVerticalGravityTop) {
        top = padding.top;
    }
    else {
        top = windowSize.height - padding.bottom - size.height;
    }
    
    
    return CGRectMake(left, top, size.width, size.height);
}

void DCPerformAnimation(int animationType, BOOL isIn, UIView* view, CGRect targetFrame, id completeCallback) {

    CGSize windowSize = [AppContext window].frame.size;

    float left;
    if ((animationType & DCAnimationTypeMoveLeft) > 0) {
        left = isIn ? windowSize.width : -targetFrame.size.width;
    }
    else if ((animationType & DCAnimationTypeMoveRight) > 0) {
        left = isIn ? -targetFrame.size.width : windowSize.width;
    }
    else {
        left = targetFrame.origin.x;
    }
    
    float top;
    if ((animationType & DCAnimationTypeMoveUp) > 0) {
        top = isIn ? windowSize.height : -targetFrame.size.height;
    }
    else if ((animationType & DCAnimationTypeMoveDown) > 0) {
        top = isIn ? -targetFrame.size.height : windowSize.height;
    }
    else {
        top = targetFrame.origin.y;
    }
    
    CGRect sourceRect = CGRectMake(left, top, targetFrame.size.width, targetFrame.size.height);
    
    
    float dx = sourceRect.origin.x - targetFrame.origin.x;
    float dy = sourceRect.origin.y - targetFrame.origin.y;
    float d = sqrt(dx * dx + dy * dy);
    
    
    float fromAlpha;
    float toAlpha;
    
    if ((animationType & DCAnimationTypeFadeIn) > 0) {
        fromAlpha = 0;
        toAlpha = 1;
    }
    else if ((animationType & DCAnimationTypeFadeOut) > 0) {
        fromAlpha = 1;
        toAlpha = 0;
    }
    else {
        fromAlpha = 1;
        toAlpha = 1;
    }
    
    
    NSTimeInterval duration;
    
    if (d >= 5) {
        duration = [[AppContext settings] durationForPixelDistance:d];
    }
    else if (fromAlpha != toAlpha) {
        duration = 0.2;
    }
    else {
        duration = 0;
    }
    
    
    if (duration == 0) {
        view.frame = targetFrame;
        ((void (^)(void))completeCallback)();
    }
    else {
        
        if (isIn) {
            view.frame = sourceRect;
        }
        
        view.alpha = fromAlpha;
        
        [UIView animateWithDuration:duration animations:^{
            view.frame = isIn ? targetFrame : sourceRect;
            view.alpha = toAlpha;
        } completion:^(BOOL finished) {
            if (finished) {
                ((void (^)(void))completeCallback)();
            }
        }];
    }
}
