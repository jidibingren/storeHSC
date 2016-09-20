@implementation UITableView (SCUtils)

- (void) setEmptyTextView:(NSString *)text {
    [self setEmptyTextView:text textColor:[SCUIFactory colorWithHexString:@"#929292"] bgColor:nil];
    }

- (void)setEmptyTextView:(NSString*)text textColor:(UIColor*)textColor bgColor:(UIColor*)bgColor{
    UIView * backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UITextView* view = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 30)];
    view.userInteractionEnabled = NO;
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont systemFontOfSize:15];
    if (textColor) {
        view.textColor = textColor;
    }
    view.backgroundColor = [UIColor clearColor];
    view.text = text;
    [backGroundView addSubview:view];
#ifdef SC_TP_UITABLEVIEW_NXEMPTYVIEW
    self.nxEV_emptyView = backGroundView;
#endif

}

- (void)setEmptyView:(UIImage *)image text:(NSString*)text{
    [self setEmptyView:image text:text textColor:[SCUIFactory colorWithHexString:@"#cccccc"] bgColor:[UIColor whiteColor]];
}

- (void)setEmptyView:(UIImage *)image text:(NSString*)text textColor:(UIColor*)textColor bgColor:(UIColor*)bgColor{
    UIView * backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backGroundView.backgroundColor = bgColor;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-image.size.width)/2, 64, image.size.width, image.size.height)];
    imageView.image = image;
    [backGroundView addSubview:imageView];
    UITextView* view = [[UITextView alloc]initWithFrame:CGRectMake(0, 64+image.size.height+5, ScreenWidth, 30)];
    view.userInteractionEnabled = NO;
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont systemFontOfSize:18];
    if (textColor) {
        view.textColor = textColor;
    }
    view.backgroundColor = [UIColor clearColor];
    view.text = text;
    [backGroundView addSubview:view];
#ifdef SC_TP_UITABLEVIEW_NXEMPTYVIEW
    self.nxEV_emptyView = backGroundView;
#endif
    
}

- (void) dontShowBlankRows {
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
@end
