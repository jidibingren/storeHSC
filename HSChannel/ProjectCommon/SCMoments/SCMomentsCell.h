
#import <UIKit/UIKit.h>
#import "SCMomentsOriginalView.h"

@class SCMomentsViewModel,SCMomentsCell,SCMomentsCellCommentBgView,SCOperationMenu;

@protocol SCMomentsCellDelegate <NSObject>

- (void)didClickOpenAllButtonInCell:(SCMomentsCell *)cell;

- (void)didClickDeleteButtonInCell:(SCMomentsCell *)cell;

- (void)didClickLikeButtonInCell:(SCMomentsCell *)cell;

- (void)didClickcCommentButtonInCell:(SCMomentsCell *)cell;

- (void)didTapedComment:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell;

- (void)didClickCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell;

- (void)didLongPressCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell;

@end

@interface SCMomentsCell : UITableViewCell

@property (nonatomic, strong) Class originalViewClass;

@property (nonatomic, strong) Class operationMenuClass;

@property (nonatomic, strong) Class commentBgViewClass;

@property (nonatomic, assign) CGFloat dividerHeight;

@property (nonatomic, strong) UIColor *dividerColor;

@property (nonatomic, weak) id<SCMomentsCellDelegate> delegate;

// 原创
@property (nonatomic, strong) SCMomentsOriginalView *originalView;

@property (nonatomic, strong) SCOperationMenu *operationMenu;

// 回复的tableView
@property (nonatomic, strong) SCMomentsCellCommentBgView *commentBgView;

@property (nonatomic, strong) SCMomentsViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, copy) void (^operationButtonClick)(NSIndexPath *indexPath);

- (void)setupUI;

@end
