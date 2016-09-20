
#import <UIKit/UIKit.h>


@protocol SCMomentsCellCommentViewCellDelegate <NSObject>


- (void)didTapedCell:(SCMomentsCellCommentItemModel *)cellModel;

- (void)didClickLink:(NSString *)linkText cellModel:(SCMomentsCellCommentItemModel *)cellModel;

- (void)didLongPressLink:(NSString *)linkText cellModel:(SCMomentsCellCommentItemModel *)cellModel;

@end

@class SCMomentsCellCommentItemModel;

@interface SCMomentsCellCommentViewCell : UITableViewCell

@property (nonatomic, weak) id <SCMomentsCellCommentViewCellDelegate> delegate;

@property (nonatomic, strong) SCMomentsCellCommentItemModel *status;

//@property (nonatomic, assign ) CGFloat cellHeight;
@end
