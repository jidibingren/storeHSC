@implementation UIAlertView (SCUtils)

char associatedCallbackKey;

- (void) setCallback:(UIAlertViewCallback)callback {
    self.delegate = self;
    [self setAssociatedObject:callback forKey:&associatedCallbackKey];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIAlertViewCallback cb = [self associatedObjectForKey:&associatedCallbackKey];
    if (cb) {
        cb(buttonIndex, 0);
    }
}
@end
