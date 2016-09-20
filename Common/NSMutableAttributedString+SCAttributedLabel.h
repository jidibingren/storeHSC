//
//  NSAttributedString+SCAttributedLabel.h
//  ShiHua
//
//  Created by SC on 15/5/2.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString(SCAttributedLabel)

/**
 * Sets the text alignment and line break mode for a given range.
 */
- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat)lineHeight
                   range:(NSRange)range;

/**
 * Sets the text alignment and the line break mode for the entire string.
 */
- (void)setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
              lineHeight:(CGFloat)lineHeight;

/**
 * Sets the text color for a given range.
 */
- (void)setTextColor:(UIColor *)color range:(NSRange)range;

/**
 * Sets the text color for the entire string.
 */
- (void)setTextColor:(UIColor *)color;

/**
 * Sets the font for a given range.
 */
- (void)setFont:(UIFont *)font range:(NSRange)range;

/**
 * Sets the font for the entire string.
 */
- (void)setFont:(UIFont *)font;

/**
 * Sets the underline style and modifier for a given range.
 */
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;
/**
 * Sets the underline style and modifier for the entire string.
 */
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;

/**
 * Sets the stroke width for a given range.
 */
- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 * Sets the stroke width for the entire string.
 */
- (void)setStrokeWidth:(CGFloat)width;

/**
 * Sets the stroke color for a given range.
 */
- (void)setStrokeColor:(UIColor *)color range:(NSRange)range;

/**
 * Sets the stroke color for the entire string.
 */
- (void)setStrokeColor:(UIColor *)color;

/**
 * Sets the text kern for a given range.
 */
- (void)setKern:(CGFloat)kern range:(NSRange)range;

/**
 * Sets the text kern for the entire string.
 */
- (void)setKern:(CGFloat)kern;

@end
