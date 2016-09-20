
@interface UIButton (SCUtils)
// 当加载图片时显示一个菊花,参见[UIView setSpinnerVisible]
- (void)setImageWithURLWithProgress:(NSURL *)url forState:(UIControlState)state;
@end
