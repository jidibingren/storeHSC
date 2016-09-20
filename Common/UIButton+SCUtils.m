#ifdef SC_TP_SDWEBIMAGE
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation UIButton (SCUtils)
- (void)setImageWithURLWithProgress:(NSURL *)url forState:(UIControlState)state {
    [self setSpinnerVisible:YES];
    __unsafe_unretained typeof(self) view = self;
    [self sd_setImageWithURL:url forState:state placeholderImage:nil options:0
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [view setSpinnerVisible:NO];
    }];
}
@end
#endif
