
#import <UIKit/UIKit.h>

@interface SCMomentsHeaderView : UIView

@property (nonatomic, copy) void (^iconButtonClick)();

- (void)updateHeight:(CGFloat)height;

@end
