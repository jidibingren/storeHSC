
#import <UIKit/UIKit.h>

@interface UIImage (SCPB)

- (UIImage *) scpb_imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) scpb_imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) scpb_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
