//
//  DCRatingControl.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-3-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCRatingControl.h"
#import "DCControlsInternals.h"

@implementation DCRatingControl
@synthesize countOfStars = _countOfStars;
@synthesize value = _value;
@synthesize sizeOfCell = _sizeOfCell;
@synthesize gapBetweenStars = _gapBetweenStars;

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    
    [self setOpaque:NO];
    
    _countOfStars = 5;
    _sizeOfCell = CGSizeMake(50, 50);
    _gapBetweenStars = 10;
    _images = [[NSMutableArray alloc] init];
    
    [self measureContent];
    [self setNeedsDisplay];
}

-(CGSize) intrinsicContentSize {
    return _contentSize;
}

-(void) setEmptyImage:(UIImage *)image {
    [self setImage:image forPercent:0];
}

-(void) setFullImage:(UIImage *)image {
    [self setImage:image forPercent:1];
}

-(void) setImage:(UIImage *)image forPercent:(float)percent {
    
    if (percent == 0) {
        _emptyImage = image;
    }
    else if (percent == 1) {
        _fullImage = image;
    }
    
    
    DCRatingControlImage* item = nil;
    
    for (DCRatingControlImage* image in _images) {
        if (image.percent == percent) {
            item = image;
            break;
        }
    }
    
    if (!item) {
        item = [[DCRatingControlImage alloc] init];
        item.percent = percent;
        [_images insertObject:item atIndex:[self insertIndexForPercent:percent]];
    }
    

    item.image = image;
}

-(int) insertIndexForPercent:(float) percent {

    if (_images.count == 0) {
        return 0;
    }
    else {
    
        int index = -1;
        
        if (_images.count > 1) {
            for (int i = 0; i < _images.count - 1; i++) {
                
                DCRatingControlImage* current = [_images objectAtIndex:i];
                DCRatingControlImage* next = [_images objectAtIndex:i + 1];
                
                if (percent > current.percent && percent <= next.percent) {
                    index = i + 1;
                    break;
                }
            }
        }
        
        if (index == -1) {
            index = percent <= ((DCRatingControlImage*)[_images objectAtIndex:0]).percent ? 0 : _images.count;
        }
        
        return index;
    }
}


-(void) setCountOfStars:(int)countOfStars {
    _countOfStars = countOfStars;
    [self measureContent];
    [self setNeedsDisplay];
}

-(void) setSizeOfCell:(CGSize)sizeOfCell {
    _sizeOfCell = sizeOfCell;
    [self measureContent];
    [self setNeedsDisplay];
}

-(void) setGapBetweenStars:(float)gapBetweenStars {
    _gapBetweenStars = gapBetweenStars;
    [self measureContent];
    [self setNeedsDisplay];
}

-(void) setValue:(float)value {
    
    float newValue = [self coerceValue:value];
    
    if (_value != newValue) {
        
        _value = newValue;
        [self setNeedsDisplay];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


-(float) coerceValue:(float) value {

    if (value < 0) {
        value = 0;
    }
    else if (value > _countOfStars) {
        value = _countOfStars;
    }
    
    return (float)((int)(value * 10)) / 10;
}

-(void) measureContent {

    if (_countOfStars == 0) {
        _contentSize = CGSizeMake(0, _sizeOfCell.height);
    }
    else {
        _contentSize = CGSizeMake((_countOfStars - 1) * _gapBetweenStars + _countOfStars * _sizeOfCell.width, _sizeOfCell.height);
    }
}

-(void) drawRect:(CGRect)rect {
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(c, 1, -1);
    CGContextTranslateCTM(c, 0, -_sizeOfCell.height);
    
    float left = 0;
    
    for (int i = 0; i <= _countOfStars - 1; i++) {
        
        UIImage* image = [self imageForStarAtIndex:i];
        
        if (image) {
            CGSize size = [DCRatingControl sizeOfImage:image containedInSize:_sizeOfCell];
            CGContextDrawImage(c, CGRectMake(left + (_sizeOfCell.width - size.width) / 2, (_sizeOfCell.height - size.height) / 2, size.width, size.height), image.CGImage);
        }
        
        left += _sizeOfCell.width + _gapBetweenStars;
    }
}

+(CGSize) sizeOfImage:(UIImage*) image containedInSize:(CGSize) size {

    if (image.size.width / image.size.height >= size.width / size.height) {
        return CGSizeMake(size.width, size.width * image.size.height / image.size.width);
    }
    else {
        return CGSizeMake(size.height * image.size.width / image.size.height, size.height);
    }
}

-(UIImage*) imageForStarAtIndex:(int) index {

    int integerPart = floor(_value);
    
    if (index <= integerPart - 1) {
        return _fullImage;
    }
    else if (index >= integerPart + 1) {
        return _emptyImage;
    }
    else {
    
        float decimalPart = _value - integerPart;
        
        UIImage* image = _emptyImage;
        
        for (int i = 0; i <= _images.count - 2; i++) {
            
            DCRatingControlImage* current = [_images objectAtIndex:i];
            DCRatingControlImage* next = [_images objectAtIndex:i + 1];
            
            if (decimalPart > current.percent && decimalPart <= next.percent) {
                image = next.image;
                break;
            }
        }
        
        return image;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [super touchesBegan:touches withEvent:event];
    
    if (self.enabled) {
        [self updateValueWithTouches:touches];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    if (self.enabled) {
        [self updateValueWithTouches:touches];
    }
}

-(void) updateValueWithTouches:(NSSet*) touches {

    UITouch* touch = [touches anyObject];
    float x = [touch locationInView:self].x;
    
    self.value = x / _contentSize.width * _countOfStars;
}

@end
