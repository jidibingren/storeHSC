//
//  SCAttributedLabel.m
//  ShiHua
//
//  Created by SC on 15/5/2.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import "SCAttributedLabel.h"


static NSString* const kEllipsesCharacter = @"\u2026";

typedef NS_ENUM(NSInteger, SCAttributedImageType) {
    SCAttributedImageTypeInsert,
    SCAttributedImageTypeBackground
};


CG_INLINE CGFloat SCCGFloatCeil(CGFloat x) {
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)ceil(x);
#else
    return (CGFloat)ceilf(x);
#endif
}

CG_INLINE CGFloat SCCGFloatFloor(CGFloat x) {
#if CGFLOAT_IS_DOUBLE
    return (CGFloat)floor(x);
#else
    return (CGFloat)floorf(x);
#endif
}

#pragma mark - SCAdditionBase implementation

@interface SCAdditionBase : NSObject
@property (nonatomic)   NSInteger  index;
@end

@implementation SCAdditionBase
@end

#pragma mark - SCAttributedLabelImage implementation
@interface SCAttributedLabelImage : SCAdditionBase

- (CGSize)boxSize; // imageSize + margins

@property (nonatomic, strong)   UIImage*                image;
@property (nonatomic)           UIEdgeInsets            margins;
@property (nonatomic)           SCAttributedImageType   imageType;
@property (nonatomic)           SCVerticalTextAlignment verticalTextAlignment;

@property (nonatomic) CGFloat fontAscent;
@property (nonatomic) CGFloat fontDescent;

@end

@implementation SCAttributedLabelImage

- (CGSize)boxSize {
    return CGSizeMake(self.image.size.width + self.margins.left + self.margins.right,
                      self.image.size.height + self.margins.top + self.margins.bottom);
}

@end


#pragma mark - SCAttributedLabelBackgroundImage
@interface SCAttributedLabelBackgroundImage : SCAttributedLabelImage
@end

@implementation SCAttributedLabelBackgroundImage
@end

#pragma mark - SCAttributedLabelInsertImage
@interface SCAttributedLabelInsertImage : SCAttributedLabelImage

@end

@implementation SCAttributedLabelInsertImage

@end

#pragma mark - SCAttributedLabelBackgroundColor implementation

@interface SCAttributedLabelBackgroundColor : SCAdditionBase
@property (nonatomic, strong)   UIColor *     color;
@property (nonatomic)           CGPoint       offsetPoint;
@property (nonatomic)           CGSize        size;
@property (nonatomic)           CGFloat       alpha;
@end

@implementation SCAttributedLabelBackgroundColor

@end

#pragma mark - SCAttributedLabelStrikethrough implementation

@interface SCAttributedLabelStrikethrough : SCAdditionBase
@property (nonatomic, strong)   UIColor *     color;
@property (nonatomic)           CGFloat       width;
@property (nonatomic)           CGFloat       length;
@property (nonatomic)           CGFloat       alpha;
@property (nonatomic)           CGFloat       offset;
@end

@implementation SCAttributedLabelStrikethrough

@end

#pragma mark - SCAttributedLabelAddition implementation

#define GET_ADDITION_ENABLE_SEL(className) \
            NSSelectorFromString([NSString stringWithFormat:\
            @"enable%@",className])
#define SC_DEFINE_ADDITION_SEL(class)\
            - (void)enable##class

@interface SCAttributedLabelAddition : NSObject{
    struct {
        unsigned int hasStrikethrough:1;
        unsigned int hasBackgroundImage:1;
        unsigned int hasBackgroundColor:1;
        unsigned int hasInsertImage:1;
    }_additionFlags;
}
@property (nonatomic)CGFloat fontAscent;
@property (nonatomic)CGFloat fontDescent;
@property (nonatomic)CGSize  fontBoxSize;
@property (nonatomic)SCVerticalTextAlignment verticalTextAlignment;
@property (nonatomic, strong)NSMutableDictionary *additionDic;

@end

@implementation SCAttributedLabelAddition

- (BOOL)hasStrikethrough{
    return _additionFlags.hasStrikethrough==1?YES:NO;
}

- (BOOL)hasBackgroundImage{
    return _additionFlags.hasBackgroundImage==1?YES:NO;
}

- (BOOL)hasBackgroundColor{
    return _additionFlags.hasBackgroundColor==1?YES:NO;
}

- (BOOL)hasInsertImage{
    return _additionFlags.hasInsertImage==1?YES:NO;
}

SC_DEFINE_ADDITION_SEL(SCAttributedLabelStrikethrough){
    _additionFlags.hasStrikethrough = 1;
}

SC_DEFINE_ADDITION_SEL(SCAttributedLabelBackgroundImage){
    _additionFlags.hasBackgroundImage = 1;
}

SC_DEFINE_ADDITION_SEL(SCAttributedLabelBackgroundColor){
    _additionFlags.hasBackgroundColor = 1;
}

SC_DEFINE_ADDITION_SEL(SCAttributedLabelInsertImage){
    
    _additionFlags.hasInsertImage = 1;
}

@end

#pragma mark - SCAttributedLabel implementation


#pragma mark - Additions Support

CGFloat SCDelegateGetAscentCallback(void* refCon) {
    SCAttributedLabelAddition *addition = (__bridge SCAttributedLabelAddition *)refCon;
    CGFloat ascent  = addition.fontAscent;
    CGFloat descent = addition.fontDescent;
    CGSize  boxSize = addition.fontBoxSize;
    SCVerticalTextAlignment verticalTextAlignment = addition.verticalTextAlignment;
    SCAttributedLabelImage *labelImage = nil;
    if ([addition hasInsertImage]) {
        labelImage = [addition.additionDic objectForKey:[SCAttributedLabelInsertImage class]];
        
    }else if ([addition hasBackgroundImage]) {
        labelImage = [addition.additionDic objectForKey:[SCAttributedLabelBackgroundImage class]];
    }
    if (labelImage) {
        ascent = labelImage.fontAscent;
        descent = labelImage.fontDescent;
        boxSize = labelImage.boxSize;
        verticalTextAlignment = labelImage.verticalTextAlignment;
    }
    switch (verticalTextAlignment) {
        case SCVerticalTextAlignmentMiddle:
        {
            CGFloat baselineFromMid = (ascent + descent) / 2 - descent;
            
            return boxSize.height / 2 + baselineFromMid;
        }
        case SCVerticalTextAlignmentTop:
            return ascent;
        case SCVerticalTextAlignmentBottom:
        default:
            return boxSize.height - descent;
    }
}

CGFloat SCDelegateGetDescentCallback(void* refCon) {
    SCAttributedLabelAddition *addition = (__bridge SCAttributedLabelAddition *)refCon;
    CGFloat ascent  = addition.fontAscent;
    CGFloat descent = addition.fontDescent;
    CGSize  boxSize = addition.fontBoxSize;
    SCVerticalTextAlignment verticalTextAlignment = addition.verticalTextAlignment;
    SCAttributedLabelImage *labelImage = nil;
    if ([addition hasInsertImage]) {
        labelImage = [addition.additionDic objectForKey:[SCAttributedLabelInsertImage class]];
        
    }else if ([addition hasBackgroundImage]) {
        labelImage = [addition.additionDic objectForKey:[SCAttributedLabelBackgroundImage class]];
    }
    if (labelImage) {
        ascent = labelImage.fontAscent;
        descent = labelImage.fontDescent;
        boxSize = labelImage.boxSize;
        verticalTextAlignment = labelImage.verticalTextAlignment;
    }
    
    switch (verticalTextAlignment) {
        case SCVerticalTextAlignmentMiddle:
        {
            CGFloat baselineFromMid = (ascent + descent) / 2 - descent;
            return boxSize.height / 2 - baselineFromMid;
        }
        case SCVerticalTextAlignmentTop:
            return boxSize.height - ascent;
        case SCVerticalTextAlignmentBottom:
        default:
            return descent;
    }
}

CGFloat SCDelegateGetWidthCallback(void* refCon) {
    SCAttributedLabelAddition *addition = (__bridge SCAttributedLabelAddition *)refCon;
    CGFloat  width = addition.fontBoxSize.width;
    if ([addition hasInsertImage]) {
        SCAttributedLabelInsertImage *insertImage = [addition.additionDic objectForKey:NSStringFromClass([SCAttributedLabelInsertImage class])];
        width = insertImage.image.size.width + insertImage.margins.left + insertImage.margins.right;
    }
    
    return width;
}

void SCDelegateDeallocateCallback(void* refCon) {
    CFRelease(refCon);
    return;
}
CGSize SCSizeOfAttributedStringConstrainedToSize(NSAttributedString* attributedString, CGSize constraintSize, NSInteger numberOfLines) {
    if (nil == attributedString) {
        return CGSizeZero;
    }
    
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)attributedString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
    assert(NULL != framesetter);
    if (NULL == framesetter) {
        return CGSizeZero;
    }
    CFRange range = CFRangeMake(0, 0);
    
    if (numberOfLines == 1) {
        constraintSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        
    } else if (numberOfLines > 0 && nil != framesetter) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, constraintSize.width, constraintSize.height));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (nil != lines && CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN(numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            range = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        
        CFRelease(frame);
        CFRelease(path);
    }
    
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, constraintSize, NULL);
    
    CFRelease(framesetter);
    
    return CGSizeMake(SCCGFloatCeil(newSize.width), SCCGFloatCeil(newSize.height));
}

@interface SCAttributedLabel ()

@property (nonatomic, strong) NSMutableArray *backgroundImages;
@property (nonatomic, strong) NSMutableArray *insertImages;
@property (nonatomic, strong) NSMutableArray *backgroundColors;
@property (nonatomic, strong) NSMutableArray *strikethroughs;
@property (nonatomic) CTFrameRef textFrame;
@property (nonatomic, strong) NSMutableAttributedString *mutableAttributedString;
@end

@implementation SCAttributedLabel

@synthesize textFrame = _textFrame;

#pragma mark - Class Method
+ (CTTextAlignment)alignmentFromUITextAlignment:(NSTextAlignment)alignment {
    switch (alignment) {
        case NSTextAlignmentLeft: return kCTLeftTextAlignment;
        case NSTextAlignmentCenter: return kCTCenterTextAlignment;
        case NSTextAlignmentRight: return kCTRightTextAlignment;
        case NSTextAlignmentJustified: return kCTJustifiedTextAlignment;
        default: return kCTNaturalTextAlignment;
    }
}

+ (CTLineBreakMode)lineBreakModeFromUILineBreakMode:(NSLineBreakMode)lineBreakMode {
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping: return kCTLineBreakByWordWrapping;
        case NSLineBreakByCharWrapping: return kCTLineBreakByCharWrapping;
        case NSLineBreakByClipping: return kCTLineBreakByClipping;
        case NSLineBreakByTruncatingHead: return kCTLineBreakByTruncatingHead;
        case NSLineBreakByTruncatingTail: return kCTLineBreakByWordWrapping; // We handle truncation ourself.
        case NSLineBreakByTruncatingMiddle: return kCTLineBreakByTruncatingMiddle;
        default: return 0;
    }
}


+ (NSMutableAttributedString *)mutableAttributedStringFromLabel:(UILabel *)label {
    NSMutableAttributedString* attributedString = nil;
    
    if (label.text.length > 0) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
        
        [attributedString setFont:label.font];
        [attributedString setTextColor:label.textColor];
        
        CTTextAlignment textAlignment = [self alignmentFromUITextAlignment:label.textAlignment];
        CTLineBreakMode lineBreak = [self.class lineBreakModeFromUILineBreakMode:label.lineBreakMode];
        
        CGFloat lineHeight = 0;
        if ([label isKindOfClass:[SCAttributedLabel class]]) {
            lineHeight = [(SCAttributedLabel *)label lineHeight];
        }
        [attributedString setTextAlignment:textAlignment lineBreakMode:lineBreak lineHeight:lineHeight];
    }
    
    return attributedString;
}

- (void)dealloc{
    if (NULL != _textFrame) {
        CFRelease(_textFrame);
    }
}

- (CTFrameRef)textFrame {
    if (NULL == _textFrame) {
        NSMutableAttributedString* attributedStringWithLinks = [self mutableAttributedStringWithAdditions];
        CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)attributedStringWithLinks;
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedString);
        assert(NULL != framesetter);
        if (NULL == framesetter) {
            return NULL;
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        assert(NULL != path);
        if (NULL == path) {
            CFRelease(framesetter);
            return NULL;
        }
        
        CGPathAddRect(path, NULL, self.bounds);
        CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        self.textFrame = textFrame;
        if (textFrame) {
            CFRelease(textFrame);
        }
        CGPathRelease(path);
        CFRelease(framesetter);
    }
    
    return _textFrame;
}

- (void)setTextFrame:(CTFrameRef)textFrame {
    // The property is marked 'assign', but retain count for this CFType is managed via this setter
    // and -dealloc.
    if (textFrame != _textFrame) {
        if (NULL != _textFrame) {
            CFRelease(_textFrame);
        }
        if (NULL != textFrame) {
            CFRetain(textFrame);
        }
        _textFrame = textFrame;
    }
}

- (void)_configureDefaults {
    self.verticalTextAlignment = SCVerticalTextAlignmentTop;
    self.strikethroughColor = [UIColor blackColor];
    self.strikethroughWidth = 1.0;
    self.strikethroughAlpha = 1.0;
    self.backgroundAlpha = 1.0;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _configureDefaults];
    }
    return self;
}

- (void)resetTextFrame {
    self.textFrame = NULL;
}

- (void)attributedTextDidChange {
    [self resetTextFrame];
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    BOOL frameDidChange = !CGRectEqualToRect(self.frame, frame);
    
    [super setFrame:frame];
    
    if (frameDidChange) {
        [self attributedTextDidChange];
    }
}


- (CGSize)sizeThatFits:(CGSize)size {
    if (nil == self.mutableAttributedString) {
        return CGSizeZero;
    }
    
    return SCSizeOfAttributedStringConstrainedToSize([self mutableAttributedStringWithAdditions], size, self.numberOfLines);
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:[super intrinsicContentSize]];
}

//#pragma mark - Public Method

- (void)setText:(NSString *)text {
    [super setText:text];
    
    self.attributedText = [[self class] mutableAttributedStringFromLabel:self];
    
    // Apply NIAttributedLabel-specific styles.
    [self.mutableAttributedString setUnderlineStyle:_underlineStyle modifier:_underlineStyleModifier];
    [self.mutableAttributedString setStrokeWidth:_strokeWidth];
    [self.mutableAttributedString setStrokeColor:_strokeColor];
    [self.mutableAttributedString setKern:_textKern];
}


// Deprecated.
- (void)setAttributedString:(NSAttributedString *)attributedString {
    self.attributedText = attributedString;
}

// Deprecated.
- (NSAttributedString *)attributedString {
    return self.attributedText;
}

- (NSAttributedString *)attributedText {
    return [self.mutableAttributedString copy];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (self.mutableAttributedString != attributedText) {
        self.mutableAttributedString = [attributedText mutableCopy];
        
        
        // Remove all images.
        self.backgroundImages = nil;
        self.strikethroughs   = nil;
        self.backgroundColors = nil;
        self.insertImages     = nil;
        
        // Pull any explicit links from the attributed string itself
        
        [self attributedTextDidChange];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    // We assume that the UILabel implementation will call setNeedsDisplay. Where we don't call super
    // we call setNeedsDisplay ourselves.
    if (NSTextAlignmentJustified == textAlignment) {
        // iOS 6.0 Beta 2 crashes when using justified text alignments for some reason.
        [super setTextAlignment:NSTextAlignmentLeft];
    } else {
        [super setTextAlignment:textAlignment];
    }
    
    if (nil != self.mutableAttributedString) {
        CTTextAlignment alignment = [self.class alignmentFromUITextAlignment:textAlignment];
        CTLineBreakMode lineBreak = [self.class lineBreakModeFromUILineBreakMode:self.lineBreakMode];
        [self.mutableAttributedString setTextAlignment:alignment lineBreakMode:lineBreak lineHeight:self.lineHeight];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [super setLineBreakMode:lineBreakMode];
    
    if (nil != self.mutableAttributedString) {
        CTTextAlignment alignment = [self.class alignmentFromUITextAlignment:self.textAlignment];
        CTLineBreakMode lineBreak = [self.class lineBreakModeFromUILineBreakMode:lineBreakMode];
        [self.mutableAttributedString setTextAlignment:alignment lineBreakMode:lineBreak lineHeight:self.lineHeight];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    [self.mutableAttributedString setTextColor:textColor];
    
    [self attributedTextDidChange];
}

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range {
    [self.mutableAttributedString setTextColor:textColor range:range];
    
    [self attributedTextDidChange];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self.mutableAttributedString setFont:font];
    
    [self attributedTextDidChange];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    [self.mutableAttributedString setFont:font range:range];
    
    [self attributedTextDidChange];
}

- (void)setUnderlineStyle:(CTUnderlineStyle)style {
    if (style != _underlineStyle) {
        _underlineStyle = style;
        [self.mutableAttributedString setUnderlineStyle:style modifier:self.underlineStyleModifier];
        
        [self attributedTextDidChange];
    }
}

- (void)setUnderlineStyleModifier:(CTUnderlineStyleModifiers)modifier {
    if (modifier != _underlineStyleModifier) {
        _underlineStyleModifier = modifier;
        [self.mutableAttributedString setUnderlineStyle:self.underlineStyle  modifier:modifier];
        
        [self attributedTextDidChange];
    }
}

- (void)setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier range:(NSRange)range {
    [self.mutableAttributedString setUnderlineStyle:style modifier:modifier range:range];
    
    [self attributedTextDidChange];
}

- (void)setShadowBlur:(CGFloat)shadowBlur {
    if (_shadowBlur != shadowBlur) {
        _shadowBlur = shadowBlur;
        
        [self attributedTextDidChange];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        [self.mutableAttributedString setStrokeWidth:strokeWidth];
        
        [self attributedTextDidChange];
    }
}

- (void)setStrokeWidth:(CGFloat)width range:(NSRange)range {
    [self.mutableAttributedString setStrokeWidth:width range:range];
    
    [self attributedTextDidChange];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    if (_strokeColor != strokeColor) {
        _strokeColor = strokeColor;
        [self.mutableAttributedString setStrokeColor:_strokeColor];
        
        [self attributedTextDidChange];
    }
}

- (void)setStrokeColor:(UIColor*)color range:(NSRange)range {
    [self.mutableAttributedString setStrokeColor:color range:range];
    
    [self attributedTextDidChange];
}

- (void)setTextKern:(CGFloat)textKern {
    if (_textKern != textKern) {
        _textKern = textKern;
        [self.mutableAttributedString setKern:_textKern];
        
        [self attributedTextDidChange];
    }
}

- (void)setTextKern:(CGFloat)kern range:(NSRange)range {
    [self.mutableAttributedString setKern:kern range:range];
    
    [self attributedTextDidChange];
}

- (void)setTailTruncationString:(NSString *)tailTruncationString {
    if (![_tailTruncationString isEqualToString:tailTruncationString]) {
        _tailTruncationString = [tailTruncationString copy];
        
        [self attributedTextDidChange];
    }
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    
    if (nil != self.mutableAttributedString) {
        CTTextAlignment alignment = [self.class alignmentFromUITextAlignment:self.textAlignment];
        CTLineBreakMode lineBreak = [self.class lineBreakModeFromUILineBreakMode:self.lineBreakMode];
        [self.mutableAttributedString setTextAlignment:alignment lineBreakMode:lineBreak lineHeight:self.lineHeight];
        
        [self attributedTextDidChange];
    }
}

- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString{
    if (range.location+range.length <= [_mutableAttributedString length]) {
        [_mutableAttributedString replaceCharactersInRange:range withAttributedString:attrString];
    }
}

- (void)insertAttributedString:(NSAttributedString *)attrString atIndex:(NSUInteger)loc{
    if ([_mutableAttributedString length]<=0) {
        [self setAttributedString:attrString];
    }else{
        [_mutableAttributedString insertAttributedString:attrString atIndex:loc];
    }
}

- (void)appendAttributedString:(NSAttributedString *)attrString{
    if ([_mutableAttributedString length]<=0) {
        [self setAttributedString:attrString];
    }else{
        [_mutableAttributedString appendAttributedString:attrString];
    }
}

- (void)deleteCharactersInRange:(NSRange)range{
    if (range.location+range.length < [_mutableAttributedString length]) {
        [_mutableAttributedString deleteCharactersInRange:range];
    }
}

- (void)setBackgroundColor:(UIColor *)color range:(NSRange)range{
    for (int index = range.location; index < range.location +  range.length; index++) {
        [self setBackgroundColor:color atIndex:index];
    }
}

- (void)setBackgroundColor:(UIColor *)color atIndex:(NSInteger)index{
    [self setBackgroundColor:color size:CGSizeZero atIndex:index];
}
- (void)setBackgroundColor:(UIColor *)color size:(CGSize)size atIndex:(NSInteger)index{
    [self setBackgroundColor:color offsetPoint:CGPointZero size:size atIndex:index];
}

- (void)setBackgroundColor:(UIColor *)color offsetPoint:(CGPoint)point size:(CGSize)size atIndex:(NSInteger)index{
    
    assert(index < [_mutableAttributedString length]);
    
    if (!_backgroundColors) {
        _backgroundColors = [[NSMutableArray alloc]initWithCapacity:1];
    }
    
    SCAttributedLabelBackgroundColor *backgroundColor = [[SCAttributedLabelBackgroundColor alloc]init];
    backgroundColor.index  = index;
    backgroundColor.color  = color;
    backgroundColor.size   = size;
    backgroundColor.alpha  = _backgroundAlpha;
    backgroundColor.offsetPoint  = point;
    [_backgroundColors addObject:backgroundColor];
}

- (void)setBackgroundImage:(UIImage *)image atIndex:(NSInteger)index{
    [self setBackgroundImage:image atIndex:index margins:UIEdgeInsetsZero];
}
- (void)setBackgroundImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins{
    [self setBackgroundImage:image atIndex:index margins:margins verticalTextAlignment:SCVerticalTextAlignmentMiddle];
}

- (void)setBackgroundImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins verticalTextAlignment:(SCVerticalTextAlignment)verticalTextAlignment{
    assert(index < [_mutableAttributedString length]);
    SCAttributedLabelBackgroundImage* labelImage = [[SCAttributedLabelBackgroundImage alloc] init];
    labelImage.index = index;
    labelImage.image = image;
    labelImage.margins = margins;
    labelImage.imageType = SCAttributedImageTypeBackground;
    labelImage.verticalTextAlignment = verticalTextAlignment;
    if (nil == self.backgroundImages) {
        self.backgroundImages = [NSMutableArray array];
    }
    [self.backgroundImages addObject:labelImage];
}

- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index {
    [self insertImage:image atIndex:index margins:UIEdgeInsetsZero verticalTextAlignment:SCVerticalTextAlignmentBottom];
}

- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins {
    [self insertImage:image atIndex:index margins:margins verticalTextAlignment:SCVerticalTextAlignmentBottom];
}

- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins verticalTextAlignment:(SCVerticalTextAlignment)verticalTextAlignment {
    assert(index < [_mutableAttributedString length]);
    SCAttributedLabelInsertImage* labelImage = [[SCAttributedLabelInsertImage alloc] init];
    labelImage.index = index;
    labelImage.image = image;
    labelImage.margins = margins;
    labelImage.imageType = SCAttributedImageTypeInsert;
    labelImage.verticalTextAlignment = verticalTextAlignment;
    if (nil == self.insertImages) {
        self.insertImages = [NSMutableArray array];
    }
    [self.insertImages addObject:labelImage];
}

#pragma mark - Strikethrough
- (void)setStrikethroughWithRange:(NSRange)range{
    [self setStrikethroughColor:_strikethroughColor range:range];
}

- (void)setStrikethroughColor:(UIColor *)color range:(NSRange)range{
    [self setStrikethroughColor:color width:_strikethroughWidth range:range];
}

- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width range:(NSRange)range{
    [self setStrikethroughColor:color width:width length:-1 range:range];
}

- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width length:(CGFloat)length range:(NSRange)range{
    [self setStrikethroughColor:color width:width length:length offset:0 range:range];
}

- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width length:(CGFloat)length offset:(CGFloat)offset range:(NSRange)range{
   
    for (int index = range.location; index < range.location + range.length; index++) {
        [self setStrikethroughColor:color width:width length:length offset:offset index:index];
    }
}

- (void)setStrikethroughColor:(UIColor *)color width:(CGFloat)width length:(CGFloat)length offset:(CGFloat)offset index:(NSInteger)index{
    
    assert(index < [_mutableAttributedString length]);
    
    if (!_strikethroughs) {
        _strikethroughs = [[NSMutableArray alloc]initWithCapacity:1];
    }
    
    SCAttributedLabelStrikethrough *strikethrough = [[SCAttributedLabelStrikethrough alloc]init];
    strikethrough.color  = color;
    strikethrough.width  = width;
    strikethrough.length = length;
    strikethrough.index  = index;
    strikethrough.offset = offset;
    strikethrough.alpha  = _strikethroughAlpha;
    [_strikethroughs addObject:strikethrough];
}

- (void)setStrikethroughLength:(CGFloat)length atIndex:(NSInteger)index{
    [self setStrikethroughLength:length offset:0 atIndex:index];
}

- (void)setStrikethroughLength:(CGFloat)length offset:(CGFloat)offset atIndex:(NSInteger)index{
    [self setStrikethroughColor:_strikethroughColor width:_strikethroughWidth length:length offset:offset range:NSMakeRange(index, 1)];
}

#pragma mark - Private Method

- (CGRect)calculateDrawRect:(SCAttributedLabelAddition *)addition line:(CTLineRef)line run:(CTRunRef)run lineOrigin:(CGPoint)lineOrigin{
    
    CGFloat lineAscent;
    CGFloat lineDescent;
    CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
    CGFloat lineHeight = lineAscent + lineDescent;
    CGFloat lineBottomY = lineOrigin.y - lineDescent;
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    
    CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                       CFRangeMake(0, 1),
                                                       &ascent,
                                                       &descent,
                                                       NULL);
    CGFloat imageBoxHeight = addition.fontBoxSize.height;
    
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
    
    CGFloat imageBoxOriginY = 0.0f;
    switch (addition.verticalTextAlignment) {
        case SCVerticalTextAlignmentTop:
            imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight);
            break;
        case SCVerticalTextAlignmentMiddle:
            imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight) / 2.f;
            break;
        case SCVerticalTextAlignmentBottom:
            imageBoxOriginY = lineBottomY;
            break;
    }
    
    CGRect rect = CGRectMake(lineOrigin.x + xOffset, imageBoxOriginY, width, imageBoxHeight);
    rect = CGRectOffset(rect, 0, -[self _verticalOffsetForBounds:self.bounds]);
    return rect;
}

- (void)drawBackgroundColorInRect:(CGRect)rect addition:(SCAttributedLabelAddition *)addition context:(CGContextRef)context {
    
    SCAttributedLabelBackgroundColor *backgroundColor = [addition.additionDic objectForKey:NSStringFromClass([SCAttributedLabelBackgroundColor class])];
    CGRect reRect = rect;
    reRect.origin.x += backgroundColor.offsetPoint.x;
    reRect.origin.y += backgroundColor.offsetPoint.y;
    if (backgroundColor.size.width>0&&backgroundColor.size.height>0) {
        reRect.size = backgroundColor.size;
    }
    CGContextSetFillColorWithColor(context,backgroundColor.color.CGColor);
    CGContextSetLineWidth(context,0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextBeginPath(context);
    CGContextAddRect(context,reRect);
    CGContextFillRect(context, reRect);
    CGContextSetAlpha(context, backgroundColor.alpha);
    
}

- (void)drawStrikethroughInRect:(CGRect)rect addition:(SCAttributedLabelAddition *)addition context:(CGContextRef)context {
    
    SCAttributedLabelStrikethrough *strikethrough = [addition.additionDic objectForKey:NSStringFromClass([SCAttributedLabelStrikethrough class])];
    CGPoint last = {0};
    CGPoint current = {0};
    CGColorRef color = strikethrough.color.CGColor;
    CGFloat    width = strikethrough.width;
    CGFloat    alpha = strikethrough.alpha;
    
    current.x = rect.origin.x + strikethrough.offset;
    current.y = rect.origin.y + rect.size.height/2;
    last.x    = rect.origin.x + rect.size.width;
    last.y    = rect.origin.y + rect.size.height/2;
    if (strikethrough.length>0) {
        last.x  = rect.origin.x + strikethrough.offset + strikethrough.length;
    }
    
    //    CGContextSetMiterLimit(context, 0.5);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context , kCGLineCapRound);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, last.x, last.y);
    
    CGContextAddLineToPoint(context, current.x, current.y);
    
    CGContextSetLineWidth(context, width);
    
    CGContextSetAlpha(context, alpha);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextStrokePath(context);
}

- (void)drawImageWith:(SCAttributedLabelImage *)labelImage ctx:(CGContextRef)ctx line:(CTLineRef)line run:(CTRunRef)run lineOrigin:(CGPoint)lineOrigin{
    
    CGFloat lineAscent;
    CGFloat lineDescent;
    CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
    CGFloat lineHeight = lineAscent + lineDescent;
    CGFloat lineBottomY = lineOrigin.y - lineDescent;
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    
    CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                       CFRangeMake(0, 1),
                                                       &ascent,
                                                       &descent,
                                                       NULL);
    CGFloat imageBoxHeight = labelImage.boxSize.height;
    
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
    
    CGFloat imageBoxOriginY = 0.0f;
    switch (labelImage.verticalTextAlignment) {
        case SCVerticalTextAlignmentTop:
            imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight);
            break;
        case SCVerticalTextAlignmentMiddle:
            imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight) / 2.f;
            break;
        case SCVerticalTextAlignmentBottom:
            imageBoxOriginY = lineBottomY;
            break;
    }
    
    CGRect rect = CGRectMake(lineOrigin.x + xOffset, imageBoxOriginY, width, imageBoxHeight);
    UIEdgeInsets flippedMargins = labelImage.margins;
    CGFloat top = flippedMargins.top;
    flippedMargins.top = flippedMargins.bottom;
    flippedMargins.bottom = top;
    
    CGRect imageRect = UIEdgeInsetsInsetRect(rect, flippedMargins);
    imageRect = CGRectOffset(imageRect, 0, -[self _verticalOffsetForBounds:self.bounds]);
    CGContextDrawImage(ctx, imageRect, labelImage.image.CGImage);
}

- (void)drawTextAndAdditions:(CGRect)rect{
    
    if (0 == [self.backgroundImages count] && 0 == [self.insertImages count] && 0 == [self.strikethroughs count] && 0 == [self.backgroundColors count]) {
        [self drawAttributedString:self.mutableAttributedString rect:rect];
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CFArrayRef lines = CTFrameGetLines(self.textFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.textFrame, CFRangeMake(0, 0), lineOrigins);
    NSInteger numberOfLines = [self numberOfDisplayedLines];
    for (CFIndex i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CGPoint lineOrigin = lineOrigins[i];
        
        // Iterate through each of the "runs" (i.e. a chunk of text) and find the runs that
        // intersect with the range.
        for (CFIndex k = 0; k < runCount; k++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, k);
            NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(__bridge id)kCTRunDelegateAttributeName];
            if (nil == delegate) {
                CGContextSetTextPosition(ctx, lineOrigin.x, lineOrigin.y);
                CTRunDraw(run, ctx, CFRangeMake(0, 1));
                continue;
            }
            
            SCAttributedLabelAddition * addition = (__bridge SCAttributedLabelAddition *)CTRunDelegateGetRefCon(delegate);
            
            CGRect drawRect = [self calculateDrawRect:addition line:line run:run lineOrigin:lineOrigin];
            if ([addition hasBackgroundColor]) {
//                [self drawBackgroundColorInRect:drawRect addition:addition context:ctx];
            }
            
            if ([addition hasBackgroundImage]) {
                SCAttributedLabelBackgroundImage* labelImage = [addition.additionDic objectForKey:NSStringFromClass([SCAttributedLabelBackgroundImage class])];
                [self drawImageWith:labelImage ctx:ctx line:line run:run lineOrigin:lineOrigin];
            }
            
            if ([addition hasInsertImage]) {
                SCAttributedLabelInsertImage* labelImage = [addition.additionDic objectForKey:NSStringFromClass([SCAttributedLabelInsertImage class])];
                [self drawImageWith:labelImage ctx:ctx line:line run:run lineOrigin:lineOrigin];
            }
            if ([addition hasInsertImage]==NO) {
                CGContextSetTextPosition(ctx, lineOrigin.x, lineOrigin.y);
                CTRunDraw(run, ctx, CFRangeMake(0, 1));
            }
            if ([addition hasStrikethrough]) {
                [self drawStrikethroughInRect:drawRect addition:addition context:ctx];
            }
        }
    }
}


- (void)drawAttributedString:(NSAttributedString *)attributedString rect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CFArrayRef lines = CTFrameGetLines(self.textFrame);
    NSInteger numberOfLines = [self numberOfDisplayedLines];
    
    BOOL truncatesLastLine = (self.lineBreakMode == NSLineBreakByTruncatingTail);
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(self.textFrame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        lineOrigin.y -= rect.origin.y; // adjust for verticalTextAlignment
        CGContextSetTextPosition(ctx, lineOrigin.x, lineOrigin.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        BOOL shouldDrawLine = YES;
        
        if (truncatesLastLine && lineIndex == numberOfLines - 1) {
            // Does the last line need truncation?
            CFRange lastLineRange = CTLineGetStringRange(line);
            if (lastLineRange.location + lastLineRange.length < (CFIndex)attributedString.length) {
                CTLineTruncationType truncationType = kCTLineTruncationEnd;
                NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                
                NSAttributedString* tokenAttributedString;
                {
                    NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition
                                                                         effectiveRange:NULL];
                    NSString* tokenString = ((nil == self.tailTruncationString)
                                             ? kEllipsesCharacter
                                             : self.tailTruncationString);
                    tokenAttributedString = [[NSAttributedString alloc] initWithString:tokenString attributes:tokenAttributes];
                }
                
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenAttributedString);
                
                NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                if (lastLineRange.length > 0) {
                    // Remove any whitespace at the end of the line.
                    unichar lastCharacter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
                    if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharacter]) {
                        [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                    }
                }
                [truncationString appendAttributedString:tokenAttributedString];
                
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                if (!truncatedLine) {
                    // If the line is not as wide as the truncationToken, truncatedLine is NULL
                    truncatedLine = CFRetain(truncationToken);
                }
                CFRelease(truncationLine);
                CFRelease(truncationToken);
                
                CTLineDraw(truncatedLine, ctx);
                CFRelease(truncatedLine);
                
                shouldDrawLine = NO;
            }
        }
        
        if (shouldDrawLine) {
            CTLineDraw(line, ctx);
        }
    }
}

- (void)drawTextInRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGAffineTransform transform = [self _transformForCoreText];
    CGContextConcatCTM(ctx, transform);
    [self drawTextAndAdditions:rect];
    
    if (nil != self.shadowColor) {
        CGContextSetShadowWithColor(ctx, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
    }
    CGContextRestoreGState(ctx);
    
    [super drawTextInRect:rect];
}


- (NSInteger)numberOfDisplayedLines {
    CFArrayRef lines = CTFrameGetLines(self.textFrame);
    return self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
}

- (void)mutableAdditionWith:(NSMutableArray *)additonArray attributedString:(NSMutableAttributedString *)attributedString{
    
    if ([additonArray count] >0) {
        // Sort the label images in reverse order by index so that when we add them the string's indices
        // remain relatively accurate to the original string. This is necessary because we're inserting
        // spaces into the string.
        [additonArray sortUsingComparator:^NSComparisonResult(SCAdditionBase* obj1, SCAdditionBase*  obj2) {
            if (obj1.index < obj2.index) {
                return NSOrderedDescending;
            } else if (obj1.index > obj2.index) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        for (SCAdditionBase *additionItem in additonArray){
            
            NSUInteger index = additionItem.index;
            if (index >= attributedString.length) {
                index = attributedString.length - 1;
            }
            NSDictionary *attributes = [attributedString attributesAtIndex:index effectiveRange:NULL];
            
            NSRange subRange = NSMakeRange(index, 1);
            NSAttributedString *subAttributeStr = [attributedString attributedSubstringFromRange:subRange];
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(__bridge id)kCTRunDelegateAttributeName];
            
            SCAttributedLabelAddition * addition = (__bridge SCAttributedLabelAddition *)CTRunDelegateGetRefCon(delegate);
            if (nil == delegate) {
                addition = [[SCAttributedLabelAddition alloc]init];
                CTRunDelegateCallbacks callbacks;
                addition.verticalTextAlignment = self.verticalTextAlignment;
                memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = SCDelegateGetAscentCallback;
                callbacks.getDescent = SCDelegateGetDescentCallback;
                callbacks.getWidth = SCDelegateGetWidthCallback;
                callbacks.dealloc  = SCDelegateDeallocateCallback;
                
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge_retained void *)addition);
                
                // If this asserts then we're not going to be able to attach the image to the label.
                assert(NULL != delegate);
                if (NULL != delegate) {
                    
                    if ([additionItem isKindOfClass:[SCAttributedLabelInsertImage class]]==YES){

                        unichar objectReplacementChar = 0xFFFC;
                        NSString *objectReplacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
                        NSMutableAttributedString*  space = [[NSMutableAttributedString alloc] initWithString:objectReplacementString];
                        
                        CFMutableAttributedStringRef spaceString = (__bridge_retained CFMutableAttributedStringRef)space;
                        
                        CFRange range = CFRangeMake(0, 1);
                        CFAttributedStringSetAttribute(spaceString, range, kCTRunDelegateAttributeName, delegate);
                        // Explicitly set the writing direction of this string to LTR, because in 'drawImages' we draw
                        // for LTR by drawing at offset to offset + width vs to offset - width as you would for RTL.
                        CFAttributedStringSetAttribute(spaceString,
                                                       range,
                                                       kCTWritingDirectionAttributeName,
                                                       (__bridge CFArrayRef)@[@(kCTWritingDirectionLeftToRight)]);
                        CFRelease(delegate);
                        CFRelease(spaceString);
                        [attributedString insertAttributedString:space atIndex:index];
                    }
                    else{
                        
                        [attributedString addAttribute:(__bridge NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegate range:subRange];
                    }
                }
            }
            
            if (addition.additionDic==nil) {
                addition.additionDic = [[NSMutableDictionary alloc]init];
            }
            [addition.additionDic setValue:additionItem forKey:NSStringFromClass([additionItem class])];
            SEL enableSel = GET_ADDITION_ENABLE_SEL([additionItem class]);
            if ([addition respondsToSelector:enableSel]) {
                [addition performSelector:enableSel];
            }
            
            CTFontRef font = (__bridge CTFontRef)[attributes valueForKey:(__bridge id)kCTFontAttributeName];
            if (font != NULL) {
                addition.fontAscent = CTFontGetAscent(font);
                addition.fontDescent = CTFontGetDescent(font);
                if ([[additionItem class] isSubclassOfClass:[SCAttributedLabelImage class]]==YES) {
                    ((SCAttributedLabelImage *)additionItem).fontAscent = CTFontGetAscent(font);
                    ((SCAttributedLabelImage *)additionItem).fontDescent = CTFontGetDescent(font);
                }
            }
            addition.fontBoxSize = [subAttributeStr size];
        }
    }
}

- (NSMutableAttributedString *)mutableAttributedStringWithAdditions {
    NSMutableAttributedString* attributedString = [self.mutableAttributedString mutableCopy];
   
    [self mutableAdditionWith:_backgroundColors attributedString:attributedString];
    [self mutableAdditionWith:_strikethroughs attributedString:attributedString];
    [self mutableAdditionWith:_backgroundImages attributedString:attributedString];
    [self mutableAdditionWith:_insertImages attributedString:attributedString];
    
    if (self.isHighlighted) {
        [attributedString setTextColor:self.highlightedTextColor];
    }
    
    return attributedString;
}

- (CGFloat)_verticalOffsetForBounds:(CGRect)bounds {
    CGFloat verticalOffset = 0;
    if (SCVerticalTextAlignmentTop != self.verticalTextAlignment) {
        // When the text is attached to the top we can easily just start drawing and leave the
        // remainder. This is the most performant case.
        // With other alignment modes we must calculate the size of the text first.
        CGSize textSize = [self sizeThatFits:CGSizeMake(bounds.size.width, CGFLOAT_MAX)];
        
        if (SCVerticalTextAlignmentMiddle == self.verticalTextAlignment) {
            verticalOffset = SCCGFloatFloor((bounds.size.height - textSize.height) / 2.f);
            
        } else if (SCVerticalTextAlignmentBottom == self.verticalTextAlignment) {
            verticalOffset = bounds.size.height - textSize.height;
        }
    }
    return verticalOffset;
}

- (CGAffineTransform)_transformForCoreText {
    // CoreText context coordinates are the opposite to UIKit so we flip the bounds
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

@end
