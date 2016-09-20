
@interface UITableView (SCUtils)
// 当TableView没有内容时显示的文字
- (void)setEmptyTextView:(NSString*)text;
- (void)setEmptyTextView:(NSString*)text textColor:(UIColor*)textColor bgColor:(UIColor*)bgColor;
- (void)setEmptyView:(UIImage *)image text:(NSString*)text;
- (void)setEmptyView:(UIImage *)image text:(NSString*)text textColor:(UIColor*)textColor bgColor:(UIColor*)bgColor;

// 当tableView没有充满屏幕，底下可能会显示空行，此方法可以取消之
- (void)dontShowBlankRows;
@end
