
#import <UIKit/UIKit.h>


/** 点击朋友圈全文的通知 */
extern NSString *const SCMoreButtonClickedNotification;
extern NSString *const SCMoreButtonClickedNotificationKey;

@class SCMomentsOriginalView;

@protocol SCMomentsOriginalViewDelegate <NSObject>

- (void)didClickOpenAllButton:(SCMomentsOriginalView *)originView;
- (void)didClickDeleteButton:(SCMomentsOriginalView *)originView;

@end

@class SCMomentsViewModel;
@class SCPhotoContainerView;

@interface SCMomentsOriginalView : UIView

@property (nonatomic, weak) id<SCMomentsOriginalViewDelegate> delegate;


@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel     *nameLable;
@property (nonatomic, strong)UILabel     *timeLable;
@property (nonatomic, strong)UILabel     *additionLable;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UIButton    *moreButton;
@property (nonatomic, strong)SCPhotoContainerView *photoContainerView;

@property (nonatomic, strong) SCMomentsViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

- (void)setupUI;

@end
