//
//  DCHtmlParser.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCHtmlParser.h"
#import <CoreText/CoreText.h>

@implementation DCHtmlElement
@synthesize offset;
@synthesize length;
@synthesize elements;

-(id) init {
    self = [super init];
    if (self) {
        elements = [[NSMutableArray alloc] init];
    }
    return self;
}


-(NSString*) innerText {
    
    NSMutableString* innerText = [[NSMutableString alloc] init];
    [self addInnerText:innerText];
    return innerText;
}

-(void) addInnerText:(NSMutableString*) innerText {

    if ([[self class] isSubclassOfClass:[DCHtmlTextElement class]]) {
        [innerText appendString:((DCHtmlTextElement*)self).text];
    }
    
    for (DCHtmlTextElement* element in elements) {
        [element addInnerText:innerText];
    }
}

-(BOOL) isSeparateLine {
    return NO;
}


-(void) addToDescendents:(NSMutableArray*) items {

    [items addObject:self];
    
    for (DCHtmlElement* element in elements) {
        [element addToDescendents:items];
    }
}


-(void) addAttributesToAttributesString:(NSMutableAttributedString*) attributedString {

    NSMutableArray* items = [[NSMutableArray alloc] init];
    [self addToDescendents:items];
    
    for (DCHtmlTextElement* element in items) {
    
        if ([[element class] isSubclassOfClass:[DCHtmlTextElement class]]) {
        
            NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
            
            for (DCHtmlElement* atrributeElement in [self elementsThatEncloseTextElement:element fromElements:items]) {
            
                [atrributeElement addAttributesToDictionary:dictionary];
            }
            
            if (dictionary.count > 0) {
                [attributedString addAttributes:dictionary range:NSMakeRange(element.offset, element.length)];
            }
        }
    }
}

-(NSArray*) elementsThatEncloseTextElement:(DCHtmlTextElement*) textElement fromElements:(NSArray*) elementList {

    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    for (DCHtmlElement* element in elementList) {
        if (![[element class] isSubclassOfClass:[DCHtmlTextElement class]] && element.offset <= textElement.offset && element.offset + element.length >= textElement.offset + textElement.length) {
            [items addObject:element];
        }
    }
    
    return items;
}

-(void) addAttributesToDictionary:(NSMutableDictionary*) dictionary {
    
    /*
    NSString *arrow = [[NSString alloc] initWithData:[NSData dataWithBytes:"\u21D2" length:strlen("\u21D2")] encoding:NSUTF8StringEncoding];
    
    [digitsAttr appendAttributedString:[[NSAttributedString alloc] initWithString:arrow]];
    
    CTTextAlignment alignment = kCTCenterTextAlignment;
    CTParagraphStyleSetting _paragraphStyleSettings[1] = {{kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment}};
    CTParagraphStyleRef _paragraphStyleRef = CTParagraphStyleCreate(_paragraphStyleSettings, sizeof(_paragraphStyleSettings) / sizeof(*_paragraphStyleSettings));
    
    if (_paragraphStyleRef) {
        
        [digitsAttr addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)_paragraphStyleRef range:NSMakeRange(startLenght, 1)]; // startLenght is the length of the date string (see pic)
        CFRelease(_paragraphStyleRef);
    }
*/
}

@end


@implementation DCHtmlLinkElement
@synthesize link;

@end


@implementation DCHtmlTypeSettingElement
@synthesize type;

-(void) addAttributesToDictionary:(NSMutableDictionary *)dictionary {

    if (type == DCHtmlTypeSettingElementTypeUnderline) {
        [dictionary setObject:[NSNumber numberWithInt:1] forKey:NSUnderlineStyleAttributeName];
    }
}

@end


@implementation DCHtmlHeaderElement
@synthesize level;

-(BOOL) isSeparateLine {
    return YES;
}

-(void) addAttributesToDictionary:(NSMutableDictionary *)dictionary {
    
    [dictionary setObject:[UIFont systemFontOfSize:[self fontSizeFromLevel]] forKey:NSFontAttributeName];
}

-(int) fontSizeFromLevel {

    if (level == 0) {
        return 50;
    }
    else if (level == 1) {
        return 40;
    }
    else if (level == 2) {
        return 30;
    }
    else if (level == 3) {
        return 25;
    }
    else if (level == 4) {
        return 20;
    }
    else if (level == 5) {
        return 15;
    }
    
    return 12;
}

@end


@implementation DCHtmlFontElement
@synthesize size;
@synthesize color;

-(void) addAttributesToDictionary:(NSMutableDictionary*) dictionary {
    
    [dictionary setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    [dictionary setObject:color forKey:NSForegroundColorAttributeName];
}

@end


@implementation DCHtmlEmoticonElement
@synthesize emoticonName;

@end


@implementation DCHtmlTextElement
@synthesize text;

@end


@implementation DCHtmlParser {

    int _position;
    
    int _textOffset;
    
    NSString* _text;
}


-(DCHtmlElement*) htmlElementParsedFromHtml:(NSString*) html {
    
    _text = html;
    _position = 0;
    _textOffset = 0;
    
    DCHtmlElement* root = [[DCHtmlElement alloc] init];
    root.offset = 0;
    root.elements = [self parseTags];
    root.length = _textOffset;
    return root;
}

-(DCHtmlElement*) htmlElementParsedFromText:(NSString*) text {

    _text = text;
    _position = 0;
    _textOffset = 0;
    
    DCHtmlTextElement* root = [[DCHtmlTextElement alloc] init];
    root.offset = 0;
    root.length = _textOffset;
    root.text = text;
    return root;
}


-(NSMutableArray*) parseTags {

    NSMutableArray* elements = [[NSMutableArray alloc] init];
    
    while (_position <= _text.length - 1) {
        
        [self skipWhitespaces];
        
        if ([self startsWith:@"</"]) {
            break;
        }
        
        
        int textOffset = _textOffset;
        
        DCHtmlElement* element = nil;
        char c = [_text characterAtIndex:_position];
        if (c != '<') {
            element = [self parseText];
        }
        else {
            _position++;
            if ([self startsWith:@"a"]) {
                element = [self parseATag];
            }
            else if ([self startsWith:@"font"]) {
                element = [self parseFontTag];
            }
            else if ([self startsWith:@"br"]) {
                element = [self parseLineBreakTag];
            }
            else if ([self startsWith:@"b"] || [self startsWith:@"i"] || [self startsWith:@"u"]) {
                element = [self parseTypesettingTag];
            }
            else if ([self startsWith:@"h"]) {
                element = [self parseHeaderTag];
            }
            else if ([self startsWith:@"emoticon"]) {
                element = [self parseEmoticonTag];
            }
        }
        
        if (element.isSeparateLine && textOffset > 0) {
            [elements addObject:[self createLineBreakToElements]];
        }
        
        element.offset = textOffset;
        element.length = _textOffset - textOffset;
        [elements addObject:element];
        
        if (element.isSeparateLine) {
            [elements addObject:[self createLineBreakToElements]];
        }
    }
    
    return elements;
}

-(DCHtmlElement*) createLineBreakToElements {

    DCHtmlTextElement* lineBreak = [[DCHtmlTextElement alloc] init];
    lineBreak.text = @"\r\n";
    lineBreak.offset = _textOffset;
    lineBreak.length = 2;
    
    _textOffset += 2;
    
    return lineBreak;
}


-(DCHtmlElement*) parseATag {

    [self skipString:@"a"];

    DCHtmlLinkElement* link = [[DCHtmlLinkElement alloc] init];

    NSDictionary* attributes = [self parseAttributes];
    if ([attributes objectForKey:@"href"]) {
        link.link = [attributes objectForKey:@"href"];
    }
    
    [self skipCharacer:'>'];
    [self skipWhitespaces];
    
    link.elements = [self parseTags];
    
    [self skipString:@"</a>"];
    
    return link;
}

-(DCHtmlElement*) parseFontTag {

    [self skipString:@"font"];
    
    DCHtmlFontElement* tag = [[DCHtmlFontElement alloc] init];
    
    NSDictionary* attributes = [self parseAttributes];
    if ([attributes objectForKey:@"size"]) {
        tag.size = [[attributes objectForKey:@"size"] intValue];
    }
    if ([attributes objectForKey:@"color"]) {
        tag.color = DCColorFromHex([attributes objectForKey:@"color"]);
    }
    
    [self skipCharacer:'>'];
    [self skipWhitespaces];
    
    tag.elements = [self parseTags];
    
    [self skipString:@"</font>"];
    return tag;
}

-(DCHtmlElement*) parseLineBreakTag {

    [self skipString:@"br"];
    [self skipWhitespaces];
    [self skipString:@"/>"];
    
    DCHtmlTextElement* tag = [[DCHtmlTextElement alloc] init];
    tag.text = @"\r\n";
    _textOffset += 2;
    return tag;
}

-(DCHtmlElement*) parseTypesettingTag {

    DCHtmlTypeSettingElement* tag = [[DCHtmlTypeSettingElement alloc] init];
    
    char c = [_text characterAtIndex:_position];
    if (c == 'b') {
        tag.type = DCHtmlTypeSettingElementTypeBold;
    }
    else if (c == 'i') {
        tag.type = DCHtmlTypeSettingElementTypeItalic;
    }
    else if (c == 'u') {
        tag.type = DCHtmlTypeSettingElementTypeUnderline;
    }
    
    _position++;
    [self skipCharacer:'>'];
    [self skipWhitespaces];
    
    tag.elements = [self parseTags];
    
    [self skipString:[NSString stringWithFormat:@"</%c>", c]];
    return tag;
}

-(DCHtmlElement*) parseHeaderTag {
    
    _position++;
    
    char levelChar = [_text characterAtIndex:_position];
    
    DCHtmlHeaderElement* tag = [[DCHtmlHeaderElement alloc] init];
    tag.level = levelChar - 48;
    _position++;
    
    [self skipCharacer:'>'];
    [self skipWhitespaces];
    
    tag.elements = [self parseTags];
    
    [self skipString:[NSString stringWithFormat:@"</h%c>", levelChar]];
    return tag;
}

-(DCHtmlElement*) parseEmoticonTag {

    [self skipString:@"emoticon"];
    [self skipWhitespaces];
    
    [self skipCharacer:'>'];
    
    NSString* name = [self stringUntilCharacter:'<'];
    
    [self skipString:@"</emoticon>"];
    
    DCHtmlEmoticonElement* tag = [[DCHtmlEmoticonElement alloc] init];
    tag.emoticonName = name;
    return tag;
}

-(DCHtmlElement*) parseText {
    
    DCHtmlTextElement* tag = [[DCHtmlTextElement alloc] init];
    tag.text = [self stringUntilCharacter:'<'];
    _textOffset += tag.text.length;
    return tag;
}

-(NSDictionary*) parseAttributes {

    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    [self skipWhitespaces];
    
    while (true) {
        
        NSString* key = [self stringUntilCharacter:'='];
        [self skipCharacer:'='];
        
        [self skipWhitespaces];
        [self skipCharacer:'\''];
        NSString* value = [self stringUntilCharacter:'\''];
        [self skipCharacer:'\''];
        
        [attributes setObject:value forKey:key];
        
        [self skipWhitespaces];
        if ([_text characterAtIndex:_position] == '>') {
            break;
        }
    }
    
    return attributes;
}


-(BOOL) startsWith:(NSString*) s {

    for (int i = 0; i <= s.length - 1; i++) {
        
        if (_position + i > _text.length - 1) {
            return NO;
        }
        
        if ([_text characterAtIndex:_position + i] != [s characterAtIndex:i]) {
            return NO;
        }
    }
    
    return YES;
}

-(NSString*) stringUntilCharacter:(char) character {
    
    NSMutableString* s = [[NSMutableString alloc] init];
    
    while (_position <= _text.length - 1) {
        
        unichar c = [_text characterAtIndex:_position];
        
        if (c == character) {
            break;
        }
        else if (c != '\r' && c != '\n') {
            [s appendFormat:@"%@", [_text substringWithRange:NSMakeRange(_position, 1)]];
        }
        
        _position++;
    }
    
    return s;
}

-(void) skipCharacer:(char) c {
    
    _position++;
}

-(void) skipString:(NSString*) text {
    
    _position += text.length;
}

-(void) skipWhitespaces {
    
    while (_position <= _text.length - 1) {
        
        char c = [_text characterAtIndex:_position];
        if (c == ' ' || c == '\r' || c == '\n' || c == '\t') {
            _position++;
        }
        else {
            break;
        }
    }
}

@end
