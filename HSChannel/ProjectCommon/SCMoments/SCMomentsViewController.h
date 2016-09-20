
#import <UIKit/UIKit.h>

@interface SCMomentsViewController : UITableViewController

@property (nonatomic, strong)Class cellClass;

- (void)setupRefreshHeader;

- (void)setupNavBar;

- (void)setupTableView;

- (void)setupHeadView;

- (void)setupFooterRefresh;

- (void)setupNewData;

- (void)loadMoreData;

@end
