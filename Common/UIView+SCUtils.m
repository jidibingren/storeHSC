@implementation UIView (SCUtils)

char associatedSpinnerKey;
#ifdef SC_TP_TOAST
- (void) makeShortToastAtCenter:(NSString *)toast {
    [self makeToast:toast duration:1.5 position:@"center"];
}

- (void) makeLongToastAtCenter:(NSString *)toast {
    [self makeToast:toast duration:3.0 position:@"center"];
}

- (void) makeToastActivityAndLockSelf
{
    // 创建一个透明的view盖在self上面，截获所有点击事件
    UIView* disableTouchesView = [[UIView alloc]initWithFrame:self.bounds];
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    disableTouchesView.userInteractionEnabled = YES;
    [self addSubview:disableTouchesView];
    
    [self makeToastActivityWithHideCallback:^(void) {
        [disableTouchesView removeFromSuperview];
    }];
}
#endif

- (void) setSpinnerVisible: (BOOL)visible {
    if (visible == [self isSpinnerVisible]) {
        return;
    }
    if (visible) {
        // 居中显示spinner, spinner最大20 * 20
#ifdef SC_TP_UTILS
        CGFloat w = MIN(self.width, 20);
        CGFloat h = MIN(self.height, 20);
        CGFloat x = (self.width - w) / 2;
        CGFloat y = (self.height - h) / 2;
#else
        CGFloat w = MIN(self.frame.size.width, 20);
        CGFloat h = MIN(self.frame.size.height, 20);
        CGFloat x = (self.frame.size.width - w) / 2;
        CGFloat y = (self.frame.size.height - h) / 2;
#endif
        UIActivityIndicatorView *activityIndicator =
            [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
        [self setAssociatedObject:activityIndicator forKey:&associatedSpinnerKey];
    } else {
        UIActivityIndicatorView* activityIndicator = self.spinner;
        [activityIndicator stopAnimating];
        [self setAssociatedObject:nil forKey:&associatedSpinnerKey];
        [activityIndicator removeFromSuperview];
    }
}

- (BOOL) isSpinnerVisible {
    return self.spinner != nil;
}

- (UIActivityIndicatorView*) spinner {
    return [self associatedObjectForKey:&associatedSpinnerKey];
}

- (void) sc_alignToSuperView:(int)alignment {
    CGFloat superW = self.superview.frame.size.width;
    CGFloat superH = self.superview.frame.size.height;

    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    
    assert(superW);
    assert(superH);
    assert(selfW);
    assert(selfH);

    CGFloat x = self.frame.origin.x, y = self.frame.origin.y;
    if (alignment & SCAlignmentLeft) {
      x = 0;
    } else if (alignment & SCAlignmentHCenter) {
      x = (superW - selfW)/2.0;
    } else if (alignment & SCAlignmentRight) {
      x = superW - selfW;
    }

    if (alignment & SCAlignmentTop) {
      y = 0;
    } if (alignment & SCAlignmentVCenter) {
      y = (superH - selfH)/2.0;
    } else if (alignment & SCAlignmentBottom) {
      y = superH - selfH;
    }

    self.frame = CGRectMake(x, y, selfW, selfH);
}
@end


@implementation UIView(Image)

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:currnetContext];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end

