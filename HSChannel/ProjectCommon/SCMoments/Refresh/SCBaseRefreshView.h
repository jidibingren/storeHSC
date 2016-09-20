
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kSCBaseRefreshViewObserveKeyPath;

typedef enum {
    SCWXRefreshViewStateNormal,
    SCWXRefreshViewStateWillRefresh,
    SCWXRefreshViewStateRefreshing,
} SCWXRefreshViewState;

@interface SCBaseRefreshView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)endRefreshing;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInsets;
@property (nonatomic, assign) SCWXRefreshViewState refreshState;

@end
