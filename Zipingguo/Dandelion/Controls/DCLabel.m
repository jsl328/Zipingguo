//
//  DCTextPreview.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCLabel.h"
#import <CoreText/CoreText.h>
#import <CoreText/CTLine.h>
#import "DCHtmlParser.h"
#import "DCDirectionDispatcher.h"

@implementation DCLabel {

    UIColor* _textColor;
    UIColor* _highlightColor;
    
    CTFontRef _font;
    
    NSMutableAttributedString* _attributedString;
    
    NSMutableArray* _elements;
    
    CTFrameRef _frame;
    CGPathRef _path;
    CTFramesetterRef _framesetter;
    
    CGSize _documentSize;
    
    NSArray* _lines;
    
    
    DCHtmlElement* _root;
    
    NSString* _text;
    
    int _fontSize;
    
    NSString* _searchText;
    
    NSMutableArray* _highlightRects;
    
    int _width;
    
    
    UILongPressGestureRecognizer* _longPressRecognizer;
    
    BOOL _isSelectingText;
    
    int _selectStartLineIndex;
    int _selectStartCharIndex;
    int _selectEndLineIndex;
    int _selectEndCharIndex;
    int _selectStartCharOffset;
    
    int _selectStartX;
    int _selectStartFromY;
    int _selectStartToY;
    int _selectEndX;
    int _selectEndFromY;
    int _selectEndToY;
    int _selectEndCharOffset;
}

@synthesize topOffset = _topOffset;
@synthesize isTextSelectable = _isTextSelectable;


- (id)init
{
    self = [super init];
    if (self) {
        [self setTextColor:[UIColor blackColor]];
        [self setHighlightColor:[UIColor redColor]];
        _fontSize = 20;
        [self setOpaque:NO];
        _highlightRects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(CGSize) documentSize {
    return _documentSize;
}

-(NSString*) selectedText {
    return _isSelectingText ? [_text substringWithRange:NSMakeRange(_selectStartCharIndex, _selectEndCharIndex - _selectStartCharIndex)] : nil;
}

-(NSString*) text {
    return _text;
}

-(void) setTopOffset:(float)topOffset {
    _topOffset = topOffset;
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {
    
    if (!_frame) {
        return;
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_isSelectingText) {
        [self drawSelectedAreaInContext:context];
    }
    
    if (_searchText) {
        
        CGContextTranslateCTM(context, 0, -_topOffset);
        
        
        CGContextSetFillColorWithColor(context, _highlightColor.CGColor);
        
        for (id rectItem in _highlightRects) {
            
            CGRect rect = [(NSValue*)rectItem CGRectValue];
            
            if (rect.origin.y + rect.size.height >= _topOffset && rect.origin.y <= _topOffset + self.frame.size.height) {
                CGContextFillRect(context, rect);
            }
        }
        
        CGContextTranslateCTM(context, 0, _topOffset);
    }
    
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -_documentSize.height + _topOffset);

    CTFrameDraw(_frame, context);
}

-(void) drawSelectedAreaInContext:(CGContextRef) context {

    CGContextSetFillColorWithColor(context, [UIColor magentaColor].CGColor);
 
    CGContextFillRect(context, CGRectMake(_selectStartX, _selectStartFromY - _topOffset, _width - _selectStartX, _selectStartToY - _selectStartFromY));
    CGContextFillRect(context, CGRectMake(0, _selectEndFromY - _topOffset, _selectEndX, _selectEndToY - _selectEndFromY));
    CGContextFillRect(context, CGRectMake(0, _selectStartToY - _topOffset, _width, _selectEndFromY - _selectStartToY));
}


-(void) setText:(NSString *)text isHtml:(BOOL) isHtml {
    
    if (!text || text.length == 0) {
        _root = nil;
        _frame = nil;
    }
    else {
        _root = isHtml ? [[[DCHtmlParser alloc] init] htmlElementParsedFromHtml:text] : [[[DCHtmlParser alloc] init] htmlElementParsedFromText:text];
    
        _text = isHtml ? [_root innerText] : text;
        [self applyText];
    }
    
    [self setNeedsDisplay];
}

-(void) applyText {

    DCHtmlFontElement* root = [[DCHtmlFontElement alloc] init];
    root.length = _text.length;
    root.size = _fontSize;
    root.color = _textColor;
    [root.elements addObject:_root];
    
    _attributedString = [[NSMutableAttributedString alloc] initWithString:_text];
    
    [root addAttributesToAttributesString:_attributedString];
    [self createFrame];
}

-(void) setTextColor:(UIColor *)textColor {

    _textColor = textColor;
}

-(void) setHighlightColor:(UIColor *)highlightColor {
    
    _highlightColor = highlightColor;
    
    if (_searchText) {
        [self setNeedsDisplay];
    }
}

-(void) setFontSize:(int)fontSize {
    _fontSize = fontSize;
    if (_frame) {
        [self applyText];
        [self findHighlightRects];
        [self setNeedsDisplay];
    }
}

-(void) setIsTextSelectable:(BOOL)isTextSelectable {
    _isTextSelectable = isTextSelectable;
    if (_isTextSelectable) {
        [self addLongPressRecognizer];
    }
    else {
        [self removeLongPressRecognizer];
    }
}

-(void) addLongPressRecognizer {
    
    if (!_longPressRecognizer) {
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] init];
        _longPressRecognizer.cancelsTouchesInView = NO;
        [_longPressRecognizer addTarget:self action:@selector(onLongPress:)];
        _longPressRecognizer.allowableMovement = 0;
        [self addGestureRecognizer:_longPressRecognizer];
    }
}

-(void) removeLongPressRecognizer {

    if (_longPressRecognizer) {
        [_longPressRecognizer removeTarget:self action:@selector(onLongPress:)];
        [self removeGestureRecognizer:_longPressRecognizer];
        _longPressRecognizer = nil;
    }
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection) direction touch:(UITouch*) touch xDirection:(int) xDirection yDirection:(int) yDirection {
    return _isSelectingText ? DCDirectionDecisionAccept : DCDirectionDecisionDiscard;
}

-(BOOL) isProperDirection:(DCMoveDirection) direction {
    return NO;
}

-(void) directionTouchesBegan:(UITouch*) touch {
    
    CGPoint point = [touch locationInView:self];
    [self hitTestLineNumberAndCharacterOffsetWithX:point.x y:point.y + _topOffset isStart:YES];
}

-(void) directionTouchesMoved:(UITouch*) touch {

    CGPoint point = [touch locationInView:self];

    _isSelectingText = YES;
    
    [self hitTestLineNumberAndCharacterOffsetWithX:point.x y:point.y + _topOffset isStart:NO];
    [self setNeedsDisplay];
}

-(void) directionTouchesEnded:(UITouch*) touch {
}

-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (!newWindow) {
        [[DCDirectionDispatcher defaultDispatcher] unregisterHandler:self];
        if (_isTextSelectable) {
            [self removeLongPressRecognizer];
        }
    }
    else {
        [[DCDirectionDispatcher defaultDispatcher] registerHandler:self];
        if (_isTextSelectable) {
            [self addLongPressRecognizer];
        }
    }
}

-(void) onLongPress:(UILongPressGestureRecognizer*) recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _isSelectingText = !_isSelectingText;
        if (!_isSelectingText) {
            [self setNeedsDisplay];
        }
    }
}


-(void) findHighlightRects {
    
    if (!_searchText) {
        return;
    }
    
    
    int position = 0;
    NSMutableArray* ranges = [[NSMutableArray alloc] init];
    
    while (true) {

        NSRange range = [_text rangeOfString:_searchText options:0 range:NSMakeRange(position, _text.length - position)];
        if (range.location == NSNotFound) {
            break;
        }
        
        [ranges addObject:[NSValue valueWithRange:range]];
        position = range.location + range.length + 1;
    }

    
    [_highlightRects removeAllObjects];
    
    int index = 0;
    for (id lineItem in _lines) {
    
        CTLineRef line = (__bridge CTLineRef)(lineItem);
        CFRange lineRange = CTLineGetStringRange(line);

        CGPoint lineOrigins[1];
        CTFrameGetLineOrigins(_frame, CFRangeMake(index, 1), lineOrigins);
        
        float lineHeight = [[_text substringWithRange:NSMakeRange(lineRange.location, lineRange.length)] sizeWithFont:[UIFont systemFontOfSize:_fontSize]].height;
        
        
        int linePosition = _documentSize.height - lineOrigins[0].y - lineHeight;
        
        for (id rangeItem in ranges) {
         
            NSRange highlightRange = [(NSValue*)rangeItem rangeValue];
            
            if (highlightRange.location >= lineRange.location && highlightRange.location + highlightRange.length <= lineRange.location + lineRange.length) {
            
                CGFloat* offset1 = NULL;
                float fromOffset = CTLineGetOffsetForStringIndex(line, highlightRange.location, offset1);
                float toOffset = CTLineGetOffsetForStringIndex(line, highlightRange.location + highlightRange.length, offset1);

                CGRect rect = CGRectMake(fromOffset, linePosition, toOffset - fromOffset, lineHeight + 5);
                [_highlightRects addObject:[NSValue valueWithCGRect:rect]];
            }
        }
        
        index++;
    }
}

-(void) hitTestLineNumberAndCharacterOffsetWithX:(int) x y:(int) y isStart:(BOOL) isStart {

    int minIndex = 0;
    int maxIndex = _lines.count;
    int pivotIndex = -1;
    
    int fromY = 0;
    int toY = 0;
    
    while (true) {
    
        if (minIndex >= maxIndex) {
            break;
        }
        
        pivotIndex = (minIndex + maxIndex) / 2;
        
        
        CTLineRef line = (__bridge CTLineRef)([_lines objectAtIndex:pivotIndex]);
        CFRange lineRange = CTLineGetStringRange(line);
        
        CGPoint lineOrigins[1];
        CTFrameGetLineOrigins(_frame, CFRangeMake(pivotIndex, 1), lineOrigins);
        
        float lineHeight = [[_text substringWithRange:NSMakeRange(lineRange.location, lineRange.length)] sizeWithFont:[UIFont systemFontOfSize:_fontSize]].height;
        
        
        toY = _documentSize.height - lineOrigins[0].y;
        fromY = toY - lineHeight;
        
        
        if (y >= fromY && y <= toY) {
            break;
        }
        else if (y < fromY) {
            maxIndex = pivotIndex - 1;
        }
        else {
            minIndex = pivotIndex + 1;
        }
    }
    
    if (pivotIndex == -1) {
        
        if (isStart) {
            _selectStartLineIndex = -1;
        }
        else {
            _selectEndLineIndex = -1;
        }
        
        return;
    }
    
    
    CTLineRef line = (__bridge CTLineRef)([_lines objectAtIndex:pivotIndex]);
    CFRange lineRange = CTLineGetStringRange(line);
    
    float offset = 0;
    int charIndex = -1;
    for (int i = 0; i <= lineRange.length - 1; i++) {
        CGFloat* offset1 = NULL;
        offset = CTLineGetOffsetForStringIndex(line, lineRange.location + i, offset1);
        if (offset > x) {
            charIndex = i - 1;
            break;
        }
    }
    
    
    if (isStart) {
        _selectStartLineIndex = pivotIndex;
        _selectStartCharIndex = charIndex;
        _selectStartX = offset;
        _selectStartFromY = fromY;
        _selectStartToY = toY;
        _selectStartCharIndex = lineRange.location;
    }
    else {
        _selectEndLineIndex = pivotIndex;
        _selectEndCharIndex = charIndex;
        _selectEndX = offset;
        _selectEndFromY = fromY;
        _selectEndToY = toY;
        _selectEndCharIndex = lineRange.location + lineRange.length;
    }
}

-(CFDictionaryRef) createClippingPathsDictionary {
    
    
    NSMutableArray* pathsArray = [[NSMutableArray alloc] init];
    
    
    int r = 0;
    CFNumberRef frameWidth = CFNumberCreate(NULL, kCFNumberNSIntegerType, &r);
    
    CGAffineTransform transform = CGAffineTransformIdentity;

    
    
    CGPathRef clipPath = CGPathCreateWithRect(CGRectMake(10, 20, 200, 200), &transform);
    
    NSDictionary *clippingPathDictionary = [NSDictionary dictionaryWithObject:(__bridge id)(clipPath) forKey:(__bridge NSString *)kCTFramePathClippingPathAttributeName];
    [pathsArray addObject:clippingPathDictionary];
    
    
    
    int eProgression = kCTFrameProgressionTopToBottom;
    CFNumberRef progression = CFNumberCreate(NULL, kCFNumberNSIntegerType, &eProgression);
    
    int eFillRule = kCTFramePathFillEvenOdd;
    CFNumberRef fillRule = CFNumberCreate(NULL, kCFNumberNSIntegerType, &eFillRule);
    
    
    
    
    CFStringRef keys[] = { kCTFrameClippingPathsAttributeName, kCTFramePathFillRuleAttributeName, kCTFrameProgressionAttributeName, kCTFramePathWidthAttributeName};
    CFTypeRef values[] = { (__bridge CFTypeRef)(pathsArray), fillRule, progression, frameWidth};
    
    CFDictionaryRef clippingPathsDictionary = CFDictionaryCreate(NULL,
                                                                 (const void **)&keys, (const void **)&values,
                                                                 sizeof(keys) / sizeof(keys[0]),
                                                                 &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks);
    
    return clippingPathsDictionary;
}

-(void) createFrame {
    
    
    if (_width == 0) {
        return;
    }
    
    
    if (_frame) {
        CFRelease(_frame);
    }
    
    if (_framesetter) {
        CFRelease(_framesetter);
    }
    
    
    _framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    

    
    _path = CGPathCreateWithRect(CGRectMake(0, 0, _documentSize.width, _documentSize.height), NULL);
    
    
    CFRange* range = NULL;
    _documentSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, _text.length), NULL, CGSizeMake(_width, CGFLOAT_MAX), range);
    _documentSize = CGSizeMake(_width, _documentSize.height);
    
    
    _frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), _path, NULL);
    
    _lines = (NSArray*)CTFrameGetLines(_frame);
}

-(void) findText:(NSString*) text {

    _searchText = text;
    
    [self findHighlightRects];
    [self setNeedsDisplay];
}

-(void) cancelFind {
    _searchText = nil;
    [_highlightRects removeAllObjects];
    [self setNeedsDisplay];
}


-(void) layout:(int) width {
    
    if (_attributedString) {
        _width = width;
        [self createFrame];
    }
}

@end
