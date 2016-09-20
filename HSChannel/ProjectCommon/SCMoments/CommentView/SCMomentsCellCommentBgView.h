
#import <UIKit/UIKit.h>
#import "SCMomentsCellCommentTableView.h"

@class SCMomentsViewModel;

@interface SCMomentsCellCommentBgView : UIImageView

@property (nonatomic, weak) id <SCMomentsCellCommentTableViewDelegate> commentDelegate;

@property (nonatomic, strong) SCMomentsViewModel *viewModel;

@end
