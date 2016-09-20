@implementation UINavigationItem (SCUtils)
- (void) setSpinnerVisible: (BOOL)visible {
    if (visible == [self isSpinnerVisible]) {
        return;
    }
    if (visible) {
        UIActivityIndicatorView *activityIndicator =
            [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem * barButton =
            [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        self.rightBarButtonItem = barButton;
        [activityIndicator startAnimating];
    } else {
        UIActivityIndicatorView* activityIndicator = (UIActivityIndicatorView*)self.rightBarButtonItem.customView;
        [activityIndicator stopAnimating];
        self.rightBarButtonItem = nil;
    }
}

- (BOOL) isSpinnerVisible {
    UIBarButtonItem* barButton = self.rightBarButtonItem;
    return barButton && barButton.customView && [barButton.customView isKindOfClass:[UIActivityIndicatorView class]];
}
@end
