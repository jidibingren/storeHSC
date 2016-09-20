
#import <UIKit/UIKit.h>

@protocol SCMomentsCellCommentTableViewDelegate <NSObject>


- (void)didTapedComment:(SCMomentsCellCommentItemModel *)commentModel;

- (void)didClickCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel;

- (void)didLongPressCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel;

@end

@class SCMomentsViewModel;

@interface SCMomentsCellCommentTableView : UITableView

@property (nonatomic, weak) id <SCMomentsCellCommentTableViewDelegate> commentDelegate;

@property (nonatomic, strong) SCMomentsViewModel *viewModel;

@end
