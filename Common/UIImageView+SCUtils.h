@interface UIImageView (SCUtils)
// 当加载图片时显示一个菊花,参见[UIView setSpinnerVisible]
- (void)setImageWithURLWithProgress:(NSURL *)url;

// 当加载图片时显示一个PlaceHolder图片，PlaceHolder可以设置单独的contentMode
// 下面的方法可以为真实的图片和placeHolder设置不同的contentMode
// url可以为nil, 那样的话会显示placeHolder
- (void)sc_setImageWithURL:(NSString*)url contentMode:(UIViewContentMode)contentMode placeHolderImage:(UIImage*)placeHolderImage placeHolderContentMode:(UIViewContentMode)placeHolderContentMode;

- (void)sc_setImageWithURL:(NSString*)url placeHolderImage:(UIImage*)placeHolderImage;

@end
