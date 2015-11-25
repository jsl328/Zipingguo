//
//  DCHtmlParser.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DCHtmlTypeSettingElementType {
    DCHtmlTypeSettingElementTypeBold,
    DCHtmlTypeSettingElementTypeItalic,
    DCHtmlTypeSettingElementTypeUnderline
};
typedef enum DCHtmlTypeSettingElementType DCHtmlTypeSettingElementType;


@interface DCHtmlElement : NSObject

@property (nonatomic) int offset;
@property (nonatomic) int length;
@property (retain, nonatomic) NSMutableArray* elements;

-(NSString*) innerText;

-(BOOL) isSeparateLine;

-(void) addAttributesToAttributesString:(NSMutableAttributedString*) attributedString;

-(void) addAttributesToDictionary:(NSMutableDictionary*) dictionary;

@end


@interface DCHtmlLinkElement : DCHtmlElement

@property (retain, nonatomic) NSString* link;

@end


@interface DCHtmlTypeSettingElement : DCHtmlElement

@property (nonatomic) DCHtmlTypeSettingElementType type;

@end


@interface DCHtmlHeaderElement : DCHtmlElement

@property (nonatomic) int level;

@end


@interface DCHtmlFontElement: DCHtmlElement

@property (nonatomic) int size;
@property (retain, nonatomic) UIColor* color;

@end


@interface DCHtmlEmoticonElement : DCHtmlElement

@property (retain, nonatomic) NSString* emoticonName;

@end


@interface DCHtmlTextElement : DCHtmlElement

@property (retain, nonatomic) NSString* text;

@end


@interface DCHtmlParser : NSObject

-(DCHtmlElement*) htmlElementParsedFromHtml:(NSString*) html;
-(DCHtmlElement*) htmlElementParsedFromText:(NSString*) text;

@end
