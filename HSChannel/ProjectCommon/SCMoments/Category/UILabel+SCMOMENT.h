
#import <UIKit/UIKit.h>

@interface UILabel (SCMOMENT)

+ (UILabel *)scm_labelWithText:(NSString *)text sizeFont:(UIFont *)sizeFont textColor:(UIColor *)textColor;

+ (instancetype)scm_labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;

+ (CGFloat)scm_heightForExpressionText:(NSAttributedString *)expressionText width:(CGFloat)width;
@end
