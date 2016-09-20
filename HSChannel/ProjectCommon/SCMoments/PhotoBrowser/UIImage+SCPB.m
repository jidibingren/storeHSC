
#import "UIImage+SCPB.h"

@implementation UIImage (SCPB)

- (UIImage *) scpb_imageWithTintColor:(UIColor *)tintColor
{
    return [self scpb_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) scpb_imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self scpb_imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) scpb_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
