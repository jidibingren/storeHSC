#ifdef SC_TP_SDWEBIMAGE
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SCUtils)
- (void)setImageWithURLWithProgress:(NSURL *)url {
    [self setSpinnerVisible:YES];
    __unsafe_unretained typeof(self) view = self;
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [view setSpinnerVisible:NO];
    }];
}

- (void)sc_setImageWithURL:(NSString*)url contentMode:(UIViewContentMode)contentMode placeHolderImage:(UIImage*)placeHolderImage placeHolderContentMode:(UIViewContentMode)placeHolderContentMode {
    self.contentMode = placeHolderContentMode;
    self.image = placeHolderImage;
    if (url) {
        DEFINE_WEAK(self);
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            wself.contentMode = contentMode;
        }];
    }
}

- (void)sc_setImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage {
    
    self.image = placeHolderImage;
    
    if (url) {
        
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage completed:nil];
    }
}

@end
#endif