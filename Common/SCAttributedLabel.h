//
//  SCAttributedLabel.h
//  ShiHua
//
//  Created by SC on 15/5/2.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+SCAttributedLabel.h"

typedef NS_ENUM(NSInteger,SCVerticalTextAlignment) {
    SCVerticalTextAlignmentTop = 0,
    SCVerticalTextAlignmentMiddle,
    SCVerticalTextAlignmentBottom,
};

@interface SCAttributedLabel : UILabel
@property (nonatomic, copy)   NSAttributedString*       attributedString;
@property (nonatomic)         CGFloat                   lineHeight;
@property (nonatomic)         SCVerticalTextAlignment   verticalTextAlignment;
@property (nonatomic)         CTUnderlineStyle          underlineStyle;
@property (nonatomic)         CTUnderlineStyleModifiers underlineStyleModifier;
@property (nonatomic)         CGFloat                   shadowBlur;             // Default: 0
@property (nonatomic)         CGFloat                   strokeWidth;
@property (nonatomic, strong) UIColor*                  strokeColor;
@property (nonatomic)         CGFloat                   textKern;
@property (nonatomic, copy)   NSString*                 tailTruncationString;
@property (nonatomic, strong) UIColor*                  strikethroughColor;
@property (nonatomic)         CGFloat                   strikethroughWidth;
@property (nonatomic)         CGFloat                   strikethroughAlpha;
@property (nonatomic)         CGFloat                   backgroundAlpha;

- (void)setFont:(UIFont *)font            range:(NSRange)range;
- (void)setStrokeColor:(UIColor *)color   range:(NSRange)range;
- (void)setStrokeWidth:(CGFloat)width     range:(NSRange)range;
- (void)setTextColor:(UIColor *)textColor range:(NSRange)range;
- (void)setTextKern:(CGFloat)kern         range:(NSRange)range;
- (void)setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier range:(NSRange)range;

- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString;
- (void)insertAttributedString:(NSAttributedString *)attrString atIndex:(NSUInteger)loc;
- (void)appendAttributedString:(NSAttributedString *)attrString;
- (void)deleteCharactersInRange:(NSRange)range;

- (void)setBackgroundColor:(UIColor *)color range:(NSRange)range;
- (void)setBackgroundColor:(UIColor *)color atIndex:(NSInteger)index;
- (void)setBackgroundColor:(UIColor *)color size:(CGSize)size atIndex:(NSInteger)index;
- (void)setBackgroundColor:(UIColor *)color offsetPoint:(CGPoint)point size:(CGSize)size atIndex:(NSInteger)index;

- (void)setBackgroundImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)setBackgroundImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins;
- (void)setBackgroundImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins verticalTextAlignment:(SCVerticalTextAlignment)verticalTextAlignment;

- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins;
- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins verticalTextAlignment:(SCVerticalTextAlignment)verticalTextAlignment;

- (void)setStrikethroughWithRange:(NSRange)range;
- (void)setStrikethroughColor:(UIColor *)color range:(NSRange)range;
- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width range:(NSRange)range;
- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width length:(CGFloat)length range:(NSRange)range;
- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width length:(CGFloat)length offset:(CGFloat)offset range:(NSRange)range;
- (void)setStrikethroughLength:(CGFloat)length atIndex:(NSInteger)index;
- (void)setStrikethroughLength:(CGFloat)length offset:(CGFloat)offset atIndex:(NSInteger)index;
- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width length:(CGFloat)length offset:(CGFloat)offset index:(NSInteger)index;
@end
