//
//  DCTextPreview.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"

@interface DCLabel : UIView <DCHandleDirection>

@property (nonatomic) float topOffset;
@property (nonatomic) BOOL isTextSelectable;

-(CGSize) documentSize;

-(NSString*) selectedText;

-(NSString*) text;


-(void) setText:(NSString *)text isHtml:(BOOL) isHtml;
-(void) setTextColor:(UIColor*) textColor;
-(void) setHighlightColor:(UIColor*) highlightColor;
-(void) setFontSize:(int) fontSize;

-(void) layout:(int) width;

-(void) findText:(NSString*) text;
-(void) cancelFind;

@end

