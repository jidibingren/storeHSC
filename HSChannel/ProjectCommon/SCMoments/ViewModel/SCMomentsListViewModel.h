
#import <Foundation/Foundation.h>

@interface SCMomentsListViewModel : NSObject

/// 微博视图模型数组
@property (nonatomic, strong) NSMutableArray *statusList;

@property (nonatomic, strong) NSString *url;

- (void)loadStatus:(BOOL)isNew Completed:(void (^)(BOOL isSuccessed))completed;

- (void)loadStatusWithCount:(NSInteger)count Completed:(void (^)(BOOL isSuccessed))completed;

- (void)loadMoreStatusWithCount:(NSInteger)count Completed:(void (^)(BOOL isSuccessed))completed;

- (void)didClickLikeButtonInCellWithIndexPath:(NSIndexPath *)indexPath success:(void (^)())success failure:(void (^)())failure;

@end
