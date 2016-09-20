
typedef void(^UIAlertViewCallback)(int buttonIndex, int event);
@interface UIAlertView (SCUtils)<UIAlertViewDelegate>
// 设置callback,当button点击时被调用
- (void) setCallback: (UIAlertViewCallback)callback;
@end
