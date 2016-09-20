//
//  NSAttributedString+SCAttributedLabel.m
//  ShiHua
//
//  Created by SC on 15/5/2.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import "NSMutableAttributedString+SCAttributedLabel.h"

@implementation NSMutableAttributedString(SCAttributedLabel)

+ (NSLineBreakMode)lineBreakModeFromCTLineBreakMode:(CTLineBreakMode)mode {
    switch (mode) {
        case kCTLineBreakByWordWrapping: return NSLineBreakByWordWrapping;
        case kCTLineBreakByCharWrapping: return NSLineBreakByCharWrapping;
        case kCTLineBreakByClipping: return NSLineBreakByClipping;
        case kCTLineBreakByTruncatingHead: return NSLineBreakByTruncatingHead;
        case kCTLineBreakByTruncatingTail: return NSLineBreakByTruncatingTail;
        case kCTLineBreakByTruncatingMiddle: return NSLineBreakByTruncatingMiddle;
    }
}

- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat)lineHeight
                   range:(NSRange)range {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentFromCTTextAlignment(textAlignment);
    paragraphStyle.lineBreakMode = [[self class] lineBreakModeFromCTLineBreakMode:lineBreakMode];
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.maximumLineHeight = lineHeight;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat)lineHeight {
    [self setTextAlignment:textAlignment
             lineBreakMode:lineBreakMode
                lineHeight:lineHeight
                     range:NSMakeRange(0, self.length)];
}

- (void)setTextColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:NSForegroundColorAttributeName range:range];
    
    if (nil != color) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

- (void)setTextColor:(UIColor *)color {
    [self setTextColor:color range:NSMakeRange(0, self.length)];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    [self removeAttribute:NSFontAttributeName range:range];
    
    if (nil != font) {
        [self addAttribute:NSFontAttributeName value:font range:range];
    }
}

- (void)setFont:(UIFont*)font {
    [self setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range {
    [self removeAttribute:NSUnderlineStyleAttributeName range:range];
    [self addAttribute:NSUnderlineStyleAttributeName value:@(style|modifier) range:range];
}

- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier {
    [self setUnderlineStyle:style modifier:modifier range:NSMakeRange(0, self.length)];
}

- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range {
    [self removeAttribute:NSStrokeWidthAttributeName range:range];
    [self addAttribute:NSStrokeWidthAttributeName value:@(width) range:range];
}

- (void)setStrokeWidth:(CGFloat)width {
    [self setStrokeWidth:width range:NSMakeRange(0, self.length)];
}

- (void)setStrokeColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:NSStrokeColorAttributeName range:range];
    if (nil != color.CGColor) {
        [self addAttribute:NSStrokeColorAttributeName value:color range:range];
    }
}

- (void)setStrokeColor:(UIColor *)color {
    [self setStrokeColor:color range:NSMakeRange(0, self.length)];
}

- (void)setKern:(CGFloat)kern range:(NSRange)range {
    [self removeAttribute:NSKernAttributeName range:range];
    [self addAttribute:NSKernAttributeName value:@(kern) range:range];
}

- (void)setKern:(CGFloat)kern {
    [self setKern:kern range:NSMakeRange(0, self.length)];
}

@end
